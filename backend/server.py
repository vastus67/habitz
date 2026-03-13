import logging
import os
import secrets
import uuid
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any

import requests
from dotenv import load_dotenv
from fastapi import APIRouter, Depends, FastAPI, HTTPException, Request, Response, status
from motor.motor_asyncio import AsyncIOMotorClient
from passlib.context import CryptContext
from pydantic import BaseModel, EmailStr, Field
from starlette.middleware.cors import CORSMiddleware

from habitz_seed_data import HABIT_LIBRARY, PLAN_CATALOG


ROOT_DIR = Path(__file__).parent
load_dotenv(ROOT_DIR / ".env")

mongo_url = os.environ["MONGO_URL"]
client = AsyncIOMotorClient(mongo_url)
db = client[os.environ["DB_NAME"]]
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

app = FastAPI(title="Habitz API")
api_router = APIRouter(prefix="/api")

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(name)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)


class RegisterRequest(BaseModel):
    name: str = Field(min_length=2, max_length=80)
    email: EmailStr
    password: str = Field(min_length=8, max_length=128)


class LoginRequest(BaseModel):
    email: EmailStr
    password: str = Field(min_length=8, max_length=128)


class GoogleSessionRequest(BaseModel):
    session_id: str = Field(min_length=4)


class RecommendationRequest(BaseModel):
    goals: list[str] = Field(default_factory=list)
    sex_variant: str | None = None
    fitness_level: str | None = None
    equipment: str | None = None
    wake_time: str | None = None


class OnboardingCompleteRequest(RecommendationRequest):
    name: str = Field(min_length=2, max_length=80)
    habit_keys: list[str] = Field(default_factory=list)
    selected_plan_id: str | None = None


class ProfileUpdateRequest(BaseModel):
    name: str = Field(min_length=2, max_length=80)
    sex_variant: str
    fitness_level: str
    equipment: str
    wake_time: str
    goals: list[str] = Field(default_factory=list)


class HabitToggleRequest(BaseModel):
    completed: bool


class WorkoutStartRequest(BaseModel):
    plan_id: str
    day_id: str | None = None


class WorkoutProgressRequest(BaseModel):
    completed_exercise_ids: list[str] = Field(default_factory=list)


class WorkoutCompleteRequest(BaseModel):
    effort: int = Field(ge=1, le=10)
    note: str | None = Field(default=None, max_length=240)
    duration_minutes: int | None = Field(default=None, ge=1, le=300)


def utc_now() -> datetime:
    return datetime.now(timezone.utc)


def iso_now() -> str:
    return utc_now().isoformat()


def today_key(now: datetime | None = None) -> str:
    value = now or utc_now()
    return value.date().isoformat()


def parse_datetime(value: Any) -> datetime:
    if isinstance(value, datetime):
        return value if value.tzinfo else value.replace(tzinfo=timezone.utc)
    parsed = datetime.fromisoformat(str(value))
    return parsed if parsed.tzinfo else parsed.replace(tzinfo=timezone.utc)


def week_start(now: datetime | None = None) -> datetime:
    current = now or utc_now()
    start = current - timedelta(days=current.weekday())
    return datetime(start.year, start.month, start.day, tzinfo=timezone.utc)


def public_user(user_doc: dict[str, Any]) -> dict[str, Any]:
    return {
        "user_id": user_doc["user_id"],
        "email": user_doc["email"],
        "name": user_doc.get("name", "Athlete"),
        "picture": user_doc.get("picture"),
        "providers": user_doc.get("providers", []),
        "onboarding_completed": user_doc.get("onboarding_completed", False),
        "sex_variant": user_doc.get("sex_variant"),
        "fitness_level": user_doc.get("fitness_level"),
        "equipment": user_doc.get("equipment"),
        "goals": user_doc.get("goals", []),
        "wake_time": user_doc.get("wake_time"),
        "active_plan_id": user_doc.get("active_plan_id"),
    }


def auth_payload(user_doc: dict[str, Any], session_token: str | None = None) -> dict[str, Any]:
    payload = {"user": public_user(user_doc)}
    if session_token is not None:
        payload["session_token"] = session_token
    return payload


def normalize_name(name: str) -> str:
    return " ".join(part for part in name.strip().split() if part)


def equipment_matches(user_equipment: str | None, plan_equipment: str) -> bool:
    compatibility = {
        None: {"none", "home", "gym"},
        "none": {"none"},
        "home": {"none", "home"},
        "gym": {"none", "home", "gym"},
    }
    return plan_equipment in compatibility.get(user_equipment, {"none", "home", "gym"})


def level_rank(level: str | None) -> int:
    order = {None: 0, "beginner": 1, "intermediate": 2, "advanced": 3}
    return order.get(level, 0)


def primary_goal(goals: list[str]) -> str | None:
    priority = ["lose_fat", "build_muscle", "improve_health", "increase_energy"]
    mapping = {
        "lose_fat": "fatloss",
        "build_muscle": "strength",
        "improve_health": "mobility",
        "increase_energy": "mobility",
    }
    for item in priority:
        if item in goals:
            return mapping[item]
    return None


def recommended_habit_keys(goals: list[str]) -> list[str]:
    selected = {"water", "sleep", "workout"}
    if "lose_fat" in goals:
        selected.add("walk")
    if "improve_health" in goals or "increase_energy" in goals:
        selected.add("stretch")
    if "improve_discipline" in goals or "build_daily_habits" in goals:
        selected.add("meditation")
    return [key for key in HABIT_LIBRARY if key in selected]


def find_plan(plan_id: str) -> dict[str, Any] | None:
    for plan in PLAN_CATALOG:
        if plan["plan_id"] == plan_id:
            return plan
    return None


def serialize_plan(plan: dict[str, Any], include_days: bool = False, match_score: int | None = None) -> dict[str, Any]:
    payload = {
        "plan_id": plan["plan_id"],
        "name": plan["name"],
        "goal": plan["goal"],
        "level": plan["level"],
        "sex_variant": plan["sex_variant"],
        "equipment": plan["equipment"],
        "days_per_week": plan["days_per_week"],
        "duration_weeks": plan["duration_weeks"],
        "description": plan["description"],
        "tags": plan["tags"],
        "highlights": plan["highlights"],
        "hero_image": plan["hero_image"],
        "total_workouts": plan["days_per_week"] * plan["duration_weeks"],
    }
    if match_score is not None:
        payload["match_score"] = match_score
    if include_days:
        payload["days"] = plan["days"]
    return payload


def recommend_plans(preferences: dict[str, Any], limit: int = 6) -> list[dict[str, Any]]:
    selected_goal = primary_goal(preferences.get("goals", []))
    selected_sex = preferences.get("sex_variant")
    selected_level = preferences.get("fitness_level")
    selected_equipment = preferences.get("equipment")
    ranked: list[tuple[int, dict[str, Any]]] = []
    for plan in PLAN_CATALOG:
        if selected_sex and plan["sex_variant"] not in {selected_sex, "unisex"}:
            continue
        if selected_equipment and not equipment_matches(selected_equipment, plan["equipment"]):
            continue

        score = 20
        if selected_sex:
            score += 35 if plan["sex_variant"] == selected_sex else 18
        if selected_goal:
            score += 22 if plan["goal"] == selected_goal else 2
        if selected_equipment:
            score += 16 if plan["equipment"] == selected_equipment else 7
        if selected_level:
            delta = abs(level_rank(selected_level) - level_rank(plan["level"]))
            score += {0: 16, 1: 8}.get(delta, 0)
        ranked.append((score, plan))
    ranked.sort(key=lambda item: (-item[0], item[1]["name"]))
    return [serialize_plan(plan, match_score=score) for score, plan in ranked[:limit]]


def next_workout_day(plan: dict[str, Any], completed_day_ids: set[str]) -> dict[str, Any]:
    for current_day in plan["days"]:
        if current_day["day_id"] not in completed_day_ids:
            return current_day
    return plan["days"][0]


def compute_streak(date_keys: set[str]) -> int:
    if not date_keys:
        return 0
    streak = 0
    current = utc_now().date()
    while current.isoformat() in date_keys:
        streak += 1
        current = current - timedelta(days=1)
    return streak


async def create_indexes() -> None:
    await db.users.create_index("user_id", unique=True)
    await db.users.create_index("email", unique=True)
    await db.user_sessions.create_index("session_token", unique=True)
    await db.user_sessions.create_index("user_id")
    await db.habits.create_index([("user_id", 1), ("habit_id", 1)], unique=True)
    await db.habit_logs.create_index([("user_id", 1), ("habit_id", 1), ("date_key", 1)], unique=True)
    await db.active_workouts.create_index("user_id", unique=True)
    await db.workout_sessions.create_index("user_id")


def set_session_cookie(response: Response, session_token: str) -> None:
    response.set_cookie(
        key="session_token",
        value=session_token,
        httponly=True,
        secure=True,
        samesite="none",
        path="/",
        max_age=7 * 24 * 60 * 60,
    )


def clear_session_cookie(response: Response) -> None:
    response.delete_cookie(key="session_token", path="/", samesite="none", secure=True)


async def create_user_session(user_id: str) -> str:
    session_token = f"session_{secrets.token_urlsafe(32)}"
    await db.user_sessions.insert_one(
        {
            "user_id": user_id,
            "session_token": session_token,
            "expires_at": (utc_now() + timedelta(days=7)).isoformat(),
            "created_at": iso_now(),
        }
    )
    return session_token


async def get_current_user(request: Request) -> dict[str, Any]:
    bearer = request.headers.get("Authorization", "")
    session_token = request.cookies.get("session_token")
    if not session_token and bearer.lower().startswith("bearer "):
        session_token = bearer.split(" ", 1)[1].strip()
    if not session_token:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Authentication required")

    session_doc = await db.user_sessions.find_one({"session_token": session_token}, {"_id": 0})
    if not session_doc:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid session")

    expires_at = parse_datetime(session_doc["expires_at"])
    if expires_at < utc_now():
        await db.user_sessions.delete_one({"session_token": session_token})
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Session expired")

    user_doc = await db.users.find_one({"user_id": session_doc["user_id"]}, {"_id": 0})
    if not user_doc:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="User not found")
    return user_doc


async def fetch_habit_logs(user_id: str, days: int = 14) -> list[dict[str, Any]]:
    since = utc_now().date() - timedelta(days=days - 1)
    return await db.habit_logs.find({"user_id": user_id, "date_key": {"$gte": since.isoformat()}}, {"_id": 0}).to_list(500)


async def enrich_habits(user_id: str) -> list[dict[str, Any]]:
    habits = await db.habits.find({"user_id": user_id}, {"_id": 0}).sort("created_at", 1).to_list(100)
    logs = await fetch_habit_logs(user_id)
    today = today_key()
    enriched: list[dict[str, Any]] = []
    for habit in habits:
        habit_logs = [log for log in logs if log["habit_id"] == habit["habit_id"] and log.get("completed")]
        completed_dates = {log["date_key"] for log in habit_logs}
        habit["today_completed"] = today in completed_dates
        habit["streak"] = compute_streak(completed_dates)
        habit["completion_rate"] = round((len(completed_dates) / 14) * 100, 1)
        enriched.append(habit)
    return enriched


async def completed_workout_day_ids(user_id: str, plan_id: str) -> set[str]:
    sessions = await db.workout_sessions.find({"user_id": user_id, "plan_id": plan_id}, {"_id": 0, "day_id": 1}).to_list(500)
    return {session["day_id"] for session in sessions}


async def active_workout_payload(user_id: str) -> dict[str, Any] | None:
    active = await db.active_workouts.find_one({"user_id": user_id}, {"_id": 0})
    if not active:
        return None
    plan = find_plan(active["plan_id"])
    if not plan:
        return None
    day_detail = next((day for day in plan["days"] if day["day_id"] == active["day_id"]), None)
    if not day_detail:
        return None
    return {
        "plan": serialize_plan(plan),
        "day": day_detail,
        "started_at": active["started_at"],
        "updated_at": active["updated_at"],
        "completed_exercise_ids": active.get("completed_exercise_ids", []),
        "progress_percent": round((len(active.get("completed_exercise_ids", [])) / max(len(day_detail["exercises"]), 1)) * 100, 1),
    }


async def dashboard_payload(user_doc: dict[str, Any]) -> dict[str, Any]:
    habits = await enrich_habits(user_doc["user_id"])
    today = today_key()
    today_habits_completed = sum(1 for habit in habits if habit["today_completed"])
    active_plan = find_plan(user_doc.get("active_plan_id")) if user_doc.get("active_plan_id") else None
    recent_habit_logs = await db.habit_logs.find({"user_id": user_doc["user_id"], "completed": True}, {"_id": 0, "date_key": 1, "habit_id": 1}).to_list(1000)
    recent_workout_logs = await db.workout_sessions.find({"user_id": user_doc["user_id"]}, {"_id": 0, "date_key": 1, "plan_id": 1, "completed_at": 1}).to_list(1000)
    weekly_progress = 0.0
    next_day = None
    if active_plan:
        start = week_start().isoformat()
        weekly_sessions = [session for session in recent_workout_logs if session["plan_id"] == active_plan["plan_id"] and session["completed_at"] >= start]
        weekly_progress = min(len(weekly_sessions) / active_plan["days_per_week"], 1.0)
        completed_days = await completed_workout_day_ids(user_doc["user_id"], active_plan["plan_id"])
        next_day = next_workout_day(active_plan, completed_days)

    today_workout_completed = sum(1 for session in recent_workout_logs if session["date_key"] == today)
    total_today_targets = len(habits) + (1 if active_plan else 0)
    total_today_completed = today_habits_completed + (1 if today_workout_completed else 0)
    completion = round(total_today_completed / total_today_targets, 3) if total_today_targets else 0

    streak_dates = {log["date_key"] for log in recent_habit_logs}
    workout_dates = {session["date_key"] for session in recent_workout_logs}
    streak = compute_streak(streak_dates | workout_dates)

    seven_days = [utc_now().date() - timedelta(days=index) for index in range(6, -1, -1)]
    momentum_points: list[float] = []
    for day_value in seven_days:
        key = day_value.isoformat()
        habit_count = sum(1 for log in recent_habit_logs if log["date_key"] == key)
        workout_count = sum(1 for session in recent_workout_logs if session["date_key"] == key)
        denominator = len(habits) + (1 if active_plan else 0)
        momentum_points.append(((habit_count + min(workout_count, 1)) / denominator) if denominator else 0)
    momentum = round(sum(momentum_points) / max(len(momentum_points), 1), 2)

    if completion >= 0.8:
        message = "You are on pace today. Keep the routine clean and finish strong."
    elif completion >= 0.4:
        message = "Momentum is building. Knock out one more habit or your workout to lock in the day."
    else:
        message = "Start with the easiest win on the board and let the streak rebuild from there."

    return {
        "completion": completion,
        "score": int(round(completion * 100)),
        "streak": streak,
        "momentum": momentum,
        "adaptive_message": message,
        "active_plan": serialize_plan(active_plan) if active_plan else None,
        "next_workout_day": next_day,
        "weekly_progress": round(weekly_progress, 3),
        "habits_preview": habits[:4],
        "today_habits_completed": today_habits_completed,
        "today_habits_total": len(habits),
    }


@api_router.get("/")
async def root() -> dict[str, str]:
    return {"message": "Habitz API is running"}


@api_router.post("/auth/register")
async def register(payload: RegisterRequest, response: Response) -> dict[str, Any]:
    email = payload.email.lower()
    existing = await db.users.find_one({"email": email}, {"_id": 0})
    name = normalize_name(payload.name)
    password_hash = pwd_context.hash(payload.password)

    if existing and existing.get("password_hash"):
        raise HTTPException(status_code=400, detail="An account with this email already exists")

    now = iso_now()
    if existing:
        providers = sorted(set(existing.get("providers", []) + ["email"]))
        await db.users.update_one(
            {"user_id": existing["user_id"]},
            {"$set": {"name": name, "password_hash": password_hash, "providers": providers, "updated_at": now}},
        )
        user_doc = await db.users.find_one({"user_id": existing["user_id"]}, {"_id": 0})
    else:
        user_id = f"user_{uuid.uuid4().hex[:12]}"
        user_doc = {
            "user_id": user_id,
            "email": email,
            "name": name,
            "picture": None,
            "password_hash": password_hash,
            "providers": ["email"],
            "created_at": now,
            "updated_at": now,
            "onboarding_completed": False,
            "sex_variant": None,
            "fitness_level": None,
            "equipment": None,
            "goals": [],
            "wake_time": None,
            "active_plan_id": None,
        }
        await db.users.insert_one(user_doc)

    session_token = await create_user_session(user_doc["user_id"])
    set_session_cookie(response, session_token)
    return auth_payload(user_doc, session_token=session_token)


@api_router.post("/auth/login")
async def login(payload: LoginRequest, response: Response) -> dict[str, Any]:
    user_doc = await db.users.find_one({"email": payload.email.lower()}, {"_id": 0})
    if not user_doc or not user_doc.get("password_hash") or not pwd_context.verify(payload.password, user_doc["password_hash"]):
        raise HTTPException(status_code=401, detail="Invalid email or password")
    session_token = await create_user_session(user_doc["user_id"])
    set_session_cookie(response, session_token)
    return auth_payload(user_doc, session_token=session_token)


@api_router.post("/auth/google/session")
async def exchange_google_session(payload: GoogleSessionRequest, response: Response) -> dict[str, Any]:
    session_response = requests.get(
        "https://demobackend.emergentagent.com/auth/v1/env/oauth/session-data",
        headers={"X-Session-ID": payload.session_id},
        timeout=20,
    )
    if session_response.status_code >= 400:
        raise HTTPException(status_code=401, detail="Unable to verify Google session")

    session_data = session_response.json()
    email = session_data["email"].lower()
    user_doc = await db.users.find_one({"email": email}, {"_id": 0})
    now = iso_now()
    if user_doc:
        providers = sorted(set(user_doc.get("providers", []) + ["google"]))
        await db.users.update_one(
            {"user_id": user_doc["user_id"]},
            {
                "$set": {
                    "name": session_data.get("name") or user_doc.get("name") or "Athlete",
                    "picture": session_data.get("picture"),
                    "providers": providers,
                    "updated_at": now,
                }
            },
        )
        user_doc = await db.users.find_one({"user_id": user_doc["user_id"]}, {"_id": 0})
    else:
        user_doc = {
            "user_id": f"user_{uuid.uuid4().hex[:12]}",
            "email": email,
            "name": session_data.get("name") or "Athlete",
            "picture": session_data.get("picture"),
            "password_hash": None,
            "providers": ["google"],
            "created_at": now,
            "updated_at": now,
            "onboarding_completed": False,
            "sex_variant": None,
            "fitness_level": None,
            "equipment": None,
            "goals": [],
            "wake_time": None,
            "active_plan_id": None,
        }
        await db.users.insert_one(user_doc)

    session_token = session_data.get("session_token") or await create_user_session(user_doc["user_id"])
    await db.user_sessions.update_one(
        {"session_token": session_token},
        {
            "$set": {
                "user_id": user_doc["user_id"],
                "session_token": session_token,
                "expires_at": (utc_now() + timedelta(days=7)).isoformat(),
                "created_at": now,
            }
        },
        upsert=True,
    )
    set_session_cookie(response, session_token)
    return auth_payload(user_doc, session_token=session_token)


@api_router.get("/auth/me")
async def auth_me(current_user: dict[str, Any] = Depends(get_current_user)) -> dict[str, Any]:
    return {"user": public_user(current_user)}


@api_router.post("/auth/logout")
async def logout(request: Request, response: Response) -> dict[str, bool]:
    bearer = request.headers.get("Authorization", "")
    session_token = request.cookies.get("session_token")
    if not session_token and bearer.lower().startswith("bearer "):
        session_token = bearer.split(" ", 1)[1].strip()
    if session_token:
        await db.user_sessions.delete_one({"session_token": session_token})
    clear_session_cookie(response)
    return {"ok": True}


@api_router.post("/onboarding/recommendations")
async def onboarding_recommendations(payload: RecommendationRequest, current_user: dict[str, Any] = Depends(get_current_user)) -> dict[str, Any]:
    _ = current_user
    habit_keys = recommended_habit_keys(payload.goals)
    return {
        "plans": recommend_plans(payload.model_dump(), limit=4),
        "habits": [HABIT_LIBRARY[key] for key in habit_keys],
    }


@api_router.post("/onboarding/complete")
async def complete_onboarding(payload: OnboardingCompleteRequest, current_user: dict[str, Any] = Depends(get_current_user)) -> dict[str, Any]:
    selected_plan_id = payload.selected_plan_id
    if selected_plan_id is None:
        recommendations = recommend_plans(payload.model_dump(), limit=1)
        selected_plan_id = recommendations[0]["plan_id"] if recommendations else None
    elif find_plan(selected_plan_id) is None:
        raise HTTPException(status_code=404, detail="Selected plan not found")

    user_update = {
        "name": normalize_name(payload.name),
        "sex_variant": payload.sex_variant,
        "fitness_level": payload.fitness_level,
        "equipment": payload.equipment,
        "goals": payload.goals,
        "wake_time": payload.wake_time,
        "active_plan_id": selected_plan_id,
        "onboarding_completed": True,
        "updated_at": iso_now(),
    }
    await db.users.update_one({"user_id": current_user["user_id"]}, {"$set": user_update})

    selected_habit_keys = [key for key in payload.habit_keys if key in HABIT_LIBRARY]
    if not selected_habit_keys:
        selected_habit_keys = recommended_habit_keys(payload.goals)

    for key in selected_habit_keys:
        habit = HABIT_LIBRARY[key]
        document = {
            "habit_id": f"habit_{current_user['user_id']}_{habit['key']}",
            "user_id": current_user["user_id"],
            "key": habit["key"],
            "title": habit["title"],
            "description": habit["description"],
            "target": habit["target"],
            "unit": habit["unit"],
            "type": habit["type"],
            "category": habit["category"],
            "created_at": iso_now(),
        }
        await db.habits.update_one(
            {"habit_id": document["habit_id"]},
            {"$set": document},
            upsert=True,
        )

    updated_user = await db.users.find_one({"user_id": current_user["user_id"]}, {"_id": 0})
    return {
        "user": public_user(updated_user),
        "active_plan": serialize_plan(find_plan(selected_plan_id)) if selected_plan_id and find_plan(selected_plan_id) else None,
        "habits": await enrich_habits(current_user["user_id"]),
    }


@api_router.get("/profile")
async def get_profile(current_user: dict[str, Any] = Depends(get_current_user)) -> dict[str, Any]:
    return {"user": public_user(current_user)}


@api_router.put("/profile")
async def update_profile(payload: ProfileUpdateRequest, current_user: dict[str, Any] = Depends(get_current_user)) -> dict[str, Any]:
    await db.users.update_one(
        {"user_id": current_user["user_id"]},
        {
            "$set": {
                "name": normalize_name(payload.name),
                "sex_variant": payload.sex_variant,
                "fitness_level": payload.fitness_level,
                "equipment": payload.equipment,
                "wake_time": payload.wake_time,
                "goals": payload.goals,
                "updated_at": iso_now(),
            }
        },
    )
    updated_user = await db.users.find_one({"user_id": current_user["user_id"]}, {"_id": 0})
    return {"user": public_user(updated_user)}


@api_router.get("/plans")
async def get_plans(current_user: dict[str, Any] = Depends(get_current_user)) -> dict[str, Any]:
    preferences = {
        "goals": current_user.get("goals", []),
        "sex_variant": current_user.get("sex_variant"),
        "fitness_level": current_user.get("fitness_level"),
        "equipment": current_user.get("equipment"),
    }
    recommended = recommend_plans(preferences, limit=6)
    return {"plans": recommended if current_user.get("onboarding_completed") else [serialize_plan(plan) for plan in PLAN_CATALOG]}


@api_router.get("/plans/{plan_id}")
async def get_plan_detail(plan_id: str, current_user: dict[str, Any] = Depends(get_current_user)) -> dict[str, Any]:
    _ = current_user
    plan = find_plan(plan_id)
    if not plan:
        raise HTTPException(status_code=404, detail="Plan not found")
    return {"plan": serialize_plan(plan, include_days=True)}


@api_router.post("/plans/{plan_id}/activate")
async def activate_plan(plan_id: str, current_user: dict[str, Any] = Depends(get_current_user)) -> dict[str, Any]:
    plan = find_plan(plan_id)
    if not plan:
        raise HTTPException(status_code=404, detail="Plan not found")
    await db.users.update_one({"user_id": current_user["user_id"]}, {"$set": {"active_plan_id": plan_id, "updated_at": iso_now()}})
    updated_user = await db.users.find_one({"user_id": current_user["user_id"]}, {"_id": 0})
    return {"user": public_user(updated_user), "active_plan": serialize_plan(plan)}


@api_router.get("/dashboard")
async def get_dashboard(current_user: dict[str, Any] = Depends(get_current_user)) -> dict[str, Any]:
    return await dashboard_payload(current_user)


@api_router.get("/habits")
async def get_habits(current_user: dict[str, Any] = Depends(get_current_user)) -> dict[str, Any]:
    return {"habits": await enrich_habits(current_user["user_id"])}


@api_router.patch("/habits/{habit_id}/today")
async def toggle_habit(habit_id: str, payload: HabitToggleRequest, current_user: dict[str, Any] = Depends(get_current_user)) -> dict[str, Any]:
    habit = await db.habits.find_one({"habit_id": habit_id, "user_id": current_user["user_id"]}, {"_id": 0})
    if not habit:
        raise HTTPException(status_code=404, detail="Habit not found")
    await db.habit_logs.update_one(
        {"user_id": current_user["user_id"], "habit_id": habit_id, "date_key": today_key()},
        {
            "$set": {
                "user_id": current_user["user_id"],
                "habit_id": habit_id,
                "date_key": today_key(),
                "completed": payload.completed,
                "updated_at": iso_now(),
            }
        },
        upsert=True,
    )
    habits = await enrich_habits(current_user["user_id"])
    updated = next(item for item in habits if item["habit_id"] == habit_id)
    return {"habit": updated}


@api_router.post("/workouts/start")
async def start_workout(payload: WorkoutStartRequest, current_user: dict[str, Any] = Depends(get_current_user)) -> dict[str, Any]:
    plan = find_plan(payload.plan_id)
    if not plan:
        raise HTTPException(status_code=404, detail="Plan not found")

    if payload.day_id:
        selected_day = next((day for day in plan["days"] if day["day_id"] == payload.day_id), None)
    else:
        completed_days = await completed_workout_day_ids(current_user["user_id"], plan["plan_id"])
        selected_day = next_workout_day(plan, completed_days)
    if not selected_day:
        raise HTTPException(status_code=404, detail="Workout day not found")

    document = {
        "user_id": current_user["user_id"],
        "plan_id": plan["plan_id"],
        "day_id": selected_day["day_id"],
        "completed_exercise_ids": [],
        "started_at": iso_now(),
        "updated_at": iso_now(),
    }
    await db.active_workouts.update_one({"user_id": current_user["user_id"]}, {"$set": document}, upsert=True)
    return {"active_workout": await active_workout_payload(current_user["user_id"])}


@api_router.get("/workouts/active")
async def get_active_workout(current_user: dict[str, Any] = Depends(get_current_user)) -> dict[str, Any]:
    return {"active_workout": await active_workout_payload(current_user["user_id"])}


@api_router.patch("/workouts/active")
async def update_active_workout(payload: WorkoutProgressRequest, current_user: dict[str, Any] = Depends(get_current_user)) -> dict[str, Any]:
    current = await db.active_workouts.find_one({"user_id": current_user["user_id"]}, {"_id": 0})
    if not current:
        raise HTTPException(status_code=404, detail="No active workout")
    plan = find_plan(current["plan_id"])
    if not plan:
        raise HTTPException(status_code=404, detail="Plan not found")
    day_detail = next((day for day in plan["days"] if day["day_id"] == current["day_id"]), None)
    if not day_detail:
        raise HTTPException(status_code=404, detail="Workout day not found")
    allowed = {exercise["exercise_id"] for exercise in day_detail["exercises"]}
    completed_ids = [exercise_id for exercise_id in payload.completed_exercise_ids if exercise_id in allowed]
    await db.active_workouts.update_one(
        {"user_id": current_user["user_id"]},
        {"$set": {"completed_exercise_ids": completed_ids, "updated_at": iso_now()}},
    )
    return {"active_workout": await active_workout_payload(current_user["user_id"])}


@api_router.post("/workouts/complete")
async def complete_workout(payload: WorkoutCompleteRequest, current_user: dict[str, Any] = Depends(get_current_user)) -> dict[str, Any]:
    current = await db.active_workouts.find_one({"user_id": current_user["user_id"]}, {"_id": 0})
    if not current:
        raise HTTPException(status_code=404, detail="No active workout")
    started_at = parse_datetime(current["started_at"])
    duration = payload.duration_minutes or max(int((utc_now() - started_at).total_seconds() // 60), 1)
    log_document = {
        "session_log_id": f"wlog_{uuid.uuid4().hex[:12]}",
        "user_id": current_user["user_id"],
        "plan_id": current["plan_id"],
        "day_id": current["day_id"],
        "completed_exercise_ids": current.get("completed_exercise_ids", []),
        "effort": payload.effort,
        "note": payload.note,
        "duration_minutes": duration,
        "completed_at": iso_now(),
        "date_key": today_key(),
    }
    await db.workout_sessions.insert_one(log_document)
    await db.active_workouts.delete_one({"user_id": current_user["user_id"]})
    plan = find_plan(current["plan_id"])
    day_detail = next((day for day in plan["days"] if day["day_id"] == current["day_id"]), None) if plan else None
    return {
        "summary": {
            "plan_name": plan["name"] if plan else "Workout",
            "day_title": day_detail["title"] if day_detail else "Session",
            "duration_minutes": duration,
            "completed_exercises": len(current.get("completed_exercise_ids", [])),
            "effort": payload.effort,
        }
    }


@api_router.get("/analytics")
async def get_analytics(current_user: dict[str, Any] = Depends(get_current_user)) -> dict[str, Any]:
    habits = await enrich_habits(current_user["user_id"])
    active_plan = find_plan(current_user.get("active_plan_id")) if current_user.get("active_plan_id") else None
    days = [utc_now().date() - timedelta(days=index) for index in range(6, -1, -1)]
    trend = []
    for day_value in days:
        key = day_value.isoformat()
        habit_count = await db.habit_logs.count_documents({"user_id": current_user["user_id"], "date_key": key, "completed": True})
        workout_count = await db.workout_sessions.count_documents({"user_id": current_user["user_id"], "date_key": key})
        trend.append(
            {
                "label": day_value.strftime("%a"),
                "completion": habit_count + min(workout_count, 1),
                "habits": habit_count,
                "workouts": workout_count,
            }
        )

    recent_workouts = await db.workout_sessions.find({"user_id": current_user["user_id"]}, {"_id": 0}).sort("completed_at", -1).to_list(5)
    for workout in recent_workouts:
        plan = find_plan(workout["plan_id"])
        day_detail = next((day for day in plan["days"] if day["day_id"] == workout["day_id"]), None) if plan else None
        workout["plan_name"] = plan["name"] if plan else "Plan"
        workout["day_title"] = day_detail["title"] if day_detail else "Workout"

    total_habit_completion = round(sum(habit["completion_rate"] for habit in habits) / max(len(habits), 1), 1) if habits else 0
    total_workouts = await db.workout_sessions.count_documents({"user_id": current_user["user_id"]})

    return {
        "trend": trend,
        "habit_completion_rate": total_habit_completion,
        "total_workouts": total_workouts,
        "active_plan": serialize_plan(active_plan) if active_plan else None,
        "habit_breakdown": habits,
        "recent_workouts": recent_workouts,
    }


@app.on_event("startup")
async def startup() -> None:
    await create_indexes()
    logger.info("Habitz API started")


app.include_router(api_router)
app.add_middleware(
    CORSMiddleware,
    allow_credentials=True,
    allow_origins=["http://localhost:3000", "http://127.0.0.1:3000"],
    allow_origin_regex=r"https://.*\.emergentagent\.com",
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("shutdown")
async def shutdown_db_client() -> None:
    client.close()
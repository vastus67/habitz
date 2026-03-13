from __future__ import annotations

import re
from typing import Any


GYM_COUPLE_IMAGE = "https://images.unsplash.com/photo-1758875570600-8daf8d2f05f3?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NTY2NjZ8MHwxfHNlYXJjaHwzfHxmaXRuZXNzJTIwdHJhaW5pbmclMjBneW18ZW58MHx8fHwxNzczNDAyMTEwfDA&ixlib=rb-4.1.0&q=85"
CARDIO_ROOM_IMAGE = "https://images.unsplash.com/photo-1765728617805-b9f22d64e5b3?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NTY2NjZ8MHwxfHNlYXJjaHwxfHxmaXRuZXNzJTIwdHJhaW5pbmclMjBneW18ZW58MHx8fHwxNzczNDAyMTEwfDA&ixlib=rb-4.1.0&q=85"
BATTLE_ROPE_IMAGE = "https://images.unsplash.com/photo-1758875569612-94d5e0f1a35f?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NTY2NjZ8MHwxfHNlYXJjaHw0fHxmaXRuZXNzJTIwdHJhaW5pbmclMjBneW18ZW58MHx8fHwxNzczNDAyMTEwfDA&ixlib=rb-4.1.0&q=85"
DIP_BAR_IMAGE = "https://images.unsplash.com/photo-1766287453739-c3ffc3f37d05?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NTY2NjZ8MHwxfHNlYXJjaHwyfHxmaXRuZXNzJTIwdHJhaW5pbmclMjBneW18ZW58MHx8fHwxNzczNDAyMTEwfDA&ixlib=rb-4.1.0&q=85"


def _slugify(value: str) -> str:
    return re.sub(r"[^a-z0-9]+", "-", value.lower()).strip("-")


def exercise(
    name: str,
    sets: int,
    reps: str,
    rest_seconds: int,
    instructions: str,
    equipment: str,
) -> dict[str, Any]:
    return {
        "exercise_id": _slugify(name),
        "name": name,
        "sets": sets,
        "reps": reps,
        "rest_seconds": rest_seconds,
        "instructions": instructions,
        "equipment": equipment,
    }


def day(day_index: int, title: str, focus: str, exercises: list[dict[str, Any]]) -> dict[str, Any]:
    return {
        "day_id": f"day-{day_index}",
        "day_index": day_index,
        "title": title,
        "focus": focus,
        "exercises": exercises,
    }


def plan(
    plan_id: str,
    name: str,
    goal: str,
    level: str,
    sex_variant: str,
    equipment: str,
    days_per_week: int,
    duration_weeks: int,
    description: str,
    tags: list[str],
    highlights: list[str],
    hero_image: str,
    days: list[dict[str, Any]],
) -> dict[str, Any]:
    return {
        "plan_id": plan_id,
        "name": name,
        "goal": goal,
        "level": level,
        "sex_variant": sex_variant,
        "equipment": equipment,
        "days_per_week": days_per_week,
        "duration_weeks": duration_weeks,
        "description": description,
        "tags": tags,
        "highlights": highlights,
        "hero_image": hero_image,
        "days": days,
    }


PLAN_CATALOG: list[dict[str, Any]] = [
    plan(
        plan_id="reset-bodyweight-foundation",
        name="Reset Bodyweight Foundation",
        goal="fatloss",
        level="beginner",
        sex_variant="unisex",
        equipment="none",
        days_per_week=3,
        duration_weeks=4,
        description="A low-friction plan to rebuild consistency, burn calories, and establish a repeatable weekly rhythm.",
        tags=["bodyweight", "starter", "fat-loss"],
        highlights=["Short sessions", "No equipment", "Consistency-first"],
        hero_image=BATTLE_ROPE_IMAGE,
        days=[
            day(
                1,
                "Upper Body Reset",
                "Pressing strength and trunk control",
                [
                    exercise("Push-Up", 3, "10-12", 45, "Keep your ribs down and body aligned.", "none"),
                    exercise("Incline Push-Up", 3, "12", 45, "Use a bench or sturdy surface for quality reps.", "none"),
                    exercise("Dead Bug", 3, "12/side", 30, "Brace hard and move slowly.", "none"),
                ],
            ),
            day(
                2,
                "Lower Body Reset",
                "Leg endurance and hip control",
                [
                    exercise("Bodyweight Squat", 4, "15", 45, "Sit between your hips and drive through mid-foot.", "none"),
                    exercise("Glute Bridge", 3, "15", 30, "Pause at the top for one second.", "none"),
                    exercise("Reverse Lunge", 3, "10/leg", 45, "Keep the front foot grounded the whole time.", "none"),
                ],
            ),
            day(
                3,
                "Conditioning Circuit",
                "Heart rate and movement quality",
                [
                    exercise("Jumping Jacks", 3, "40s", 20, "Keep a steady pace and breathe through the reps.", "none"),
                    exercise("Mountain Climbers", 3, "30s", 20, "Drive knees forward without piking your hips.", "none"),
                    exercise("Plank", 3, "35s", 30, "Squeeze glutes and keep the chin tucked.", "none"),
                ],
            ),
        ],
    ),
    plan(
        plan_id="unisex-home-mobility-reset",
        name="Home Mobility Reset",
        goal="mobility",
        level="beginner",
        sex_variant="unisex",
        equipment="home",
        days_per_week=3,
        duration_weeks=4,
        description="A joint-friendly recovery plan focused on posture, mobility, and better daily energy.",
        tags=["mobility", "recovery", "home"],
        highlights=["Recovery emphasis", "Daily energy", "Joint-friendly"],
        hero_image=CARDIO_ROOM_IMAGE,
        days=[
            day(
                1,
                "Shoulder + Spine",
                "Posture, upper back, and breathing",
                [
                    exercise("Band Pull-Apart", 3, "15", 30, "Move from your shoulder blades, not your wrists.", "home"),
                    exercise("Thoracic Rotation", 3, "8/side", 20, "Rotate smoothly and keep your hips stacked.", "none"),
                    exercise("Wall Slide", 3, "10", 30, "Maintain a flat lower back through the motion.", "none"),
                ],
            ),
            day(
                2,
                "Hips + Ankles",
                "Range of motion and lower body comfort",
                [
                    exercise("Goblet Squat Hold", 3, "30s", 30, "Sink deep while keeping the chest proud.", "home"),
                    exercise("90/90 Hip Switch", 3, "10", 20, "Rotate from the hips instead of the spine.", "none"),
                    exercise("Calf Rocker", 3, "12/side", 20, "Drive the knee over the toes with control.", "none"),
                ],
            ),
            day(
                3,
                "Core + Reset",
                "Breathing, anti-rotation, and trunk balance",
                [
                    exercise("Bird Dog", 3, "10/side", 25, "Reach long through fingertips and heel.", "none"),
                    exercise("Pallof Press", 3, "12/side", 30, "Resist rotation and keep the ribs stacked.", "home"),
                    exercise("Child's Pose Breathing", 3, "5 breaths", 20, "Slow exhale on every rep.", "none"),
                ],
            ),
        ],
    ),
    plan(
        plan_id="male-upper-lower-foundation",
        name="Male Upper / Lower Foundation",
        goal="strength",
        level="beginner",
        sex_variant="male",
        equipment="gym",
        days_per_week=4,
        duration_weeks=6,
        description="A classic strength split designed for male onboarding selections, with balanced upper and lower volume.",
        tags=["male", "gym", "strength"],
        highlights=["Upper/lower split", "Progressive overload", "Beginner-friendly"],
        hero_image=DIP_BAR_IMAGE,
        days=[
            day(
                1,
                "Upper Push",
                "Chest, shoulders, and triceps",
                [
                    exercise("Bench Press", 4, "6-8", 90, "Pull shoulders down and drive feet into the floor.", "gym"),
                    exercise("Incline Dumbbell Press", 3, "8-10", 75, "Control the lowering phase fully.", "gym"),
                    exercise("Cable Fly", 3, "12", 45, "Keep a soft bend in the elbows.", "gym"),
                ],
            ),
            day(
                2,
                "Lower Strength",
                "Quads, glutes, and bracing",
                [
                    exercise("Back Squat", 4, "5-6", 90, "Brace before every rep and stay rooted.", "gym"),
                    exercise("Romanian Deadlift", 3, "8", 75, "Push hips back and keep the bar close.", "gym"),
                    exercise("Leg Press", 3, "10", 60, "Use full foot pressure and smooth tempo.", "gym"),
                ],
            ),
            day(
                3,
                "Upper Pull",
                "Back width and pulling strength",
                [
                    exercise("Lat Pulldown", 4, "8-10", 75, "Drive elbows down to your ribs.", "gym"),
                    exercise("Chest Supported Row", 3, "10", 60, "Pause at the top of each pull.", "gym"),
                    exercise("Face Pull", 3, "15", 45, "Finish with knuckles by the temples.", "gym"),
                ],
            ),
            day(
                4,
                "Lower + Core",
                "Posterior chain and trunk control",
                [
                    exercise("Trap Bar Deadlift", 4, "5", 90, "Push the floor away and lock out tall.", "gym"),
                    exercise("Walking Lunge", 3, "12/leg", 60, "Long stride and full balance each rep.", "gym"),
                    exercise("Hanging Knee Raise", 3, "12", 45, "Posteriorly tilt the pelvis at the top.", "gym"),
                ],
            ),
        ],
    ),
    plan(
        plan_id="male-home-recomp-system",
        name="Male Home Recomp System",
        goal="fatloss",
        level="intermediate",
        sex_variant="male",
        equipment="home",
        days_per_week=4,
        duration_weeks=6,
        description="Built for men training at home who want conditioning, muscle retention, and a sharper weekly structure.",
        tags=["male", "home", "recomp"],
        highlights=["Conditioning finishers", "Home equipment", "Visible weekly progression"],
        hero_image=BATTLE_ROPE_IMAGE,
        days=[
            day(
                1,
                "Push + Finisher",
                "Upper body pushing with density work",
                [
                    exercise("Dumbbell Floor Press", 4, "10", 60, "Pause elbows softly on the floor.", "home"),
                    exercise("Pike Push-Up", 3, "8-10", 45, "Stack shoulders over hands as you lower.", "none"),
                    exercise("Burpee", 3, "12", 30, "Stay smooth and consistent.", "none"),
                ],
            ),
            day(
                2,
                "Lower Drive",
                "Leg strength and unilateral control",
                [
                    exercise("Goblet Squat", 4, "12", 60, "Keep the dumbbell close and chest upright.", "home"),
                    exercise("Split Squat", 3, "10/leg", 45, "Drive the front foot through the floor.", "none"),
                    exercise("Single-Leg RDL", 3, "10/leg", 45, "Move slow and stay square.", "home"),
                ],
            ),
            day(
                3,
                "Pull + Core",
                "Back activation and midline control",
                [
                    exercise("One-Arm Row", 4, "10/side", 60, "Pull elbow to hip and pause.", "home"),
                    exercise("Band Curl", 3, "12", 30, "Avoid swinging through the reps.", "home"),
                    exercise("Plank Shoulder Tap", 3, "20", 30, "Minimize hip sway throughout.", "none"),
                ],
            ),
            day(
                4,
                "Conditioning Builder",
                "Energy systems and movement repeatability",
                [
                    exercise("Jump Rope", 4, "60s", 20, "Stay light and relaxed through the ankles.", "home"),
                    exercise("Dumbbell Thruster", 3, "12", 45, "Use the legs to accelerate the press.", "home"),
                    exercise("Mountain Climber", 3, "35s", 20, "Keep your shoulders slightly ahead of the wrists.", "none"),
                ],
            ),
        ],
    ),
    plan(
        plan_id="female-strength-sculpt-gym",
        name="Female Strength Sculpt",
        goal="strength",
        level="beginner",
        sex_variant="female",
        equipment="gym",
        days_per_week=4,
        duration_weeks=6,
        description="A gym plan tuned for women who want visible strength progress, lower-body focus, and sustainable recovery.",
        tags=["female", "gym", "strength"],
        highlights=["Lower-body emphasis", "Balanced upper work", "Easy to recover from"],
        hero_image=GYM_COUPLE_IMAGE,
        days=[
            day(
                1,
                "Glutes + Quads",
                "Lower body strength with stable volume",
                [
                    exercise("Barbell Hip Thrust", 4, "8-10", 75, "Posteriorly tilt the pelvis at the top.", "gym"),
                    exercise("Hack Squat", 3, "10", 75, "Keep knees tracking over toes.", "gym"),
                    exercise("Leg Extension", 3, "12", 45, "Squeeze quads hard at the top.", "gym"),
                ],
            ),
            day(
                2,
                "Upper Shape",
                "Back, shoulders, and posture",
                [
                    exercise("Lat Pulldown", 4, "10", 60, "Pull toward the upper chest.", "gym"),
                    exercise("Seated Row", 3, "10-12", 60, "Keep the ribs stacked and shoulders relaxed.", "gym"),
                    exercise("Dumbbell Shoulder Press", 3, "10", 60, "Brace before every rep.", "gym"),
                ],
            ),
            day(
                3,
                "Glutes + Hamstrings",
                "Posterior chain development",
                [
                    exercise("Romanian Deadlift", 4, "8", 75, "Feel the stretch in the hamstrings.", "gym"),
                    exercise("Cable Kickback", 3, "12/side", 30, "Move the leg without arching the back.", "gym"),
                    exercise("Lying Leg Curl", 3, "12", 45, "Control both directions of the rep.", "gym"),
                ],
            ),
            day(
                4,
                "Conditioning + Core",
                "Cardio finish and trunk stability",
                [
                    exercise("Sled Push", 4, "20m", 45, "Drive hard through the floor and keep posture tall.", "gym"),
                    exercise("Cable Wood Chop", 3, "12/side", 30, "Rotate through the ribs and hips together.", "gym"),
                    exercise("Treadmill Incline Walk", 3, "5 min", 30, "Nasal breathing if possible.", "gym"),
                ],
            ),
        ],
    ),
    plan(
        plan_id="female-home-balance-burn",
        name="Female Home Balance Burn",
        goal="fatloss",
        level="beginner",
        sex_variant="female",
        equipment="home",
        days_per_week=3,
        duration_weeks=6,
        description="A home-friendly female plan for fat loss, confidence, and balanced lower-body and core progression.",
        tags=["female", "home", "fat-loss"],
        highlights=["Home friendly", "Cardio blend", "Core focus"],
        hero_image=GYM_COUPLE_IMAGE,
        days=[
            day(
                1,
                "Lower Tone",
                "Glutes, quads, and balance",
                [
                    exercise("Goblet Squat", 4, "12", 60, "Stay long through the spine.", "home"),
                    exercise("Reverse Lunge", 3, "10/leg", 45, "Push the floor away on every rise.", "none"),
                    exercise("Glute Bridge Pulse", 3, "20", 30, "Keep constant tension at the top.", "none"),
                ],
            ),
            day(
                2,
                "Core + Cardio",
                "Bracing and calorie output",
                [
                    exercise("High Knees", 3, "35s", 20, "Stay quick and springy.", "none"),
                    exercise("Dead Bug", 3, "12/side", 25, "Move without losing the rib position.", "none"),
                    exercise("Plank Reach", 3, "16", 25, "Keep your hips quiet.", "none"),
                ],
            ),
            day(
                3,
                "Upper + Full Body",
                "Posture, arms, and movement quality",
                [
                    exercise("Dumbbell Row", 4, "10/side", 45, "Lead with the elbow and pause at the top.", "home"),
                    exercise("Dumbbell Press", 3, "10", 45, "Exhale as you press.", "home"),
                    exercise("Squat to Press", 3, "12", 30, "Use one fluid motion throughout.", "home"),
                ],
            ),
        ],
    ),
    plan(
        plan_id="female-glute-core-progression",
        name="Female Glute + Core Progression",
        goal="strength",
        level="intermediate",
        sex_variant="female",
        equipment="home",
        days_per_week=4,
        duration_weeks=6,
        description="An intermediate home plan centered on glute strength, trunk control, and high-quality weekly progression.",
        tags=["female", "home", "progression"],
        highlights=["Intermediate progression", "Glute bias", "Core control"],
        hero_image=BATTLE_ROPE_IMAGE,
        days=[
            day(
                1,
                "Hip Drive",
                "Heavy glute emphasis",
                [
                    exercise("Dumbbell Hip Thrust", 4, "10", 60, "Drive up hard and pause with tucked ribs.", "home"),
                    exercise("Bulgarian Split Squat", 3, "8/leg", 60, "Stay tall and descend under control.", "none"),
                    exercise("Frog Pump", 3, "20", 30, "Constant tension and short rests.", "none"),
                ],
            ),
            day(
                2,
                "Upper Support",
                "Back and shoulder support work",
                [
                    exercise("One-Arm Row", 4, "12/side", 45, "Keep the shoulder down and back.", "home"),
                    exercise("Lateral Raise", 3, "14", 30, "Lead with elbows and keep traps relaxed.", "home"),
                    exercise("Push-Up", 3, "10", 45, "Maintain a solid plank position.", "none"),
                ],
            ),
            day(
                3,
                "Hamstrings + Core",
                "Posterior chain and trunk stiffness",
                [
                    exercise("Single-Leg RDL", 4, "10/leg", 45, "Move slowly and own the balance.", "home"),
                    exercise("Slider Leg Curl", 3, "12", 30, "Keep hips elevated throughout.", "none"),
                    exercise("Hollow Hold", 3, "25s", 25, "Press the lower back into the floor.", "none"),
                ],
            ),
            day(
                4,
                "Engine Builder",
                "Conditioning without sacrificing form",
                [
                    exercise("Step-Up", 3, "12/leg", 30, "Drive through the whole foot on the box.", "home"),
                    exercise("Jump Rope", 4, "45s", 20, "Relax the shoulders and stay rhythmic.", "home"),
                    exercise("Farmer Carry March", 3, "40s", 30, "Stay tall and avoid leaning side to side.", "home"),
                ],
            ),
        ],
    ),
    plan(
        plan_id="unisex-performance-engine",
        name="Unisex Performance Engine",
        goal="strength",
        level="advanced",
        sex_variant="unisex",
        equipment="gym",
        days_per_week=4,
        duration_weeks=8,
        description="A performance-focused gym split for experienced lifters who want measurable strength, capacity, and structure.",
        tags=["advanced", "gym", "performance"],
        highlights=["Advanced intensity", "Athletic conditioning", "Full weekly structure"],
        hero_image=DIP_BAR_IMAGE,
        days=[
            day(
                1,
                "Power Push",
                "Strength on compound pressing",
                [
                    exercise("Bench Press", 5, "5", 120, "Use tight setup and consistent bar path.", "gym"),
                    exercise("Push Press", 4, "5", 90, "Dip straight and drive explosively.", "gym"),
                    exercise("Weighted Dip", 3, "8", 75, "Stay stacked and control depth.", "gym"),
                ],
            ),
            day(
                2,
                "Power Pull",
                "Back strength and hinge power",
                [
                    exercise("Deadlift", 5, "3", 120, "Set lats before each pull.", "gym"),
                    exercise("Weighted Pull-Up", 4, "6", 90, "Keep the ribs down and chin neutral.", "gym"),
                    exercise("Seal Row", 3, "8", 75, "Explode up and pause briefly.", "gym"),
                ],
            ),
            day(
                3,
                "Lower Output",
                "Squat power and unilateral support",
                [
                    exercise("Front Squat", 5, "4", 120, "Stay tall and brace hard.", "gym"),
                    exercise("Rear-Foot Elevated Split Squat", 3, "8/leg", 75, "Descend slowly and stand aggressively.", "gym"),
                    exercise("Sled Push", 5, "20m", 45, "Fast feet and stiff torso.", "gym"),
                ],
            ),
            day(
                4,
                "Conditioning + Core",
                "Work capacity and anti-rotation",
                [
                    exercise("Row Erg", 4, "500m", 60, "Hold race pace without losing posture.", "gym"),
                    exercise("Landmine Rotation", 3, "10/side", 30, "Rotate through the ribs and hips.", "gym"),
                    exercise("Hanging Leg Raise", 3, "12", 45, "Posteriorly tilt at the top.", "gym"),
                ],
            ),
        ],
    ),
]


HABIT_LIBRARY: dict[str, dict[str, Any]] = {
    "water": {
        "key": "water",
        "title": "Drink 8 glasses of water",
        "description": "Hydration habit to support recovery and energy.",
        "target": 8,
        "unit": "glasses",
        "type": "count",
        "category": "recovery",
    },
    "walk": {
        "key": "walk",
        "title": "Walk 10k steps",
        "description": "Low-friction movement to build consistency.",
        "target": 10000,
        "unit": "steps",
        "type": "target",
        "category": "movement",
    },
    "stretch": {
        "key": "stretch",
        "title": "Morning stretch",
        "description": "Short mobility routine after waking up.",
        "target": 10,
        "unit": "minutes",
        "type": "duration",
        "category": "mobility",
    },
    "meditation": {
        "key": "meditation",
        "title": "Meditation",
        "description": "Two calm minutes that protect your routine.",
        "target": 10,
        "unit": "minutes",
        "type": "duration",
        "category": "mindset",
    },
    "sleep": {
        "key": "sleep",
        "title": "Sleep 7+ hours",
        "description": "Foundational sleep target for recovery and energy.",
        "target": 7,
        "unit": "hours",
        "type": "duration",
        "category": "recovery",
    },
    "workout": {
        "key": "workout",
        "title": "Workout session",
        "description": "Show up and complete your scheduled training.",
        "target": 1,
        "unit": "session",
        "type": "binary",
        "category": "training",
    },
}

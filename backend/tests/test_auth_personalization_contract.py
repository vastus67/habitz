import uuid


def _new_user_payload(prefix: str) -> dict:
    unique = uuid.uuid4().hex[:10]
    return {
        "name": f"TEST_{prefix}_{unique}",
        "email": f"test_{prefix}_{unique}@example.com",
        "password": "TestPass123!",
    }


def _register_and_get_token(api_client, base_url: str, prefix: str) -> tuple[dict, str]:
    payload = _new_user_payload(prefix)
    response = api_client.post(f"{base_url}/api/auth/register", json=payload)
    assert response.status_code == 200
    data = response.json()
    token = data.get("session_token")
    assert isinstance(token, str) and len(token) > 10
    return data, token


def test_auth_register_mobile_contract_returns_user_and_session_token(api_client, base_url):
    # Auth contract test: register payload/response shape for mobile client
    request_payload = _new_user_payload("register_contract")
    response = api_client.post(f"{base_url}/api/auth/register", json=request_payload)

    assert response.status_code == 200
    data = response.json()
    assert "user" in data
    assert isinstance(data.get("session_token"), str)
    assert data["session_token"]
    assert data["user"]["email"] == request_payload["email"].lower()
    assert data["user"]["name"] == request_payload["name"]
    assert isinstance(data["user"].get("providers"), list)
    assert "email" in data["user"]["providers"]


def test_auth_me_with_bearer_token_returns_same_user_identity(api_client, base_url):
    # Auth contract test: bearer session token accepted by /auth/me
    register_data, token = _register_and_get_token(api_client, base_url, "me_contract")

    me_response = api_client.get(
        f"{base_url}/api/auth/me",
        headers={"Authorization": f"Bearer {token}"},
    )
    assert me_response.status_code == 200
    me_data = me_response.json()
    assert me_data["user"]["user_id"] == register_data["user"]["user_id"]
    assert me_data["user"]["email"] == register_data["user"]["email"]
    assert me_data["user"]["name"] == register_data["user"]["name"]


def test_auth_me_requires_bearer_token(api_client, base_url):
    # Auth guard test: /auth/me should reject unauthenticated request
    response = api_client.get(f"{base_url}/api/auth/me")
    assert response.status_code == 401
    data = response.json()
    assert "detail" in data


def test_recommendations_female_do_not_return_male_variant_plans(api_client, base_url):
    # Personalization contract test: recommendation filter by sex_variant
    _, token = _register_and_get_token(api_client, base_url, "female_reco")
    payload = {
        "goals": ["lose_fat"],
        "sex_variant": "female",
        "fitness_level": "beginner",
        "equipment": "home",
        "wake_time": "07:00",
    }
    response = api_client.post(
        f"{base_url}/api/onboarding/recommendations",
        json=payload,
        headers={"Authorization": f"Bearer {token}"},
    )
    assert response.status_code == 200
    data = response.json()
    plans = data.get("plans", [])
    assert isinstance(plans, list)
    assert len(plans) > 0
    assert all(plan["sex_variant"] in {"female", "unisex"} for plan in plans)


def test_plans_after_male_onboarding_do_not_return_female_variant(api_client, base_url):
    # Personalization contract test: /plans uses onboarded sex_variant for filtering
    register_data, token = _register_and_get_token(api_client, base_url, "male_plan")

    onboarding_payload = {
        "name": register_data["user"]["name"],
        "goals": ["build_muscle"],
        "sex_variant": "male",
        "fitness_level": "intermediate",
        "equipment": "gym",
        "wake_time": "06:00",
        "habit_keys": ["water", "workout", "sleep"],
        "selected_plan_id": None,
    }
    onboarding_response = api_client.post(
        f"{base_url}/api/onboarding/complete",
        json=onboarding_payload,
        headers={"Authorization": f"Bearer {token}"},
    )
    assert onboarding_response.status_code == 200
    onboarding_data = onboarding_response.json()
    assert onboarding_data["user"]["onboarding_completed"] is True
    assert onboarding_data["user"]["sex_variant"] == "male"

    plans_response = api_client.get(
        f"{base_url}/api/plans",
        headers={"Authorization": f"Bearer {token}"},
    )
    assert plans_response.status_code == 200
    plans_data = plans_response.json()
    plans = plans_data.get("plans", [])
    assert isinstance(plans, list)
    assert len(plans) > 0
    assert all(plan["sex_variant"] in {"male", "unisex"} for plan in plans)

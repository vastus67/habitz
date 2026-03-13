import os
from pathlib import Path

import pytest
import requests


def _read_frontend_backend_url() -> str | None:
    env_path = Path("/app/frontend/.env")
    if not env_path.exists():
        return None
    for line in env_path.read_text().splitlines():
        if line.startswith("REACT_APP_BACKEND_URL="):
            return line.split("=", 1)[1].strip()
    return None


@pytest.fixture(scope="session")
def base_url() -> str:
    # Shared backend base URL fixture for API contract tests
    value = os.environ.get("REACT_APP_BACKEND_URL") or _read_frontend_backend_url()
    if not value:
        pytest.fail("REACT_APP_BACKEND_URL is missing")
    return value.rstrip("/")


@pytest.fixture
def api_client() -> requests.Session:
    session = requests.Session()
    session.headers.update({"Content-Type": "application/json"})
    return session
import os

def get_base_url(default: str = "http://127.0.0.1:8000") -> str:
    return os.getenv("COOKBOOK_API_BASE", default)

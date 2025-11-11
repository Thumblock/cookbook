from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import os
import psycopg2
from psycopg2.extras import RealDictCursor

app = FastAPI(title="Cookbook API")

# read from env or fall back to localhost
DATABASE_URL = os.getenv(
    "COOKBOOK_DB_URL",
    "postgresql://postgres:postgres@localhost:5432/cookbook"
)

def get_connection():
    return psycopg2.connect(DATABASE_URL, cursor_factory=RealDictCursor)


class CookableRecipe(BaseModel):
    recipe_id: str
    title: str
    total_ingredients: int
    user_has_ingredients: int
    missing_ingredients: int


@app.get("/health")
def health():
    return {"status": "ok"}
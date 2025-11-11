from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import os
import psycopg2
from psycopg2.extras import RealDictCursor
from dotenv import load_dotenv

#Reads if .env exists
load_dotenv()


print("Loaded DB URL:", os.getenv("COOKBOOK_DB_URL"))

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

@app.get("/db-check")
def db_check():
    try:
        conn = get_connection()
        with conn.cursor() as cur:
            cur.execute("SELECT 1 AS ok;")
            row = cur.fetchone()
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"DB problem: {e}")
    finally:
        if 'conn' in locals():
            conn.close()
    return {"db": "ok", "result": row}

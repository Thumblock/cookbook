from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import os
import psycopg2
from psycopg2.extras import RealDictCursor
from dotenv import load_dotenv

#Reads if .env exists
load_dotenv()

# Safety Sanity check that .env is being loaded.
# print("Loaded DB URL:", os.getenv("COOKBOOK_DB_URL"))

app = FastAPI(title="Cookbook API")

# read from env or fall back to localhost
DATABASE_URL = os.getenv(
    "COOKBOOK_DB_URL",
    "postgresql://postgres:postgres@localhost:5432/cookbook"
)

def get_connection():
    return psycopg2.connect(DATABASE_URL, cursor_factory=RealDictCursor)
# --- Response models ---

# Used by /users/{user_id}/cookable
class CookableRecipe(BaseModel):
    recipe_id: str
    title: str
    total_ingredients: int
    user_has_ingredients: int
    missing_ingredients: int

class CookableRecipeWithTag(BaseModel):
    recipe_id: str
    title: str
    tag_name: str
    total_ingredients: int
    user_has_ingredients: int
    missing_ingredients: int

# --- Health checks ---
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

@app.get(
    "/users/{user_id}/cookable",
    response_model=list[CookableRecipe]
)
#Call the SQL function:
#SELECT * FROM get_user_cookable_recipes(p_user, p_max_missing);
def get_user_cookable(user_id: str, max_missing: int = 0):
    
    # Connect to DB
    try:
        conn = get_connection()
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"DB connection failed: {e}")

    try:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT * FROM get_user_cookable_recipes(%s, %s);",
                (user_id, max_missing)
            )
            rows = cur.fetchall()
    finally:
        conn.close()

    return rows

@app.get(
    "/users/{user_id}/cookable-by-tag",
    response_model=list[CookableRecipeWithTag]
)
#Call the SQL function: SELECT * FROM get_user_cookable_recipes_by_tag(p_user, p_tag, p_max_missing);
def get_user_cookable_by_tag(user_id: str, tag: str, max_missing: int = 0):
    
    try:
        conn = get_connection()
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"DB connection failed: {e}")

    try:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT * FROM get_user_cookable_recipes_by_tag(%s, %s, %s);",
                (user_id, tag, max_missing)
            )
            rows = cur.fetchall()
    finally:
        conn.close()

    return rows


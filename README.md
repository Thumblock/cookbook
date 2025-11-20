# SQL Interactive Cookbook
👨‍🍳 Author : Chipp Larusson - 
Aka Thumblock

Database | SQL | Python | FastAPI | Streamlit | Postgres | Azure


##



## 🔧 How to Run (using `uv` in Terminal *bash*)
In Visual Studio Code - click Terminal : New Terminal, right bottom corner next to + sign click and choose *Bash*

### 📦 1. Create & activate virtual environment
````bash
Write and run :
uv venv

# Activate:
# Windows : Bash
source .venv/Scripts/activate
# macOS/Linux
source .venv/bin/activate
# Install the import requirements
uv pip install -r requirements.txt
Use .env.example and update real .env accordingly

🛢️ Azure (Postgres)
Copy all code from the .sql files and run them in a query with Azure using Postgres connection.
Start with Schema.sql then logic.sql (seed.sql is demo user examples)

📚 Query : Table Sanity Check :
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

⚙️ Start FastAPI backend
uv run uvicorn src.cookbook.backend.api:app --reload
Visit: http://127.0.0.1:8000/health

Open another Terminal while you still have FastAPI running in first terminal *Bash*.
🎨  Launch Streamlit Dashboard
uv run streamlit run src/cookbook/frontend/dashboard.py
````




## Postgres (azure)
In PostgreSQL count() function is defined to always return a BIGINT, so function with count() had to be changed from int to BIGINT
````bash
## Imports
FastAPI            = main object that creates the web app with defining routes on it.
HTTPException      = A way for client to tell something is wrong with status code.
pydantic.BaseModel = FastAPI uses Pydantic to define and validate the shape ofthe data you rend/receive.
OS                 = Readable environment variables.
psycopg2           = Postgres driver, what talks to my PostgreSQL database
RealDictCursor     = Makes query results come back as dicts ({"recipe_id". "...","title": "..."})
````




## * Imagine the database as a small kitchen with characters:

👩‍🍳 User: says, “I want to make something delicious.”

📦 Pantry: replies, “Here’s what you currently have.”

📖 Recipe: says, “If you give me 2 eggs and butter, I’ll turn into an omelette.”

🏷️ Tag: whispers, “I’m a breakfast recipe, healthy and quick.”

❤️ Favorite: “You made me last week and loved it!”

🧺 Shopping list: “You’re missing milk — add it to me so you don’t forget.”

🧂 Ingredient: “I’m egg #5. I belong to both the pantry and recipes.”

🖼️ Recipe media: “Let me show you how pretty your dish looks.”

⭐ Review: “Let’s review what you thought about this meal.”

* Every table has a voice and a purpose — and together they “talk” through foreign keys and joins.

<img width="2494" height="901" alt="Cookbook_ER_Diagram" src="https://github.com/user-attachments/assets/f63d76e0-89bc-4b92-9d25-499356324e11" />


* How to think when coding SQL :
````bash
Tables = nouns → user, recipe, ingredient, user_pantry
Views = sentences you say a lot → “how many ingredients does a recipe have,” “what does this user have”
Joins = connecting nouns → “user WITH their pantry,” “recipe WITH its ingredients”
CROSS JOIN = “make everyone meet everyone”
LEFT JOIN = “try to match, but don’t drop if there’s no match”
COALESCE = “if the database says ‘nothing’, I actually want ‘0’”
DISTINCT prevents double-counting if something weird happens (e.g. duplicate pantry rows)

junction / bridge / link table → a table that’s mostly FKs to join two tables
constraint → a rule the DB enforces (PK, FK, UNIQUE, CHECK, NOT NULL)

````

## schema.sql
* 🧱 The structure - Blueprint of database 
````bash 
CREATE-TABLE
CREATE-EXTENSION
PRIMARY-KEY,FOREIGN-KEY
````

## logic.sql as the brain 🧠
````bash
View = prewritten SELECT
Function = prewritten SELECT that accepts parameters
p_... = “values coming from outside the function”
Inside the function: “filter the view using those parameters”
p_max_missing = 0 user must have everything to be fully cookable. if p_max_missing = 2 user can be missing up to 2 ingredients
p_user = function parameter
RETURN-QUERY-SELECT = the result of this SELECT is the result of the function.
"$$...$$" = “Postgres to use everything between $ to be executed when you call the function
LANGUAGE plpgsql = tells Postgres we’re using its procedural language(lets you use variables, IF, loops, etc.)
BEGIN-END; = the block of code to run
````






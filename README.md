# SQL Cookbook
👨‍🍳 Author
Thumblock
Database Design | SQL | Python | FastAPI | Streamlit | Postgres | Azure

🚧 Work in Progress
This README evolves along with the project.

Interactive recipe/ingredient app using:
- PostgreSQL (SQL server connection, table, functions)
- SQL (Azure, Table, Joins)
- FastAPI (backend / API)
- Streamlit (frontend / UI)
- Python

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
````



## Imports
FastAPI            = main object that creates the web app with defining routes on it.
HTTPException      = A way for client to tell something is wrong with status code.
pydantic.BaseModel = FastAPI uses Pydantic to define and validate the shape ofthe data you rend/receive.
OS                 = Readable environment variables.
psycopg2           = Postgres driver, what talks to my PostgreSQL database
RealDictCursor     = Makes query results come back as dicts ({"recipe_id". "...","title": "..."})

## Postgres (azure)
In PostgreSQL count() function is defined to always return a BIGINT, so function with count() had to be changed from int to BIGINT
* psycopg2 = Postgres driver, what talks to my PostgreSQL database



## Little glossary

````bash
inline FK → col TYPE REFERENCES other(col)

table-level FK → CONSTRAINT name FOREIGN KEY (col) REFERENCES other(col)

junction / bridge / link table → a table that’s mostly FKs to join two tables

composite primary key → primary key made of more than one column (PRIMARY KEY (a,b))

constraint → a rule the DB enforces (PK, FK, UNIQUE, CHECK, NOT NULL)

DDL → Data Definition Language (CREATE TABLE, etc)

````
* How to think when coding SQL :
````bash
Tables = nouns → user, recipe, ingredient, user_pantry

Views = sentences you say a lot → “how many ingredients does a recipe have,” “what does this user have”

Joins = connecting nouns → “user WITH their pantry,” “recipe WITH its ingredients”

CROSS JOIN = “make everyone meet everyone”

LEFT JOIN = “try to match, but don’t drop if there’s no match”

COALESCE = “if the database says ‘nothing’, I actually want ‘0’”

DISTINCT prevents double-counting if something weird happens (e.g. duplicate pantry rows)
````

# UUID Extension : Reason
````bash
UUIDs are good for web apps because they’re globally unique and hard to guess.
Postgres doesn’t auto-generate UUIDs by itself — we need a function for that.
"uuid-ossp" extension gives us the function uuid_generate_v4()
This keeps inserts simple (you don’t have to create UUIDs in Python) and keeps IDs consistent across all tables.
````

* Sanity check : Checked !
````bash
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
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

# SQL Cookbook

Interactive recipe/ingredient app using:
- PostgreSQL (SQL server connection, table, functions)
- SQL (Azure, Table, Joins)
- FastAPI (backend / API)
- Streamlit (frontend / UI)
- Python


## Little glossary

````bash

inline FK → col TYPE REFERENCES other(col)

table-level FK → CONSTRAINT name FOREIGN KEY (col) REFERENCES other(col)

junction / bridge / link table → a table that’s mostly FKs to join two tables

composite primary key → primary key made of more than one column (PRIMARY KEY (a,b))

constraint → a rule the DB enforces (PK, FK, UNIQUE, CHECK, NOT NULL)

DDL → Data Definition Language (CREATE TABLE, etc)
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

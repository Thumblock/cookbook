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
-- db/schema.sql

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users
CREATE TABLE cookbook_user (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT NOT NULL UNIQUE,
    display_name TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Ingredients
CREATE TABLE ingredient (
    ingredient_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    category TEXT
);

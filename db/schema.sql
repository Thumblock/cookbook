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

-- Recipes
CREATE TABLE recipe (
    recipe_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    instructions TEXT NOT NULL,
    created_by UUID REFERENCES cookbook_user(user_id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Recipe_Ingredient junction
CREATE TABLE recipe_ingredient (
    recipe_id UUID NOT NULL REFERENCES recipe(recipe_id) ON DELETE CASCADE,
    ingredient_id INT NOT NULL REFERENCES ingredient(ingredient_id),
    quantity NUMERIC(10,2),
    unit TEXT,
    PRIMARY KEY (recipe_id, ingredient_id)
);

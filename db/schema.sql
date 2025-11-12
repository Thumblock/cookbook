-- db/schema.sql

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users
CREATE TABLE IF NOT EXISTS cookbook_user (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT NOT NULL UNIQUE,
    display_name TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Ingredients
CREATE TABLE IF NOT EXISTS ingredient (
    ingredient_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    category TEXT
);

-- Recipes
CREATE TABLE IF NOT EXISTS recipe (
    recipe_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    instructions TEXT NOT NULL,
    created_by UUID REFERENCES cookbook_user(user_id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Recipe_Ingredient junction
CREATE TABLE IF NOT EXISTS recipe_ingredient (
    recipe_id UUID NOT NULL REFERENCES recipe(recipe_id) ON DELETE CASCADE,
    ingredient_id INT NOT NULL REFERENCES ingredient(ingredient_id),
    quantity NUMERIC(10,2),
    unit TEXT,
    PRIMARY KEY (recipe_id, ingredient_id)
);

-- User Pantry: what ingredients each user currently has
CREATE TABLE IF NOT EXISTS user_pantry (
    user_id UUID NOT NULL REFERENCES cookbook_user(user_id) ON DELETE CASCADE,
    ingredient_id INT NOT NULL REFERENCES ingredient(ingredient_id) ON DELETE CASCADE,
    quantity NUMERIC(10,2) NOT NULL DEFAULT 0,
    unit TEXT,
    PRIMARY KEY (user_id, ingredient_id)
);

-- Reviews: users can rate and comment on recipes
CREATE TABLE IF NOT EXISTS review (
    review_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    recipe_id UUID NOT NULL REFERENCES recipe(recipe_id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES cookbook_user(user_id) ON DELETE CASCADE,
    stars INT NOT NULL CHECK (stars BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (recipe_id, user_id)
);

-- Users can mark recipes as favorites
CREATE TABLE IF NOT EXISTS favorite_recipe (
    user_id UUID NOT NULL REFERENCES cookbook_user(user_id) ON DELETE CASCADE,
    recipe_id UUID NOT NULL REFERENCES recipe(recipe_id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, recipe_id)
);

-- Tags for categorizing recipes (carnivore, breakfast, healthy, budget, etc)
CREATE TABLE IF NOT EXISTS tag (
    tag_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

-- Junction: which tags belong to which recipes
CREATE TABLE IF NOT EXISTS recipe_tag (
    recipe_id UUID NOT NULL REFERENCES recipe(recipe_id) ON DELETE CASCADE,
    tag_id INT NOT NULL REFERENCES tag(tag_id) ON DELETE CASCADE,
    PRIMARY KEY (recipe_id, tag_id)
);
-- User can create shopping List with timestamp.
CREATE TABLE IF NOT EXISTS shopping_list (
    shopping_list_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES cookbook_user(user_id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
); 

-- The items that goes into a shopping list
CREATE TABLE IF NOT EXISTS shopping_list_item (
    shopping_list_id UUID NOT NULL REFERENCES shopping_list(shopping_list_id) ON DELETE CASCADE,
    ingredient_id INT NOT NULL REFERENCES ingredient(ingredient_id),
    quantity NUMERIC(10,2),
    unit TEXT,
    PRIMARY KEY (shopping_list_id, ingredient_id)
);

CREATE TABLE IF NOT EXISTS recipe_media (
    media_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    recipe_id UUID NOT NULL REFERENCES recipe(recipe_id) ON DELETE CASCADE,
    media_url TEXT NOT NULL,
    media_type TEXT DEFAULT 'image',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE recipe
ADD CONSTRAINT recipe_title_unique UNIQUE (title);

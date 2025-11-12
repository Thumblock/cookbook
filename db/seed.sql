-- New Demo User : user_id, email, display_name
INSERT INTO cookbook_user (user_id, email, display_name)
VALUES (uuid_generate_v4(), 'demo@example.com', 'Demo User')
ON CONFLICT (email) DO NOTHING;

-- Add test ingredient(s)
INSERT INTO ingredient (name) VALUES ('egg') ON CONFLICT (name) DO NOTHING;
INSERT INTO ingredient (name) VALUES ('butter') ON CONFLICT (name) DO NOTHING;

-- Add test recipe
INSERT INTO recipe (recipe_id, title, instructions)
VALUES (uuid_generate_v4(), 'Test Omelette', 'Beat eggs and fry.')
ON CONFLICT (title) DO NOTHING;

-- Link Recipe. (safe JOINs: insert only if both exist)
INSERT INTO recipe_ingredient (recipe_id, ingredient_id, quantity, unit)
SELECT r.recipe_id, i.ingredient_id, 2, 'pcs'
FROM recipe r
JOIN ingredient i ON i.name = 'egg'
WHERE r.title = 'Test Omelette'
ON CONFLICT (recipe_id, ingredient_id) DO NOTHING;

-- put eggs in demo user's pantry (safe JOINs + upsert to a fixed quantity)
INSERT INTO user_pantry (user_id, ingredient_id, quantity, unit)
SELECT u.user_id, i.ingredient_id, 4, 'pcs'
FROM cookbook_user u
JOIN ingredient i ON i.name = 'egg'
WHERE u.email = 'demo@example.com'

ON CONFLICT (user_id, ingredient_id) 
DO UPDATE SET quantity = EXCLUDED.quantity, unit = EXCLUDED.unit;


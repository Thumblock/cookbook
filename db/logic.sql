-- For each recipe: how many ingredients does it require?
CREATE OR REPLACE VIEW recipe_ingredient_counts AS
SELECT
    r.recipe_id,
    r.title,
    COUNT(ri.ingredient_id) AS total_ingredients
FROM recipe r
LEFT JOIN recipe_ingredient ri ON ri.recipe_id = r.recipe_id
GROUP BY r.recipe_id, r.title;

-- For a given user: how many ingredients of each recipe does the user have in their pantry?
CREATE OR REPLACE VIEW user_recipe_matches AS
SELECT
    r.recipe_id,
    r.title,
    u.user_id,
    COUNT(DISTINCT ri.ingredient_id) AS user_has_ingredients
FROM recipe r
JOIN recipe_ingredient ri ON ri.recipe_id = r.recipe_id
JOIN user_pantry u ON u.ingredient_id = ri.ingredient_id
GROUP BY r.recipe_id, r.title, u.user_id;
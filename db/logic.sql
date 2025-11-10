-- For each recipe: how many ingredients does it require?
CREATE OR REPLACE VIEW recipe_ingredient_counts AS
SELECT
    r.recipe_id,
    r.title,
    COUNT(ri.ingredient_id) AS total_ingredients
FROM recipe r
LEFT JOIN recipe_ingredient ri ON ri.recipe_id = r.recipe_id
GROUP BY r.recipe_id, r.title;
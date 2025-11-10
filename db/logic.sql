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

-- Combine the two to see "cookable" vs "missing"
CREATE OR REPLACE VIEW user_recipe_cookability AS
SELECT
    ric.recipe_id,
    ric.title,
    ur.user_id,
    ric.total_ingredients,
    COALESCE(ur.user_has_ingredients, 0) AS user_has_ingredients,
    (ric.total_ingredients - COALESCE(ur.user_has_ingredients, 0)) AS missing_ingredients
FROM recipe_ingredient_counts ric
CROSS JOIN cookbook_user cu
LEFT JOIN user_recipe_matches ur
    ON ur.recipe_id = ric.recipe_id
   AND ur.user_id = cu.user_id;

-- Rating stats per recipe
-- Shows: recipe, avg stars, number of reviews
CREATE OR REPLACE VIEW recipe_rating_stats AS
SELECT
    r.recipe_id,
    r.title,
    COALESCE(AVG(rev.stars), 0) AS avg_stars,
    COUNT(rev.review_id) AS review_count
FROM recipe r
LEFT JOIN review rev ON rev.recipe_id = r.recipe_id
GROUP BY r.recipe_id, r.title;
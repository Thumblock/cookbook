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

-- Shows how stocked up each user pantry is
CREATE OR REPLACE VIEW user_pantry_stats AS
SELECT
    u.user_id,
    u.display_name,
    COUNT(up.ingredient_id) AS ingredient_variants,
    COALESCE(SUM(up.quantity), 0) AS total_quantity
FROM cookbook_user u
LEFT JOIN user_pantry up ON up.user_id = u.user_id
GROUP BY u.user_id, u.display_name
ORDER BY ingredient_variants DESC;

-- Shows how many ingredients each recipe uses.
CREATE OR REPLACE VIEW recipe_ingredient_usage AS
SELECT
    r.recipe_id,
    r.title,
    COUNT(ri.ingredient_id) AS ingredient_count
FROM recipe r
LEFT JOIN recipe_ingredient ri ON ri.recipe_id = r.recipe_id
GROUP BY r.recipe_id, r.title
ORDER BY ingredient_count DESC;

-- Function: get recipes a user can cook (or nearly cook)
-- p_user: user_id we want to check
-- p_max_missing: how many missing ingredients we allow (0 = only fully cookable)
CREATE OR REPLACE FUNCTION get_user_cookable_recipes(
    p_user UUID,
    p_max_missing INT DEFAULT 0
)
RETURNS TABLE (
    recipe_id UUID,
    title TEXT,
    total_ingredients BIGINT,
    user_has_ingredients BIGINT,
    missing_ingredients BIGINT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        urc.recipe_id,
        urc.title,
        urc.total_ingredients,
        urc.user_has_ingredients,
        urc.missing_ingredients
    FROM user_recipe_cookability AS urc
    WHERE urc.user_id = p_user
      AND urc.missing_ingredients <= p_max_missing
    ORDER BY urc.missing_ingredients, urc.title;
END;
$$ LANGUAGE plpgsql;

-- Show recipes together with their tags
CREATE OR REPLACE VIEW recipe_with_tags AS
SELECT
    r.recipe_id,
    r.title,
    t.tag_id,
    t.name AS tag_name
FROM recipe r
JOIN recipe_tag rt ON rt.recipe_id = r.recipe_id
JOIN tag t ON t.tag_id = rt.tag_id
ORDER BY r.title, t.name;

-- Ingredient popularity: how often each ingredient is used in recipes
CREATE OR REPLACE VIEW ingredient_usage_stats AS
SELECT
    i.ingredient_id,
    i.name AS ingredient_name,
    i.category,
    COUNT(ri.recipe_id) AS used_in_recipes
FROM ingredient i
LEFT JOIN recipe_ingredient ri ON ri.ingredient_id = i.ingredient_id
GROUP BY i.ingredient_id, i.name, i.category
ORDER BY used_in_recipes DESC, i.name;

-- Show which recipes a user has marked as favorite
CREATE OR REPLACE VIEW user_favorite_recipes AS
SELECT
    u.user_id,
    u.display_name,
    r.recipe_id,
    r.title,
    fr.created_at AS favorited_at
FROM cookbook_user u
JOIN favorite_recipe fr ON fr.user_id = u.user_id
JOIN recipe r ON r.recipe_id = fr.recipe_id
ORDER BY u.display_name, fr.created_at DESC;
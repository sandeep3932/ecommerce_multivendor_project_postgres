-- Use a recursive CTE to display the full category hierarchy path from root to leaf node.

WITH RECURSIVE CategoryHierarchy AS (
    -- Base case: Select root categories (those without a parent)
    SELECT 
        category_id,
        category_name,
        parent_category_id,
        CAST(category_name AS TEXT) AS hierarchy_path,
        1 AS depth
    FROM 
        categories
    WHERE 
        parent_category_id IS NULL

    UNION ALL

    -- Recursive step: Join child categories to their parents
    SELECT 
        c.category_id,
        c.category_name,
        c.parent_category_id,
        ch.hierarchy_path || ' > ' || c.category_name AS hierarchy_path,
        ch.depth + 1 AS depth
    FROM 
        categories c
    JOIN 
        CategoryHierarchy ch ON c.parent_category_id = ch.category_id
)
SELECT 
    category_id,
    category_name,
    parent_category_id,
    hierarchy_path,
    depth
FROM 
    CategoryHierarchy
ORDER BY 
    hierarchy_path;

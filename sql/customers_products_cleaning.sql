-- Join customers with geography and create age bands
SELECT
    c.CustomerID,
    c.CustomerName,
    c.Email,
    c.Gender,
    c.Age,
    CASE
        WHEN c.Age < 25 THEN '18 to 24'
        WHEN c.Age BETWEEN 25 AND 34 THEN '25 to 34'
        WHEN c.Age BETWEEN 35 AND 44 THEN '35 to 44'
        WHEN c.Age BETWEEN 45 AND 54 THEN '45 to 54'
        WHEN c.Age BETWEEN 55 AND 64 THEN '55 to 64'
        ELSE 'Over 65'
    END AS [Age Band],
    g.Country,
    g.City
FROM dbo.customers AS c
LEFT JOIN dbo.geography AS g
    ON c.GeographyID = g.GeographyID;

-- Categorise products by price
SELECT
    ProductID,
    ProductName,
    Price,
    CASE
        WHEN Price < 50 THEN 'Low'
        WHEN Price BETWEEN 50 AND 149 THEN 'Medium'
        ELSE 'High'
    END AS PriceCategory
FROM dbo.products;

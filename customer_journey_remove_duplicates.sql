-- Purpose: Identify and remove duplicate customer journey records using ROW_NUMBER()
--          and standardise fields before loading into Power BI.

SELECT
    JourneyID,
    CustomerID,
    ProductID,
    VisitDate,
    Stage,
    Action,
    COALESCE(Duration, avg_duration) AS Duration
FROM (
    SELECT
        JourneyID,
        CustomerID,
        ProductID,
        CAST(VisitDate AS date) AS VisitDate,
        UPPER(Stage) AS Stage,
        Action,
        Duration,
        AVG(Duration) OVER (PARTITION BY VisitDate) AS avg_duration,
        ROW_NUMBER() OVER (
            PARTITION BY CustomerID, ProductID, VisitDate, UPPER(Stage), Action
            ORDER BY JourneyID
        ) AS Row_Num
    FROM dbo.customer_journey
) AS subquery
WHERE Row_Num = 1;

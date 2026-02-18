-- Remove duplicate customer journey rows using ROW_NUMBER()
WITH Duplicate_Records AS (
    SELECT
        JourneyID,
        CustomerID,
        ProductID,
        VisitDate,
        Stage,
        Action,
        Duration,
        ROW_NUMBER() OVER (
            PARTITION BY CustomerID, ProductID, VisitDate, Stage, Action
            ORDER BY JourneyID
        ) AS Row_Num
    FROM dbo.customer_journey
)
SELECT *
FROM Duplicate_Records
ORDER BY JourneyID;

-- Final cleaned dataset with standardised fields and duration imputation
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

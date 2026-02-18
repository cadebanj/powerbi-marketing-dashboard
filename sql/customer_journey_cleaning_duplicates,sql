SELECT 
*
FROM
dbo.customer_journey;

-- CTE to identify and flag duplicate journeys
WITH Duplicate_Records AS(
	SELECT
		JourneyID,
		CustomerID,
		ProductID,
		VisitDate,
		Stage,
		Action,
		Duration,
		-- Use ROW_NUMBER() to assign a unique row number to each record within the partition
		ROW_NUMBER() OVER ( 
			-- PARTITION BY groups the rows based on the specified columns that should be unique
			PARTITION BY CustomerID, ProductID, VisitDate, Stage, Action
			-- ORDER BY defines how to order the rows within each partition
			ORDER BY JourneyID
		) AS Row_Num
	FROM
		dbo.customer_journey
)

SELECT *
FROM Duplicate_Records
--WHERE Row_Num > 1
ORDER BY JourneyID;

-- Outer query selects the final cleaned and standardized data

SELECT
	JourneyID,
	CustomerID,
	ProductID,
	VisitDate,
	Stage,
	Action,
	COALESCE(Duration, avg_duration) AS Duration
FROM
	(
		-- Subquery to process and clean the data
		SELECT
			JourneyID,
			CustomerID,
			ProductID,
			CAST(VisitDate AS date) AS VisitDate,
			UPPER(Stage) AS Stage,
			Action,
			Duration,
			AVG(Duration) OVER (PARTITION BY VisitDate) AS avg_duration,
			ROW_NUMBER() OVER(
				PARTITION BY CustomerID, ProductID, VisitDate, UPPER(Stage), Action
				ORDER BY JourneyID
			) AS Row_Num
		FROM
			dbo.customer_journey
	) AS subquery
WHERE
	Row_Num = 1;

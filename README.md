# Marketing Analytics Dashboard (Power BI)
Marketing Dashboard for product conversions, social media and customer reviews

## Executive Summary
This dashboard consolidates marketing and customer performance across three areas: conversion performance, social engagement, and customer feedback. The key insight is that performance varies meaningfully by product and month, with clear opportunities to:
-increase conversion through targeted product optimisation
-improve engagement efficiency as social interactions decline over time
-use customer review/rating signals to guide product and customer experience improvements

## Features
- Interactive slicers
- DAX measures for conversion rate and average rating calculations
- Conditional formatting
- Funnel analysis

## Screenshots
![Dashboard Overview](images/01_Overview.png)

![Conversion Rate](images/02_Conversion_Rate.png) 

![Social Media](images/03_Social_Media.png) 

![Customer Reviews](images/04_Customer_Reviews.png) 

![Ratings](images/05_Ratings.png)

## SQL Data Preparation

The dataset required cleaning before being imported into Power BI.  
All SQL scripts are available in the `/sql` folder.

### Duplicate Removal (CTE + Window Functions)
- Remove duplicate customer journey rows using ROW_NUMBER()
```sql
-- Identify duplicates using ROW_NUMBER() and keep the first record per journey
WITH Duplicated_Records AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY CustomerID, ProductID, VisitDate, Stage, Action
               ORDER BY JourneyID
           ) AS Row_Num
    FROM dbo.customer_journey
)
SELECT *
FROM Duplicated_Records
WHERE rn = 1;
```

### Engagement Data cleaning
- Normalised `ContentType`
- Split combined views/clicks field
- Removed newsletter entries

```sql
SELECT
    EngagementID,
    UPPER(REPLACE(ContentType, 'Socialmedia', 'Social Media')) AS ContentType,
    LEFT(ViewsClicksCombined, CHARINDEX('-', ViewsClicksCombined) - 1) AS Views
FROM dbo.engagement_data;
```

### Customer Reviews Cleaning
- Removed double spacing in review text
```sql
SELECT
    ReviewID,
    REPLACE(ReviewText, '  ', ' ') AS CleanReviewText
FROM dbo.customer_reviews;
```

### Customer & Product Enrichment
- Joined customers table with geography table
- Created age bands
- Categorised products by price
```sql
SELECT
	ProductID,
	ProductName,
	Price,
	CASE --Categorize products in 'Low', 'Medium', and 'High' based on their price
		WHEN Price < 50 THEN 'Low'
		WHEN Price >= 50 AND Price < 150 THEN 'Medium'
		ELSE 'High'
	END AS PriceCategory

FROM
	dbo.products;
```


## Files Included
- 'README.md' - Project documentation

## Tools used
- Power BI Desktop
- Power Query
- DAX
- SQL Server Management Studio

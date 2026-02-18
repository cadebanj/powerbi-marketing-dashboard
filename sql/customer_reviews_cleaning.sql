-- Clean double spacing issues in customer review text
SELECT
    ReviewID,
    ProductID,
    CustomerID,
    ReviewDate,
    Rating,
    REPLACE(ReviewText, '  ', ' ') AS CleanReviewText
FROM dbo.customer_reviews;

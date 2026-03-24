SELECT
    *
FROM
    credit_card_transactions;

--------------------------------------------------------------

-- 1- write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends

WITH city_spend AS (
SELECT
    city,
    SUM(amount) AS total_spend
FROM
    credit_card_transactions
GROUP BY city
),
ranking AS (
SELECT
    city,
    total_spend,
    DENSE_RANK() OVER(ORDER BY total_spend DESC) AS rnk,
    total_spend / (SUM(total_spend) OVER())*100 AS pct_contr
FROM city_spend
)
SELECT * FROM ranking WHERE rnk<=5;

--------------------------------------------------------------

-- 2- write a query to print highest spend month and amount spent in that month for each card type

WITH monthly_transcations AS (
SELECT 
    card_type,
    MONTH(transaction_date) AS transaction_month,
    SUM(amount) AS amount
FROM credit_card_transactions
GROUP BY card_type, MONTH(transaction_date)
),
monthly_ranking AS (
SELECT
    card_type,
    transaction_month,
    amount,
    ROW_NUMBER() OVER(PARTITION BY card_type ORDER BY amount DESC) AS rnk
FROM monthly_transcations
)
SELECT 
    card_type,
    transaction_month,
    amount 
FROM monthly_ranking WHERE rnk=1;

-------------------------------------------------------------------------

-- 3 Write a query to print the transaction details(all columns from the table) for each card type when
-- it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)
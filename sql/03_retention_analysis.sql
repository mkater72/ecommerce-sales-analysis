-- 03_retention_analysis.sql

-- Находим 2-й заказ каждого клиента
WITH row_orders AS (
    SELECT
        customer_id,
        order_id,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_purchase_timestamp) AS rn_order
    FROM orders
)
SELECT customer_id, order_id, rn_order
FROM row_orders
WHERE rn_order = 2;

-- Retention: доля клиентов, сделавших второй заказ
WITH row_orders AS (
    SELECT 
        customer_id,
        order_purchase_timestamp,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_purchase_timestamp) AS rn_order
    FROM orders
),
first_order AS (
    SELECT customer_id FROM row_orders WHERE rn_order = 1
),
second_order AS (
    SELECT customer_id FROM row_orders WHERE rn_order = 2
)
SELECT COUNT(s.customer_id) * 100.0 / COUNT(f.customer_id) AS second_order_pr
FROM first_order f
LEFT JOIN second_order s ON f.customer_id = s.customer_id;

-- Когорты по месяцу первой покупки
WITH first_orders AS (
    SELECT customer_id, MIN(DATE_TRUNC('month', order_purchase_timestamp)) AS cohort_month
    FROM orders
    GROUP BY customer_id
)
SELECT
    o.customer_id,
    f.cohort_month,
    DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month
FROM orders o
JOIN first_orders f ON o.customer_id = f.customer_id
LIMIT 20;

-- 04_window_functions.sql

-- Ранг товаров внутри категории
SELECT
    p.product_category_name,
    oi.product_id,
    SUM(oi.price) AS revenue,
    RANK() OVER (PARTITION BY p.product_category_name ORDER BY SUM(oi.price) DESC) AS rank_in_category
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name, oi.product_id
ORDER BY p.product_category_name, rank_in_category
LIMIT 20;

-- Кумулятивная выручка по месяцам
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    SUM(oi.price) AS revenue,
    SUM(SUM(oi.price)) OVER (ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)) AS cumulative_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

-- Средний чек каждого клиента
SELECT
    o.customer_id,
    o.order_id,
    SUM(oi.price) AS order_total,
    AVG(SUM(oi.price)) OVER (PARTITION BY o.customer_id) AS avg_customer_order
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.customer_id, o.order_id
ORDER BY o.customer_id, o.order_id
LIMIT 20;

-- Предыдущий заказ клиента
SELECT
    o.customer_id,
    o.order_id,
    o.order_purchase_timestamp,
    LAG(o.order_purchase_timestamp) OVER (PARTITION BY o.customer_id ORDER BY o.order_purchase_timestamp) AS previous_order_date
FROM orders o
ORDER BY o.customer_id, o.order_purchase_timestamp
LIMIT 20;

-- Кумулятивная выручка по клиенту
SELECT
    o.customer_id,
    o.order_id,
    SUM(oi.price) OVER (PARTITION BY o.customer_id ORDER BY o.order_purchase_timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_customer_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
ORDER BY o.customer_id, o.order_purchase_timestamp
LIMIT 20;

-- Процент выручки каждого заказа от общей выручки клиента
SELECT
    o.customer_id,
    o.order_id,
    SUM(oi.price) AS order_total,
    SUM(oi.price) / SUM(SUM(oi.price)) OVER (PARTITION BY o.customer_id) * 100 AS pct_of_customer_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.customer_id, o.order_id
ORDER BY o.customer_id, order_id;

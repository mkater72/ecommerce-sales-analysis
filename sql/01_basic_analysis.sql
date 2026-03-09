-- 01_basic_analysis.sql

-- Просмотр первых заказов
SELECT
    o.order_id,
    o.order_purchase_timestamp,
    oi.price,
    oi.freight_value
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
LIMIT 20;

-- Общая выручка
SELECT SUM(price) AS total_revenue
FROM order_items;

-- Выручка по месяцам
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    SUM(oi.price) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

-- Средний чек
SELECT AVG(order_total)
FROM (
    SELECT order_id, SUM(price) AS order_total
    FROM order_items
    GROUP BY order_id
) t;

-- Топ товаров по выручке
SELECT product_id, SUM(price) AS revenue
FROM order_items
GROUP BY product_id
ORDER BY revenue DESC
LIMIT 10;

-- Топ 10 категорий по сумме продаж
SELECT
    p.product_category_name,
    SUM(oi.price) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;

-- Топ 10 по количеству продаж
SELECT product_id, COUNT(*) AS items_sold
FROM order_items
GROUP BY product_id
ORDER BY items_sold DESC
LIMIT 10;

-- Топ 10 по максимальной цене
SELECT product_id, MAX(price) AS max_price
FROM order_items
GROUP BY product_id
ORDER BY max_price DESC
LIMIT 10;

-- Среднее время доставки
SELECT AVG(order_delivered_customer_date - order_purchase_timestamp) AS avg_delivery_time
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

-- Количество уникальных клиентов
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM orders;

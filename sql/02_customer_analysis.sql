-- 02_customer_analysis.sql

-- Количество заказов на клиента
SELECT
    customer_id,
    COUNT(order_id) AS orders_count
FROM orders
GROUP BY customer_id
ORDER BY orders_count DESC
LIMIT 20;

-- Доля повторных клиентов
SELECT
COUNT(*) FILTER (WHERE orders_count > 1) * 100.0 / COUNT(*) AS repeat_customer_rate
FROM (
    SELECT customer_id, COUNT(order_id) AS orders_count
    FROM orders
    GROUP BY customer_id
) t;

-- Первая покупка клиента
SELECT customer_id, MIN(order_purchase_timestamp) AS first_order
FROM orders
GROUP BY customer_id
LIMIT 10;

-- Заказы дороже среднего чека
SELECT order_id, SUM(price) AS order_total
FROM order_items
GROUP BY order_id
HAVING SUM(price) > (
    SELECT AVG(order_total) 
    FROM (
        SELECT SUM(price) AS order_total
        FROM order_items
        GROUP BY order_id
    ) sub
);

-- Среднее количество товаров в заказе
SELECT AVG(items_per_order) AS avg_items_per_order
FROM (
    SELECT order_id, COUNT(*) AS items_per_order
    FROM order_items
    GROUP BY order_id
) t;

-- =====================================================
-- Pizza Sales Analysis | SQL Project (MySQL)
-- Tables: orders, orders_details, pizzas, pizza_types
-- =====================================================

CREATE DATABASE pizzahut;
USE pizzahut;

-- -----------------------------------------------------
-- Table setup
-- (pizzas and pizza_types can be imported with the
--  Table Data Import Wizard from the CSV files)
-- -----------------------------------------------------
CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);

CREATE TABLE orders_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id)
);

CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    ingredients TEXT,
    PRIMARY KEY (pizza_type_id)
);

CREATE TABLE pizzas (
    pizza_id VARCHAR(50) NOT NULL,
    pizza_type_id VARCHAR(50) NOT NULL,
    size VARCHAR(5) NOT NULL,
    price DECIMAL(6,2) NOT NULL,
    PRIMARY KEY (pizza_id)
);

SHOW TABLES;


-- =====================================================
-- PART 1: BASIC
-- =====================================================

-- Q1. Retrieve the total number of orders placed
SELECT COUNT(order_id) AS total_orders
FROM orders;


-- Q2. Calculate the total revenue generated from pizza sales
SELECT ROUND(SUM(orders_details.quantity * pizzas.price), 2) AS total_sales
FROM orders_details
JOIN pizzas ON pizzas.pizza_id = orders_details.pizza_id;


-- Q3. Identify the highest-priced pizza
SELECT pizza_types.name, pizzas.price
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;


-- Q4. Identify the most common pizza size ordered
SELECT pizzas.size, COUNT(orders_details.order_details_id) AS order_count
FROM orders_details
JOIN pizzas ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC
LIMIT 1;


-- =====================================================
-- PART 2: INTERMEDIATE
-- =====================================================

-- Q5. Total quantity of each pizza category ordered
SELECT pizza_types.category, SUM(orders_details.quantity) AS total_quantity
FROM orders_details
JOIN pizzas ON orders_details.pizza_id = pizzas.pizza_id
JOIN pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_types.category
ORDER BY total_quantity DESC;


-- Q6. Top 5 most ordered pizza types along with their quantities
SELECT pizza_types.name, SUM(orders_details.quantity) AS total_quantity
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY total_quantity DESC
LIMIT 5;


-- Q7. Distribution of orders by hour of the day
SELECT HOUR(order_time) AS hour, COUNT(order_id) AS order_count
FROM orders
GROUP BY HOUR(order_time)
ORDER BY hour;


-- =====================================================
-- PART 3: ADVANCED
-- =====================================================

-- Q8. Group the orders by date and calculate the average
--     number of pizzas ordered per day
SELECT ROUND(AVG(quantity), 0) AS avg_pizzas_ordered_per_day
FROM (
    SELECT orders.order_date, SUM(orders_details.quantity) AS quantity
    FROM orders
    JOIN orders_details ON orders.order_id = orders_details.order_id
    GROUP BY orders.order_date
) AS order_quantity;


-- Q9. Top 3 pizza types based on revenue
SELECT pizza_types.name,
       SUM(orders_details.quantity * pizzas.price) AS revenue
FROM pizza_types
JOIN pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;


-- Q10. Percentage contribution of each pizza category to total revenue
SELECT pizza_types.category,
       ROUND(
         SUM(orders_details.quantity * pizzas.price) /
         (SELECT SUM(orders_details.quantity * pizzas.price)
          FROM orders_details
          JOIN pizzas ON pizzas.pizza_id = orders_details.pizza_id) * 100
       , 2) AS revenue_percentage
FROM pizza_types
JOIN pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue_percentage DESC;


-- Q11. Cumulative revenue generated over time
SELECT order_date,
       SUM(revenue) OVER (ORDER BY order_date) AS cum_revenue
FROM (
    SELECT orders.order_date,
           SUM(orders_details.quantity * pizzas.price) AS revenue
    FROM orders_details
    JOIN pizzas ON orders_details.pizza_id = pizzas.pizza_id
    JOIN orders ON orders.order_id = orders_details.order_id
    GROUP BY orders.order_date
) AS sales;


-- Q12. Top 3 most ordered pizza types by revenue for each pizza category
SELECT category, name, revenue
FROM (
    SELECT category, name, revenue,
           RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rn
    FROM (
        SELECT pizza_types.category, pizza_types.name,
               SUM(orders_details.quantity * pizzas.price) AS revenue
        FROM pizza_types
        JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN orders_details ON orders_details.pizza_id = pizzas.pizza_id
        GROUP BY pizza_types.category, pizza_types.name
    ) AS a
) AS b
WHERE rn <= 3;

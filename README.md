# Pizza Sales Analysis | SQL Project

An end-to-end SQL analysis of a year of pizza-restaurant sales (Jan-Dec 2015). Four related tables are joined to answer 12 business questions on revenue, product mix, order timing and category performance.

**Full report with charts and insights:** [Pizza_Sales_Analysis_SQL_Report.pdf](Pizza_Sales_Analysis_SQL_Report.pdf)

## Dataset

| Table | Description | Rows |
|---|---|---|
| `orders` | Order ID, date and time | 21,350 |
| `orders_details` | Pizza and quantity for each order line | 48,620 |
| `pizzas` | Pizza ID, size and price | 96 |
| `pizza_types` | Pizza name, category and ingredients | 32 |

**Relationships**

- `orders.order_id` = `orders_details.order_id`
- `orders_details.pizza_id` = `pizzas.pizza_id`
- `pizzas.pizza_type_id` = `pizza_types.pizza_type_id`

## Business questions answered

**Basic**
1. Total number of orders placed
2. Total revenue generated from pizza sales
3. Highest-priced pizza
4. Most common pizza size ordered

**Intermediate**

5. Total quantity ordered per pizza category
6. Top 5 most ordered pizza types
7. Distribution of orders by hour of the day

**Advanced**

8. Average number of pizzas ordered per day
9. Top 3 pizza types by revenue
10. Percentage contribution of each category to total revenue
11. Cumulative revenue over time
12. Top 3 pizza types by revenue within each category

## Key findings

| Metric | Result |
|---|---|
| Total orders | 21,350 |
| Total revenue | $817,860.05 |
| Average pizzas per day | 138 |
| Highest-priced pizza | The Greek Pizza ($35.95) |
| Most ordered size | Large (L) |
| Most ordered pizza | The Classic Deluxe Pizza (2,453 units) |
| Top revenue pizza | The Thai Chicken Pizza ($43,434) |
| Top category by revenue | Classic (26.9%) |
| Peak order hours | 12:00-13:00 and 17:00-18:00 |

**Insights**
- Large pizzas lead sales, while XL and XXL together make up only about 1% of order lines.
- Orders peak at lunch and in the early evening, which matters for staffing and prep.
- Revenue is split evenly across the four categories (24-27% each).
- The top 3 pizzas by revenue are all Chicken pizzas.
- Monthly revenue stays between about $64K and $73K, so there is no strong seasonality.

## SQL concepts used

- Multi-table `JOIN`s
- Aggregate functions: `SUM`, `COUNT`, `AVG`, `ROUND`
- `GROUP BY` and `ORDER BY` with `LIMIT`
- Subqueries
- Window functions: `SUM() OVER`, `RANK() OVER (PARTITION BY ...)`
- Date and time functions: `HOUR()`

## How to run

1. Open MySQL Workbench (or any MySQL client).
2. Run the setup section of [`pizzahut_queries.sql`](pizzahut_queries.sql) to create the database and tables.
3. Import the four CSV files from the `data/` folder into their matching tables. In `orders.csv` the columns `date` and `time` map to `order_date` and `order_time`.
4. Run the queries Q1 to Q12 one at a time.

## Repository structure

```
pizza-sales-sql/
├── README.md
├── pizzahut_queries.sql
├── Pizza_Sales_Analysis_SQL_Report.pdf
└── data/
    ├── orders.csv
    ├── order_details.csv
    ├── pizzas.csv
    └── pizza_types.csv
```

## Tools

MySQL | SQL

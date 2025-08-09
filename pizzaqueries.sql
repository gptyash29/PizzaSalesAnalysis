-- 1.Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id) AS total_orders
FROM
    orders;
    
--  2.Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS rev
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id
    
--  3.Identify the highest-priced pizza.
SELECT 
    pizzas.price, pizza_types.name
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
ORDER BY price DESC
LIMIT 1;

-- 4. Identify the most common pizza size ordered.
SELECT 
    pizzas.size,
    COUNT(order_details.order_details_id) AS order_cnt
FROM
    pizzas
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizzas.size
ORDER BY order_cnt DESC 

-- 5.List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pizza_types.name, SUM(order_details.quantity) AS qnt
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY qnt DESC
LIMIT 5

-- 6. Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pizza_types.category, SUM(order_details.quantity) AS qnt
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_types.category1

-- 7. Determine the distribution of orders by hour of the day.
 
 SELECT 
    HOUR(order_time), COUNT(order_id)
FROM
    orders
GROUP BY HOUR(order_time)

-- Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category

--  8.Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(qnt), 0) as avg_pizza_order_perday
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS qnt
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date
    ORDER BY orders.order_date) AS od_qnt;
    
    -- 9. Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    name
FROM
    (SELECT 
        pizza_types.name,
            SUM(order_details.quantity * pizzas.price) AS revenue
    FROM
        order_details
    JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
    JOIN pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
    GROUP BY pizza_types.name
    ORDER BY revenue DESC
    LIMIT 3) AS data
    
-- 10. Calculate the percentage contribution of each pizza type to total revenue.

SELECT
  pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price) / (SELECT 
                    SUM(order_details.quantity * pizzas.price) AS total_sales
                FROM
                    order_details
                        JOIN
                    pizzas ON order_details.pizza_id = pizzas.pizza_id) * 100,
            2) AS generated_sales
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_types.category
ORDER BY generated_sales DESC

--  11.Analyze the cumulative revenue generated over time

select order_date,
 sum(rev) over(order by order_date) as cum_rev
 from
(select orders.order_date,sum(order_details.quantity*pizzas.price)as rev
from order_details join orders on order_details.order_id=orders.order_id join pizzas on pizzas.pizza_id=order_details.pizza_id
group by orders.order_date)
as rev_per_date

--  12.Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select category,name,rev from
(select category,name,rev,rank() over(partition by category order by rev desc  )as rn from
(select pizza_types.name,pizza_types.category,sum(order_details.quantity*pizzas.price)as rev
from   order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.name,pizza_types.category )as a )as b
where rn<4











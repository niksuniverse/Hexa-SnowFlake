USE DATABASE SNOWFLAKE_SAMPLE_DATA;
USE SCHEMA tpch_sf1;

SHOW TABLES;

SELECT * FROM Customer 
where C_COMMENT like '%ironic%' limit 5;

select c_custkey,c_name,c_nationkey
FROM customer
WHERE c_nationkey=12;


SELECT * FROM ORDERS;

select c.c_name,o.o_custkey,o.o_orderstatus,o.o_orderdate,o.o_totalprice
from customer c
join orders o 
on c.c_custkey=o.o_custkey
limit 10;


select o_orderkey ,o_orderdate ,o_totalprice
from orders 
where year(o_orderdate) = 1997
order by o_totalprice desc
limit 10;

SELECT * FROM REGION;
SELECT * FROM NATION;

SELECT r.r_name as region,
round(avg(o.o_totalprice),2) as avg_order_value from region r
join nation n on r.r_regionkey =  n.n_regionkey
join customer c on c.c_nationkey = n.n_nationkey
join orders o on o.o_custkey=c.c_custkey
group by r.r_name
order by avg_order_value desc;


create or replace database my_practice_db;
use my_practice_db;
create or replace table my_top_customers as
select c.c_name,sum(o.o_totalprice) as total_sales
from snowflake_sample_data.tpch_sf1.customer c
join snowflake_sample_data.tpch_sf10.orders o
on o.o_custkey=c.c_custkey
group by c.c_name
order by total_sales desc
limit 20;


drop table customer;



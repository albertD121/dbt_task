{{
  config(
    materialized='view'
  )
}}

with customers as (

    select * from {{ ref('stg_customers') }}

),

order_details as (

    select * from {{ ref('stg_orderDetails') }}

),

orders as (

    select
    customers.country,
    count(order_id) as number_of_orders,
    status

from {{ source('thelook_ecommerce', 'orders') }}
left join customers on customer_id = user_id 
group by customers.country, status
order by customers.country, number_of_orders DESC, status

),

final as (

    select
        order_details.product_id,
        order_details.category,
        order_details.name,
        order_details.brand,
        order_details.number_of_orders,
        order_details.status order_details_status,
        orders.country,
        orders.status order_status

    from order_details
    
    left join orders using (status)
    group by 1, 2, 3, 4, 5, 6, 7, 8
    order by number_of_orders DESC, status DESC

)

select * from final
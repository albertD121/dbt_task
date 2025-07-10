{{
  config(
    materialized='view'
  )
}}

with customers as (

    select
        id as customer_id,
        first_name,
        last_name,
        age,
        gender,
        state,
        postal_code,
        country,
        traffic_source

    from `bigquery-public-data`.thelook_ecommerce.users
    order by customer_id

),

orders as (

    select
        customers.country,
        count(order_id) as number_of_orders,
        status

    from `bigquery-public-data`.thelook_ecommerce.orders
    left join customers on customer_id = user_id 
    group by customers.country, status
    order by customers.country, number_of_orders DESC, status

),

order_details as (

    select
    oi. product_id,
    products.category,
    products.name,
    products.brand,
    count(oi.order_id) as number_of_orders,
    oi.status

    from `bigquery-public-data`.thelook_ecommerce.order_items oi
    left join `bigquery-public-data`.thelook_ecommerce.products on products.id = product_id
    group by oi.product_id,products.category,products.name,products.brand,oi.status
    order by number_of_orders DESC, status DESC

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
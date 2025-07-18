{{
  config(
    materialized='view'
  )
}}

with customers as (

    select * from {{ ref('stg_customers') }}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

order_details as (

    select * from {{ ref('stg_orderDetails') }}

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
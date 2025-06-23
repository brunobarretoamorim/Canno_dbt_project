{{ 
    config(
        tags=['vendas']
    ) 
}}
WITH raw_pedidos AS (
    SELECT
        id_pedido,
        id_cliente,
        CASE WHEN SAFE.PARSE_DATE('%d/%m/%Y',TRIM(data_pedido)) IS NOT NULL THEN SAFE.PARSE_DATE('%d/%m/%Y',TRIM(data_pedido))
            WHEN SAFE.PARSE_DATE('%Y-%m-%d',TRIM(data_pedido)) IS NOT NULL THEN SAFE.PARSE_DATE('%Y-%m-%d',TRIM(data_pedido))
            ELSE NULL END AS data_pedido,
        IFNULL(UPPER(TRIM(status_pedido)),'SEM STATUS') AS status_pedido,
        valor_total
    FROM {{ source('canno', 'pedidos_raw') }}
)

SELECT
    DATE(data_pedido) AS data_pedido,
    id_pedido AS id_pedido,
    id_cliente AS id_cliente,
    status_pedido,
    valor_total AS valor_total

FROM raw_pedidos
WHERE data_pedido is not null
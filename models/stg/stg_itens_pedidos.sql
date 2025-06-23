{{ 
    config(
        tags=['vendas']
    ) 
}}
WITH itens_pedidos_raw AS (
    SELECT
        id_item,
        id_pedido,
        id_produto,
        IFNULL(SAFE_CAST(quantidade AS INT64),0) AS quantidade,
        IFNULL(SAFE_CAST(desconto AS FLOAT64),0) AS desconto,
        IFNULL(SAFE_CAST(preco_unitario AS FLOAT64),0) AS preco_unitario
    FROM {{ source('canno', 'itens_pedido_raw') }}
)

SELECT
    id_item,
    id_pedido,
    id_produto,
    quantidade,
    preco_unitario,
    desconto

FROM itens_pedidos_raw
WHERE id_pedido IS NOT NULL
  AND id_produto IS NOT NULL
  AND id_item IS NOT NULL 
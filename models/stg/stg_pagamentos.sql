{{ 
    config(
        tags=['vendas']
    ) 
}}
WITH pagamentos_raw AS (
    SELECT
        CASE WHEN SAFE.PARSE_DATE('%d/%m/%Y',TRIM(DATA_PAGAMENTO)) IS NOT NULL THEN SAFE.PARSE_DATE('%d/%m/%Y',TRIM(DATA_PAGAMENTO))
            WHEN SAFE.PARSE_DATE('%Y-%m-%d',TRIM(DATA_PAGAMENTO)) IS NOT NULL THEN SAFE.PARSE_DATE('%Y-%m-%d',TRIM(DATA_PAGAMENTO))
            ELSE NULL END AS DATA_PAGAMENTO,
       id_pagamento, 
       id_pedido, 
       IFNULL(UPPER(TRIM(METODO_PAGAMENTO)),'OUTROS') AS METODO_PAGAMENTO, 
       IFNULL(UPPER(TRIM(STATUS_PAGAMENTO)),'OUTROS') STATUS_PAGAMENTO, 
       IFNULL(valor_pago,0)valor_pago, 
       IFNULL(tentativa_numero,0)tentativa_numero
    FROM {{ source('canno', 'pagamentos_raw') }}
)

SELECT
    *
FROM pagamentos_raw
WHERE id_pagamento IS NOT NULL

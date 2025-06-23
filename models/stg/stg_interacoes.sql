{{ 
    config(
        tags=['vendas']
    ) 
}}

WITH interacoes_raw AS (
    SELECT
        id_cliente,
        id_campanha,
        CASE 
            WHEN SAFE.PARSE_DATE('%d/%m/%Y', TRIM(data_interacao)) IS NOT NULL THEN SAFE.PARSE_DATE('%d/%m/%Y', TRIM(data_interacao))
            WHEN SAFE.PARSE_DATE('%Y-%m-%d', TRIM(data_interacao)) IS NOT NULL THEN SAFE.PARSE_DATE('%Y-%m-%d', TRIM(data_interacao))
            ELSE NULL
        END AS data_interacao
    FROM {{ source('canno', 'interacoes') }}
)

SELECT
    id_cliente,
    id_campanha,
    data_interacao
FROM interacoes_raw
WHERE id_cliente IS NOT NULL
  AND id_campanha IS NOT NULL

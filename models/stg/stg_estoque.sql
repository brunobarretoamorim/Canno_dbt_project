{{ 
    config(
        tags=['vendas']
    ) 
}}
WITH estoque_raw AS (
    SELECT
        CASE WHEN SAFE.PARSE_DATE('%d/%m/%Y',TRIM(DATA_MOVIMENTACAO)) IS NOT NULL THEN SAFE.PARSE_DATE('%d/%m/%Y',TRIM(DATA_MOVIMENTACAO))
            WHEN SAFE.PARSE_DATE('%Y-%m-%d',TRIM(DATA_MOVIMENTACAO)) IS NOT NULL THEN SAFE.PARSE_DATE('%Y-%m-%d',TRIM(DATA_MOVIMENTACAO))
            ELSE NULL END AS DATA_MOVIMENTACAO,
       ID_MOVIMENTO,
       ID_PRODUTO,
       UPPER(TRIM(TIPO)) AS TIPO,
       IFNULL(SAFE_CAST(QTD AS INT64),0) AS QTD,
       IFNULL(UPPER(TRIM(MOTIVO)),'OUTROS') ASMOTIVO
    FROM {{ source('canno', 'estoque_raw') }}
)

SELECT
    *
FROM estoque_raw
WHERE id_movimento IS NOT NULL

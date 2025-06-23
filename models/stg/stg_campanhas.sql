{{ 
    config(
        tags=['vendas']
    ) 
}}

WITH campanhas_raw AS (
    SELECT
        id_campanha,
        IFNULL(UPPER(TRIM(nome)), 'NÃO DEFINIDA') AS nome,
        IFNULL(UPPER(TRIM(canal)), 'NÃO DEFINIDO') AS canal,
        CASE 
            WHEN SAFE.PARSE_DATE('%d/%m/%Y', TRIM(inicio)) IS NOT NULL THEN SAFE.PARSE_DATE('%d/%m/%Y', TRIM(inicio))
            WHEN SAFE.PARSE_DATE('%Y-%m-%d', TRIM(inicio)) IS NOT NULL THEN SAFE.PARSE_DATE('%Y-%m-%d', TRIM(inicio))
            ELSE NULL
        END AS inicio,
        CASE 
            WHEN SAFE.PARSE_DATE('%d/%m/%Y', TRIM(fim)) IS NOT NULL THEN SAFE.PARSE_DATE('%d/%m/%Y', TRIM(fim))
            WHEN SAFE.PARSE_DATE('%Y-%m-%d', TRIM(fim)) IS NOT NULL THEN SAFE.PARSE_DATE('%Y-%m-%d', TRIM(fim))
            ELSE NULL
        END AS fim,
        SAFE_CAST(orcamento AS FLOAT64) AS orcamento
    FROM {{ source('canno', 'campanhas_raw') }}
)

SELECT
    id_campanha,
    nome,
    canal,
    inicio,
    fim,
    orcamento
FROM campanhas_raw
WHERE id_campanha IS NOT NULL

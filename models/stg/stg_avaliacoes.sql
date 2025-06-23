{{ 
    config(
        tags=['vendas']
    ) 
}}

WITH avaliacoes_raw AS (
    SELECT
        id_avaliacao,
        id_cliente,
        id_produto,
        CASE 
            WHEN SAFE.PARSE_DATE('%d/%m/%Y', TRIM(data)) IS NOT NULL THEN SAFE.PARSE_DATE('%d/%m/%Y', TRIM(data))
            WHEN SAFE.PARSE_DATE('%Y-%m-%d', TRIM(data)) IS NOT NULL THEN SAFE.PARSE_DATE('%Y-%m-%d', TRIM(data))
            ELSE NULL
        END AS data_avaliacao,
        SAFE_CAST(nota AS INT64) AS nota,
        IFNULL(TRIM(comentario), '') AS comentario
    FROM {{ source('canno', 'avaliacoes_raw') }}
)

SELECT
    id_avaliacao,
    id_cliente,
    id_produto,
    data_avaliacao,
    nota,
    comentario
FROM avaliacoes_raw
WHERE id_avaliacao IS NOT NULL
  AND id_cliente IS NOT NULL
  AND id_produto IS NOT NULL

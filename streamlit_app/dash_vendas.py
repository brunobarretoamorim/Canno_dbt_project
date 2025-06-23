import streamlit as st
import pandas as pd
from google.oauth2 import service_account
from google.cloud import bigquery

# CONFIGURAÇÕES DO APP
st.set_page_config(page_title="Painel de Vendas", layout="wide")

st.title("📊 Painel de Vendas - Loja de Maquiagem e Serviços")

# ======== CONEXÃO BIGQUERY =========
# Aqui você precisa apontar para seu JSON de chave de serviço do GCP
credentials = service_account.Credentials.from_service_account_file(
    "C:\\Users\\bruno\\Documents\\Estudos DE\\Canno\\venv\\Include\\keys\\dbtproject-456323-465ce12e369a.json",
)

client = bigquery.Client(credentials=credentials, project=credentials.project_id)

# QUERY para puxar dados
query = """
    SELECT *
    FROM `dbtproject-456323.canno.fct_vendas`
"""

df = client.query(query).to_dataframe()

# ======== FILTROS =========
st.sidebar.header("Filtros")

tipo_venda = st.sidebar.multiselect("Tipo de Venda", options=df["tipo_venda"].unique(), default=df["tipo_venda"].unique())
estado = st.sidebar.multiselect("Estado", options=df["estado"].dropna().unique(), default=df["estado"].dropna().unique())
ano_mes = st.sidebar.multiselect("Ano-Mês da Venda", options=df["ano_mes_venda"].dropna().unique(), default=df["ano_mes_venda"].dropna().unique())

# Aplicar filtros
df_filtered = df[
    (df["tipo_venda"].isin(tipo_venda)) &
    (df["estado"].isin(estado)) &
    (df["ano_mes_venda"].isin(ano_mes))
]

# ======== KPIs =========
col1, col2, col3 = st.columns(3)

with col1:
    faturamento_total = df_filtered["valor_liquido_item"].sum()
    st.metric(label="💰 Faturamento Total", value=f"R$ {faturamento_total:,.2f}".replace(",", "X").replace(".", ",").replace("X", "."))

with col2:
    total_vendas = df_filtered.shape[0]
    st.metric(label="🛒 Total de Vendas", value=total_vendas)

with col3:
    ticket_medio = faturamento_total / total_vendas if total_vendas > 0 else 0
    st.metric(label="🎯 Ticket Médio", value=f"R$ {ticket_medio:,.2f}".replace(",", "X").replace(".", ",").replace("X", "."))

# ======== GRÁFICOS =========
st.subheader("📈 Evolução de Vendas Mensal")

evolucao = df_filtered.groupby("ano_mes_venda")["valor_liquido_item"].sum().reset_index()

st.line_chart(evolucao.rename(columns={"ano_mes_venda": "index"}).set_index("index"))

st.subheader("🏆 Top Itens Vendidos")

top_items = df_filtered.groupby("nome_item")["valor_liquido_item"].sum().sort_values(ascending=False).head(10)

st.bar_chart(top_items)

# ======== TABELA =========
st.subheader("📋 Detalhamento de Vendas")

st.dataframe(df_filtered)


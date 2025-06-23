import pandas as pd
import random
from faker import Faker
import numpy as np

fake = Faker('pt_BR')
random.seed(42)
np.random.seed(42)

# Configuração de volume
N_CLIENTES = 100_000
N_PEDIDOS = 1_000_000
N_PRODUTOS = 500
N_SERVICOS = 50
N_AVALIACOES = 200_000
N_AGENDAMENTOS = 100_000
N_CAMPANHAS = 50
N_INTERACOES = 150_000
N_ESTOQUE = 300_000

# Funções auxiliares
def bool_noise():
    return random.choice(['sim', 'não', 'True', 'False', '1', '0', '', None])

def date_noise():
    date = fake.date_between(start_date='-2y', end_date='today')
    return random.choice([
        date.strftime('%Y-%m-%d'),
        date.strftime('%d/%m/%Y'),
        "ontem", "hoje", "", None
    ])

# Clientes
clientes = pd.DataFrame([{
    "id": i,
    "nome_completo": fake.name() if random.random() > 0.1 else fake.name().lower(),
    "e_mail": fake.email() if random.random() > 0.1 else "",
    "tel": fake.phone_number(),
    "nasc": date_noise(),
    "genero": random.choice(["f", "MASCULINO", "outro", "", None]),
    "cep": fake.postcode(),
    "cidade": fake.city(),
    "estado": fake.estado_sigla(),
    "criado_em": date_noise()
} for i in range(1, N_CLIENTES + 1)])

# Produtos
produtos = pd.DataFrame([{
    "id_produto": i,
    "nome": random.choice(["Base Liquida", "batom Velvet", "Sombra compacta", "ILUMINADOR Glow"]),
    "marca": random.choice(["Bruna Tavares", "Niina Secrets", "Fenty Beauty", "benefit", "Clinique", "mac", "", None]),
    "preco": round(random.uniform(15, 500), 2) if random.random() > 0.1 else "",
    "disponivel_em_estoque": bool_noise(),
    "categoria": random.choice(["batom", "base", "iluminador", "", None])
} for i in range(1, N_PRODUTOS + 1)])

# Pedidos
pedidos = pd.DataFrame([{
    "id_pedido": i,
    "id_cliente": random.randint(1, N_CLIENTES),
    "data_pedido": date_noise(),
    "status_pedido": random.choice(["pago", "cancelado", "pendente", "em andamento", None]),
    "valor_total": round(random.uniform(50, 1500), 2) if random.random() > 0.05 else "",
} for i in range(1, N_PEDIDOS + 1)])

# Itens de Pedido
itens_pedido = []
for pedido in pedidos.itertuples():
    n_itens = random.randint(1, 5)
    for _ in range(n_itens):
        itens_pedido.append({
            "id_item": len(itens_pedido) + 1,
            "id_pedido": pedido.id_pedido,
            "id_produto": random.randint(1, N_PRODUTOS),
            "quantidade": random.randint(1, 3),
            "preco_unitario": round(random.uniform(15, 500), 2),
            "desconto": round(random.uniform(0, 30), 2) if random.random() > 0.7 else 0
        })

itens_pedido = pd.DataFrame(itens_pedido)

# Pagamentos
pagamentos = []
for pedido in pedidos.itertuples():
    n_tentativas = random.choice([1, 1, 2])  # maioria com 1 tentativa
    for tentativa in range(1, n_tentativas + 1):
        pagamentos.append({
            "id_pagamento": f"PAG{pedido.id_pedido}_{tentativa}",
            "id_pedido": pedido.id_pedido,
            "metodo_pagamento": random.choice(["pix", "cartao", "boleto", "debito", "" if random.random() < 0.05 else "pix"]),
            "status_pagamento": random.choice(["aprovado", "recusado", "pendente", "erro"]),
            "data_pagamento": date_noise(),
            "valor_pago": round(random.uniform(50, 1500), 2) if random.random() > 0.05 else "",
            "tentativa_numero": tentativa
        })

pagamentos = pd.DataFrame(pagamentos)

# Serviços
servicos = pd.DataFrame([{
    "id": i,
    "nome_servico": f"{random.choice(['Workshop', 'Massagem', 'Consultoria'])} {fake.word()}",
    "categoria": random.choice(["massagem", "workshop", "consultoria", "", None]),
    "preco": round(random.uniform(80, 400), 2),
    "duracao": random.choice([30, 60, 90, "sessenta", "", None]),
    "responsavel": fake.name() if random.random() > 0.1 else None
} for i in range(1, N_SERVICOS + 1)])

# Agendamentos
agendamentos = pd.DataFrame([{
    "id_agendamento": f"A{i:06d}",
    "id_cliente": random.randint(1, N_CLIENTES),
    "id_servico": random.randint(1, N_SERVICOS),
    "data_agendada": date_noise(),
    "hora": random.choice(["10h", "15:30", "18h", "dez horas", ""]),
    "status_agendamento": random.choice(["agendado", "ok", "cancelado", "finalizado", "", None])
} for i in range(1, N_AGENDAMENTOS + 1)])

# Avaliações
avaliacoes = pd.DataFrame([{
    "id_avaliacao": i,
    "id_cliente": random.randint(1, N_CLIENTES),
    "id_produto": random.randint(1, N_PRODUTOS),
    "nota": random.choice([1, 2, 3, 4, 5, "cinco", "", None]),
    "comentario": fake.sentence() if random.random() > 0.2 else "",
    "data": date_noise()
} for i in range(1, N_AVALIACOES + 1)])

# Estoque
estoque = pd.DataFrame([{
    "id_movimento": i,
    "id_produto": random.randint(1, N_PRODUTOS),
    "tipo": random.choice(["entrada", "saida", "devolução", "", None]),
    "qtd": random.choice([10, 20, 30, "dez", "vinte", "", None]),
    "data_movimentacao": date_noise(),
    "motivo": random.choice(["venda", "reposicao", "ajuste", None])
} for i in range(1, N_ESTOQUE + 1)])

# Campanhas
campanhas = pd.DataFrame([{
    "id_campanha": i,
    "nome": f"Campanha {fake.word()}",
    "canal": random.choice(["instagram", "email", "google", ""]),
    "inicio": date_noise(),
    "fim": date_noise(),
    "orcamento": round(random.uniform(1000, 10000), 2) if random.random() > 0.1 else ""
} for i in range(1, N_CAMPANHAS + 1)])

# Interações
interacoes = pd.DataFrame([{
    "id_cliente": random.randint(1, N_CLIENTES),
    "id_campanha": random.randint(1, N_CAMPANHAS),
    "data_interacao": date_noise()
} for _ in range(N_INTERACOES)])

# Exportar
clientes.to_csv("clientes_raw.csv", index=False)
produtos.to_csv("produtos_raw.csv", index=False)
pedidos.to_csv("pedidos_raw.csv", index=False)
itens_pedido.to_csv("itens_pedido_raw.csv", index=False)
pagamentos.to_csv("pagamentos_raw.csv", index=False)
servicos.to_csv("servicos_raw.csv", index=False)
agendamentos.to_csv("agendamentos_raw.csv", index=False)
avaliacoes.to_csv("avaliacoes_raw.csv", index=False)
estoque.to_csv("estoque_raw.csv", index=False)
campanhas.to_csv("campanhas_raw.csv", index=False)
interacoes.to_csv("interacoes.csv", index=False)

print("Dados gerados!")

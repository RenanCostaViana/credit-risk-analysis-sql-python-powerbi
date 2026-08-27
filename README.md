# 💳 Credit Risk Analysis — SQL, Python & Power BI

### Tratamento, modelagem e visualização de dados para análise de risco de crédito

Este projeto analisa dados de solicitantes de empréstimo para entender os fatores associados à inadimplência e construir uma solução analítica de ponta a ponta — unindo **engenharia de dados em SQL**, **análise e modelagem preditiva em Python**, e um **dashboard executivo em Power BI**.

Os dados partem de um banco relacional normalizado (dados do solicitante, dados do empréstimo, histórico bancário), passam por tratamento e consolidação em SQL, são aprofundados em Python (outliers, exploração, modelo de risco), e chegam a um painel interativo para consulta e tomada de decisão.

---

## 🚀 Objetivos do Projeto

- Consolidar dados de solicitantes de crédito a partir de um banco relacional normalizado
- Tratar valores ausentes de forma criteriosa (imputação por média, sem contaminar a variável-alvo)
- Identificar inconsistências que a camada de SQL não cobre (outliers de digitação)
- Explorar os fatores associados à inadimplência
- Construir um modelo preditivo de risco de crédito
- Entregar um dashboard executivo para consulta e apoio à decisão

---

## 🧱 Arquitetura do Projeto

```text
credit-risk-analysis-sql-python-powerbi/
│
├── sql/
│   ├── 01_create_and_load/
│   │   ├── dados_mutuarios.sql        # schema + carga: dados do solicitante
│   │   ├── emprestimos.sql            # schema + carga: dados do empréstimo
│   │   ├── historicos_banco.sql       # schema + carga: histórico bancário
│   │   └── ids.sql                    # schema + carga: chaves de relacionamento
│   └── 02_join_tratamento.sql         # consolidação, imputação de nulos e junção
│
├── data/
│   └── credit_risk_tratado.csv        # saída do pipeline SQL — dataset único e tratado
│
├── notebooks/
│   └── analise_risco_credito.ipynb    # outliers, EDA e modelo preditivo
│
├── powerbi/
│   └── dashboard_risco_credito.pbix   # dashboard executivo (3 páginas)
│
├── images/
│   └── dashboard_overview.png         # print do dashboard
│
├── data_catalog.md                    # dicionário de dados por tabela
└── README.md
```

---

## 🔍 As Três Camadas do Pipeline

### 1. SQL — Engenharia de Dados
Quatro tabelas normalizadas (`dados_mutuarios`, `emprestimos`, `historicos_banco`, `ids`) são consolidadas em `02_join_tratamento.sql`: valores numéricos ausentes são imputados pela média da própria coluna, calculada via CTEs; linhas com dados categóricos ausentes (incluindo a variável-alvo, `status_emprestimo`) são descartadas — **a variável-alvo nunca é imputada**, para não contaminar o modelo construído posteriormente. O resultado é `credit_risk_tratado.csv`, um dataset único, sem nulos e com integridade referencial validada entre as quatro tabelas de origem.

### 2. Python — Análise e Modelagem
Partindo do CSV já tratado, o notebook (`analise_risco_credito.ipynb`) cobre o que a camada de SQL não trata:
- **Outliers de digitação**: idades acima de 80 anos (incluindo registros de 144 anos) e tempos de emprego acima de 60 anos são identificados e removidos — são valores tecnicamente presentes, não nulos, então o tratamento de SQL não os pega.
- **Análise exploratória** dos fatores associados à inadimplência.
- **Modelo de classificação** (Regressão Logística e Random Forest) para prever risco de inadimplência, com avaliação em conjunto de teste nunca visto durante o treino.

### 3. Power BI — Dashboard Executivo
Três páginas, usando o mesmo `credit_risk_tratado.csv` como fonte (o filtro de outliers do notebook é replicado no Power Query, para os números do dashboard e do notebook serem consistentes entre si):
- **Visão Geral**: KPIs (total de solicitações, taxa de inadimplência, valor total emprestado, valor em risco) e os dois fatores de risco mais fortes (nota do empréstimo, situação de moradia).
- **Perfil de Risco**: histórico prévio de inadimplência, percentual de renda comprometida, e detalhamento por motivo do empréstimo.
- **Detalhamento**: tabela linha a linha para consulta pontual.

---

## 🧠 Principais Insights

- **A nota do empréstimo é o fator mais forte**: a taxa de inadimplência sobe de forma quase monotônica de **10% (nota A)** a **98% (nota G)**.
- **Situação de moradia importa muito**: quem tem casa própria tem taxa de inadimplência de 7,6%, contra ~31% para quem aluga — 4x maior.
- **Histórico prévio de inadimplência mais que dobra o risco**: 18,4% (sem histórico) contra 37,8% (com histórico prévio).
- **O modelo (Random Forest) atinge 93% de acurácia e AUC acima de 0,90**, mas identifica corretamente apenas ~71% dos casos que de fato viram inadimplência — uma ressalva importante antes de qualquer uso operacional, onde deixar passar um mau pagador costuma custar mais caro do que ser cauteloso com um bom pagador.

---

## 🛠️ Tecnologias Utilizadas

- **SQL** (MySQL) — schema, carga, CTEs, imputação, joins
- **Python** — Pandas, NumPy, Matplotlib, Seaborn, Scikit-learn
- **Power BI** — Power Query (M), DAX, modelagem de relatório
- **Jupyter Notebook**

---

## 📖 Dicionário de Dados

Ver [`data_catalog.md`](./data_catalog.md) para a descrição completa de cada tabela e coluna de origem.

---

## ▶️ Como Reproduzir

**SQL**: execute os scripts de `sql/01_create_and_load/` (nessa ordem, um por tabela) em um servidor MySQL, seguido de `sql/02_join_tratamento.sql` para gerar o dataset consolidado.

**Python**:
```
pip install -r requirements.txt
jupyter notebook notebooks/analise_risco_credito.ipynb
```

**Power BI**: abra `powerbi/dashboard_risco_credito.pbix` no Power BI Desktop. A fonte de dados aponta para `data/credit_risk_tratado.csv` — ajuste o caminho em **Transformar Dados → Editor do Power Query** caso necessário.

---

## ⚠️ Limitações

- O modelo é uma prova de conceito analítica, não uma solução validada para concessão de crédito real.
- Não considera variáveis macroeconômicas ou de mercado.
- O recall da classe de inadimplência (71%) indica espaço para ajuste de limiar de decisão antes de qualquer uso prático.

---

## 📬 Contato

LinkedIn: <https://linkedin.com/in/renancostaviana>
E-mail: <renan.cv@outlook.com.br>

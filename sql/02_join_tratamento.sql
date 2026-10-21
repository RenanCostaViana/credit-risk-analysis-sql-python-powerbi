-- =====================================================================
-- Consolidação das quatro tabelas em uma base única de solicitações
-- =====================================================================
-- Regras:
--   1. Junta solicitante, empréstimo e histórico bancário pela tabela de IDs.
--   2. Descarta linhas sem ID, sem categoria (moradia, motivo, nota,
--      histórico de inadimplência) ou sem a variável-alvo (status do empréstimo).
--      Categorias e alvo não são imputados: um valor inventado aqui
--      contaminaria a análise e o modelo.
--   3. Valores numéricos ausentes são mantidos como NULL.
--      A imputação é feita no Python, depois da divisão treino/teste,
--      para que estatísticas do conjunto de teste não vazem para o modelo.
--
-- Compatível com MySQL 8 (testado também em SQLite).
-- =====================================================================

SELECT
    dm.person_id                     AS id_pessoa,
    dm.person_age                    AS idade_pessoa,
    dm.person_income                 AS renda_pessoa,
    dm.person_home_ownership         AS propriedade_residencial_pessoa,
    dm.person_emp_length             AS tempo_emprego_pessoa,
    e.loan_id                        AS id_emprestimo,
    e.loan_intent                    AS motivo_emprestimo,
    e.loan_grade                     AS nota_emprestimo,
    e.loan_amnt                      AS quantia_emprestimo,
    e.loan_int_rate                  AS taxa_emprestimo,
    e.loan_status                    AS status_emprestimo,
    e.loan_percent_income            AS percentual_renda_emprestimo,
    hb.cb_id                         AS id_banco,
    hb.cb_person_default_on_file     AS existencia_inadimplencia_banco,
    hb.cb_person_cred_hist_length    AS tempo_primeiro_credito_banco
FROM ids
JOIN dados_mutuarios  dm ON ids.person_id = dm.person_id
JOIN emprestimos      e  ON ids.loan_id   = e.loan_id
JOIN historicos_banco hb ON ids.cb_id     = hb.cb_id
WHERE NULLIF(TRIM(dm.person_id), '')                   IS NOT NULL
  AND NULLIF(TRIM(dm.person_home_ownership), '')       IS NOT NULL
  AND NULLIF(TRIM(e.loan_intent), '')                  IS NOT NULL
  AND NULLIF(TRIM(e.loan_grade), '')                   IS NOT NULL
  AND e.loan_status                                    IS NOT NULL
  AND NULLIF(TRIM(hb.cb_person_default_on_file), '')   IS NOT NULL;

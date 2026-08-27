WITH media_age AS (
  SELECT AVG(person_age) AS media_person_age
  FROM dados_mutuarios
  WHERE person_age IS NOT NULL
),
media_income AS (
  SELECT AVG(person_income) AS media_person_income 
  FROM dados_mutuarios 
  WHERE person_income IS NOT NULL
),
media_emp_length AS (
  SELECT AVG(person_emp_length) AS media_person_emp_length
  FROM dados_mutuarios 
  WHERE person_emp_length IS NOT NULL
),
media_amnt AS (
  SELECT AVG(loan_amnt) AS media_loan_amnt
  FROM emprestimos 
  WHERE loan_amnt IS NOT NULL
),
media_int_rate AS (
  SELECT AVG(loan_int_rate) AS media_loan_int_rate
  FROM emprestimos 
  WHERE loan_int_rate IS NOT NULL
),
media_percent_income AS (
  SELECT AVG(loan_percent_income) AS media_loan_percent_income
  FROM emprestimos 
  WHERE loan_percent_income IS NOT NULL
),
media_person_cred_hist_length AS (
  SELECT AVG(cb_person_cred_hist_length) AS media_cb_person_cred_hist_length
  FROM historicos_banco 
  WHERE cb_person_cred_hist_length IS NOT NULL
)

SELECT 
  dm.person_id AS id_pessoa, 
  COALESCE(dm.person_age, media_age.media_person_age) AS idade_pessoa, 
  COALESCE(dm.person_income, media_income.media_person_income) AS renda_pessoa, 
  dm.person_home_ownership AS propriedade_residencial_pessoa, 
  COALESCE(dm.person_emp_length, media_emp_length.media_person_emp_length) AS tempo_emprego_pessoa,
  e.loan_id AS id_emprestimo, 
  e.loan_intent AS motivo_emprestimo, 
  e.loan_grade AS nota_emprestimo, 
  COALESCE(e.loan_amnt, media_amnt.media_loan_amnt) AS quantia_emprestimo,
  COALESCE(e.loan_int_rate, media_int_rate.media_loan_int_rate) AS taxa_emprestimo,
  e.loan_status AS status_emprestimo,
  COALESCE(e.loan_percent_income, media_percent_income.media_loan_percent_income) AS percentual_renda_emprestimo,
  hb.cb_id AS id_banco, 
  hb.cb_person_default_on_file AS existencia_inadimplencia_banco, 
  COALESCE(hb.cb_person_cred_hist_length, media_person_cred_hist_length.media_cb_person_cred_hist_length) AS tempo_primeiro_credito_banco
FROM ids
JOIN dados_mutuarios dm ON ids.person_id = dm.person_id
JOIN emprestimos e ON ids.loan_id = e.loan_id
JOIN historicos_banco hb ON ids.cb_id = hb.cb_id
CROSS JOIN media_age
CROSS JOIN media_income
CROSS JOIN media_emp_length
CROSS JOIN media_amnt
CROSS JOIN media_int_rate
CROSS JOIN media_percent_income
CROSS JOIN media_person_cred_hist_length
WHERE COALESCE(TRIM(dm.person_id), '') != '' 
  AND COALESCE(TRIM(COALESCE(dm.person_age, media_age.media_person_age)), '') != '' 
  AND COALESCE(TRIM(COALESCE(dm.person_income, media_income.media_person_income)), '') != '' 
  AND COALESCE(TRIM(dm.person_home_ownership), '') != '' 
  AND COALESCE(TRIM(COALESCE(dm.person_emp_length, media_emp_length.media_person_emp_length)), '') != ''
  AND COALESCE(TRIM(e.loan_id), '') != '' 
  AND COALESCE(TRIM(e.loan_intent), '') != '' 
  AND COALESCE(TRIM(e.loan_grade), '') != '' 
  AND COALESCE(TRIM(COALESCE(e.loan_amnt, media_amnt.media_loan_amnt)), '') != '' 
  AND COALESCE(TRIM(COALESCE(e.loan_int_rate, media_int_rate.media_loan_int_rate)), '') != ''
  AND COALESCE(TRIM(e.loan_status), '') != ''
  AND COALESCE(TRIM(COALESCE(e.loan_percent_income, media_percent_income.media_loan_percent_income)), '') != ''
  AND COALESCE(TRIM(hb.cb_id), '') != '' 
  AND COALESCE(TRIM(hb.cb_person_default_on_file), '') != '' 
  AND COALESCE(TRIM(COALESCE(hb.cb_person_cred_hist_length, media_person_cred_hist_length.media_cb_person_cred_hist_length)), '') != '';

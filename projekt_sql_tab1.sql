CREATE TABLE t_monika_vorlova_project_sql_primary_final AS
SELECT
	cpay.id AS cpay_id,	
	cpay.value AS cpay_value,
	cpay.value_type_code,
	cpay.unit_code,
	cpay.industry_branch_code,
	cpib.name AS industry_name,
	cpay.payroll_year,
	cpr.id AS cpr_id,
	cpr.value AS cpr_value,
	cpr.category_code,
	cpc.name AS category_name,
	EXTRACT(YEAR FROM cpr.date_from) AS cpr_year
FROM
	czechia_payroll AS cpay 
	JOIN czechia_price AS cpr 
		ON cpay.payroll_year = EXTRACT(YEAR FROM cpr.date_from)
	JOIN czechia_price_category AS cpc
		ON cpr.category_code = cpc.code
	JOIN czechia_payroll_industry_branch AS cpib
		ON cpay.industry_branch_code = cpib.code
WHERE
	cpay.value_type_code = 5958 
	AND cpr.region_code IS NULL
;
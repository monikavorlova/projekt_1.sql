-- VO2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

WITH first_last AS (
	SELECT
		MIN(cpr_year) AS min_year,
		MAX(cpr_year) AS max_year
	FROM 
		t_monika_vorlova_project_sql_primary_final AS mt 
),
	cleaned_yearly_payroll AS (
		SELECT 
			payroll_year,
			AVG(cpay_value) AS avg_cpay_value
		FROM (
			SELECT DISTINCT
				cpay_id,
				payroll_year,
				cpay_value
			FROM 
				t_monika_vorlova_project_sql_primary_final AS mt
		)
		GROUP BY
			payroll_year
)
SELECT
	mt.category_code,
	mt.category_name,
	mt.cpr_year,
	ROUND(AVG(mt.cpr_value)::NUMERIC, 2) AS avg_price,
	ROUND(AVG(cyp.avg_cpay_value)::NUMERIC, 2) AS avg_pay,
	ROUND((AVG(cyp.avg_cpay_value) / AVG(mt.cpr_value))::NUMERIC, 2) AS affordable_amount
FROM
	t_monika_vorlova_project_sql_primary_final AS mt
	JOIN first_last AS fl
		ON mt.cpr_year IN (fl.min_year, fl.max_year)
	JOIN cleaned_yearly_payroll cyp
		ON mt.cpr_year = cyp.payroll_year
WHERE
	mt.category_name ILIKE '%chléb%'
	OR mt.category_name ILIKE '%mléko%'
GROUP BY
	cpr_year,
	category_code,
	category_name
ORDER BY
	category_code,
	cpr_year
;
	
		
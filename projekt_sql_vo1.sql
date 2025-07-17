-- VO1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

WITH avg_wages AS (
	SELECT
		mt.industry_name,
		mt.payroll_year,
		ROUND(AVG(cpay_value), 2) AS avg_wage
	FROM
		t_monika_vorlova_project_sql_primary_final AS mt
	WHERE
		mt.industry_branch_code IS NOT NULL
	GROUP BY
		mt.industry_name,
		mt.payroll_year
)
SELECT
	industry_name,
	payroll_year,
	avg_wage,
	avg_wage - LAG(avg_wage) OVER
		(PARTITION BY industry_name ORDER BY payroll_year) AS yearly_difference
FROM
	avg_wages
ORDER BY
	industry_name,
	payroll_year
;

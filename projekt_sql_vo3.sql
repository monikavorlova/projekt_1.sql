-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 

WITH yearly_differences AS (
	SELECT
		category_code,
		category_name,
		cpr_year AS YEAR,
		ROUND(AVG(cpr_value)::NUMERIC, 2) AS avg_price,
		ROUND(
			(
				(AVG(cpr_value) - LAG(AVG(cpr_value)) OVER (PARTITION BY category_code ORDER BY cpr_year)) /
				LAG(AVG(cpr_value)) OVER (PARTITION BY category_code ORDER BY cpr_year) * 100
			)::NUMERIC, 2)
			AS yearly_difference
	FROM
		t_monika_vorlova_project_sql_primary_final AS mt
	GROUP BY
		category_code,
		category_name,
		cpr_year
)
SELECT
	category_code,
	category_name,
	ROUND(AVG(yearly_difference)::NUMERIC, 2) AS avg_yearly_diff
FROM 
	yearly_differences
GROUP BY
	category_code,
	category_name
ORDER BY
	avg_yearly_diff ASC
LIMIT 1
;

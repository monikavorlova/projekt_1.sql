-- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

WITH yearly_pay AS (
	SELECT 
		payroll_year,
		AVG(cpay_value) AS avg_cpay_value,
		ROUND(
				(
					(AVG(cpay_value) - LAG(AVG(cpay_value)) OVER (ORDER BY payroll_year)) /
					LAG(AVG(cpay_value)) OVER (ORDER BY payroll_year) * 100
				)::NUMERIC, 2)
				AS yearly_pay_difference
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
), 
yearly_prices AS (
SELECT
		cpr_year AS year,
		ROUND(AVG(cpr_value)::NUMERIC, 2) AS avg_price,
		ROUND(
			(
				(AVG(cpr_value) - LAG(AVG(cpr_value)) OVER (ORDER BY cpr_year)) /
				LAG(AVG(cpr_value)) OVER (ORDER BY cpr_year) * 100
			)::NUMERIC, 2)
			AS yearly_difference
	FROM
		t_monika_vorlova_project_sql_primary_final AS mt
	GROUP BY
		cpr_year
)
SELECT
	ypr.year,
	ypr.yearly_difference AS yearly_price_difference,
	ypay.yearly_pay_difference,
	CASE
		WHEN ypr.yearly_difference - ypay.yearly_pay_difference > 10 THEN 'rozdíl větší než 10 %'
		ELSE 'rozdíl menší než 10 %'
	END AS pay_prices_difference
FROM
	yearly_pay AS ypay
	JOIN yearly_prices AS ypr
		ON ypay.payroll_YEAR = ypr.year
ORDER BY
	YEAR
;
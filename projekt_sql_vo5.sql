-- Má výška HDP vliv na změny ve mzdách a cenách potravin? 
-- Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

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
),
yearly_gdp_difference AS (
	SELECT
		year,	
		ROUND(gdp::NUMERIC, 2) AS gdp,
		ROUND(
			(
				((gdp - LAG(gdp) OVER (ORDER BY year)) /
				LAG(gdp) OVER (ORDER BY year)) * 100)::NUMERIC, 2) AS gdp_yearly_diff
	FROM 
		t_monika_vorlova_project_sql_secondary_final mt2 
	WHERE
		country = 'Czech Republic'
),
final_data AS (
	SELECT
		ypr.year,
		ypr.yearly_difference AS yearly_price_difference,
		ypay.yearly_pay_difference,
		ygd.gdp_yearly_diff AS yearly_gdp_difference,
		lag(ygd.gdp_yearly_diff) OVER (ORDER BY ypr.year) AS gdp_difference_last_year
	FROM
		yearly_pay AS ypay
		JOIN yearly_prices AS ypr
			ON ypay.payroll_YEAR = ypr.year
		JOIN yearly_gdp_difference AS ygd
			ON ypr.year = ygd.year
)
SELECT
	label,
	ROUND(value::NUMERIC, 2) AS correlation,
	CASE
		WHEN ABS(value) < 0.20 THEN 'very weak correlation'
		WHEN ABS(value) < 0.40 THEN 'weak correlation'
		WHEN ABS(value) < 0.60 THEN 'moderate correlation'
		WHEN ABS(value) < 0.80 THEN 'strong correlation'
		WHEN ABS(value) <= 1 THEN 'very strong correlation'
	END AS interpretation
FROM (
	SELECT 
		'Price vs. GDP (same year)' AS label,
		CORR(yearly_price_difference, yearly_gdp_difference) AS value
	FROM
		final_data
UNION ALL
SELECT 
		'Pay vs. GDP (same year)' AS label,
		CORR(yearly_pay_difference, yearly_gdp_difference) AS value
	FROM
		final_data
UNION ALL
	SELECT 
		'Price vs. GDP (previous year)' AS label,
		CORR(yearly_price_difference, gdp_difference_last_year) AS value
	FROM
		final_data
UNION ALL
	SELECT 
		'Pay vs. GDP (previous year)' AS label,
		CORR(yearly_pay_difference, gdp_difference_last_year) AS value
	FROM
		final_data
);
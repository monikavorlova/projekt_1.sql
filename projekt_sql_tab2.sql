CREATE TABLE t_monika_vorlova_project_sql_secondary_final AS
SELECT
	e.country,
	c.continent,
	e.year,
	round(gdp::NUMERIC, 2) AS gdp,
	e.gini,
	e.population
FROM
	economies e
	JOIN countries c ON e.country = c.country
WHERE
	YEAR BETWEEN 2006 AND 2018
	AND c.continent = 'Europe'
;
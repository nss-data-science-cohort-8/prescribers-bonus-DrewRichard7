-- 1. How many npi numbers appear in the prescriber table but not in the prescription table?

SELECT COUNT(DISTINCT npi)
FROM prescriber
WHERE npi IN (
	SELECT npi
	FROM prescriber
	EXCEPT 
	SELECT npi
	FROM prescription
);

/* 2.
    a. Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Family Practice.*/

SELECT *
FROM prescription

SELECT d.generic_name, SUM(rx.total_claim_count) AS total_claims
FROM prescriber AS p
INNER JOIN prescription AS rx
USING(npi)
INNER JOIN drug AS d
USING(drug_name)
WHERE p.specialty_description = 'Family Practice'
GROUP BY d.generic_name
ORDER BY total_claims DESC
LIMIT 5;


    -- b. Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Cardiology.

SELECT d.generic_name, SUM(rx.total_claim_count) AS total_claims
FROM prescriber AS p
INNER JOIN prescription AS rx
USING(npi)
INNER JOIN drug AS d
USING(drug_name)
WHERE p.specialty_description = 'Cardiology'
GROUP BY d.generic_name
ORDER BY total_claims DESC
LIMIT 5;

    -- c. Which drugs are in the top five prescribed by Family Practice prescribers and Cardiologists? Combine what you did for parts a and b into a single query to answer this question.

(SELECT d.generic_name
FROM prescriber AS p
INNER JOIN prescription AS rx
USING(npi)
INNER JOIN drug AS d
USING(drug_name)
WHERE p.specialty_description = 'Family Practice'
GROUP BY d.generic_name
ORDER BY SUM(rx.total_claim_count) DESC
LIMIT 5)

INTERSECT

(SELECT d.generic_name
FROM prescriber AS p
INNER JOIN prescription AS rx
USING(npi)
INNER JOIN drug AS d
USING(drug_name)
WHERE p.specialty_description = 'Cardiology'
GROUP BY d.generic_name
ORDER BY SUM(rx.total_claim_count) DESC
LIMIT 5);

-- gotta have both queries in ()


/*3. Your goal in this question is to generate a list of the top prescribers in each of the major metropolitan areas of Tennessee.
    a. First, write a query that finds the top 5 prescribers in Nashville in terms of the total number of claims (total_claim_count) across all drugs. Report the npi, the total number of claims, and include a column showing the city.*/

SELECT p.npi, SUM(rx.total_claim_count) AS total_claims, p.nppes_provider_city AS city
FROM prescriber AS p
INNER JOIN prescription AS rx
USING(npi)
INNER JOIN drug AS d
USING(drug_name)
WHERE LOWER(p.nppes_provider_city) = 'nashville'
GROUP BY p.npi, p.nppes_provider_city
ORDER BY total_claims DESC
LIMIT 5;

	
    -- b. Now, report the same for Memphis.

SELECT p.npi, SUM(rx.total_claim_count) AS total_claims, p.nppes_provider_city AS city
FROM prescriber AS p
INNER JOIN prescription AS rx
USING(npi)
INNER JOIN drug AS d
USING(drug_name)
WHERE LOWER(p.nppes_provider_city) = 'memphis'
GROUP BY p.npi, p.nppes_provider_city
ORDER BY total_claims DESC
LIMIT 5;


	
    -- c. Combine your results from a and b, along with the results for Knoxville and Chattanooga.
(SELECT p.npi, SUM(rx.total_claim_count) AS total_claims, p.nppes_provider_city AS city
FROM prescriber AS p
INNER JOIN prescription AS rx
USING(npi)
INNER JOIN drug AS d
USING(drug_name)
WHERE LOWER(p.nppes_provider_city) = 'nashville'
GROUP BY p.npi, p.nppes_provider_city
ORDER BY total_claims DESC
LIMIT 5)

UNION

(SELECT p.npi, SUM(rx.total_claim_count) AS total_claims, p.nppes_provider_city AS city
FROM prescriber AS p
INNER JOIN prescription AS rx
USING(npi)
INNER JOIN drug AS d
USING(drug_name)
WHERE LOWER(p.nppes_provider_city) = 'memphis'
GROUP BY p.npi, p.nppes_provider_city
ORDER BY total_claims DESC
LIMIT 5)

UNION

(SELECT p.npi, SUM(rx.total_claim_count) AS total_claims, p.nppes_provider_city AS city
FROM prescriber AS p
INNER JOIN prescription AS rx
USING(npi)
INNER JOIN drug AS d
USING(drug_name)
WHERE LOWER(p.nppes_provider_city) = 'knoxville'
GROUP BY p.npi, p.nppes_provider_city
ORDER BY total_claims DESC
LIMIT 5)

UNION

(SELECT p.npi, SUM(rx.total_claim_count) AS total_claims, p.nppes_provider_city AS city
FROM prescriber AS p
INNER JOIN prescription AS rx
USING(npi)
INNER JOIN drug AS d
USING(drug_name)
WHERE LOWER(p.nppes_provider_city) = 'chattanooga'
GROUP BY p.npi, p.nppes_provider_city
ORDER BY total_claims DESC
LIMIT 5)
ORDER BY total_claims DESC;



-- 4. Find all counties which had an above-average number of overdose deaths. Report the county name and number of overdose deaths.

SELECT f.county AS county, SUM(o.overdose_deaths) AS overdose_deaths
FROM fips_county AS f
INNER JOIN overdose_deaths AS o
ON CAST(f.fipscounty AS INTEGER) = o.fipscounty
WHERE o.overdose_deaths > (SELECT AVG(overdose_deaths) FROM overdose_deaths)
GROUP BY f.county
ORDER BY overdose_deaths DESC;

/* 5.
    a. Write a query that finds the total population of Tennessee.*/



	
    -- b. Build off of the query that you wrote in part a to write a query that returns for each county that county's name, its population, and the percentage of the total population of Tennessee that is contained in that county.







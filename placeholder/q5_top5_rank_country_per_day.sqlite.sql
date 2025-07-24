WITH
    countries_rank as (
        select
            code,
            rank() over (
                order by
                    "GDP ($ per capita)" desc
            ) as gdp_rank,
            rank() over (
                ORDER BY
                    "Population" desc
            ) as population_rank
        from
            countries
    ),
    participant_country AS (
        SELECT
            a.code AS participant_code,
            c.code AS country_code
        FROM
            athletes a
            JOIN countries_rank c ON a.country_code = c.code
        UNION
        SELECT
            t.code AS participant_code,
            c.code AS country_code
        FROM
            teams t
            JOIN countries_rank c ON t.country_code = c.code
    )
SELECT
    t.date,
    t.country_code,
    MAX(t.top5_appearances) AS top5_appearances,
    c.gdp_rank,
    c.population_rank
FROM
    (
        SELECT
            r.date,
            pc.country_code,
            COUNT(r.rank) OVER (
                PARTITION BY
                    r.date,
                    pc.country_code
            ) AS top5_appearances
        FROM
            results r
            JOIN participant_country pc ON r.participant_code = pc.participant_code
        WHERE
            r.rank <= 5
            AND r.rank IS NOT NULL
        ORDER BY
            r.date
    ) as t
    JOIN countries_rank c ON t.country_code = c.code
GROUP BY
    date
ORDER BY t.date, t.top5_appearances DESC     
;


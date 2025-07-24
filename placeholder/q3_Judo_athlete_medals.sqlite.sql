-- we want to find all medals that links to an athletes 
-- we want to find all medals that links to a team and then add this medal to the athletes in this team
WITH
    athletes_medals AS (
        SELECT
            a.code
        FROM
            medals m
            JOIN athletes a ON a.code = m.winner_code
        UNION ALL
        SELECT
            t.athletes_code AS code
        FROM
            medals m
            JOIN teams t ON t.code = m.winner_code
    )

SELECT
    name as athlete_name,
    COUNT(*) AS medal_number
FROM
    athletes a
    JOIN athletes_medals am ON am.code = a.code
WHERE
    a.disciplines LIKE '%judo%'
GROUP BY
    a.name
ORDER BY
    medal_number DESC,
    athlete_name ASC;
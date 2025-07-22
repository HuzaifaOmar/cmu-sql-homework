-- A medal is credited to a coach if it shares the same country and discipline with the coach
-- then I should join:
-- 1. coaches with their countries
-- 2. countries with medals
-- 3. #2 with disciplines
-- we have CREATE INDEX ix_medals_winner_code ON medals(winner_code);
-- so we can do the following:
-- for each medal get the winner (athlete or team)
-- then get the country 
-- then get the coaches who are from the same country and have the same discipline as this medal
WITH
    medal_discipline_country AS (
        SELECT
            a.country_code,
            m.*
        FROM
            medals m
            JOIN athletes a ON m.winner_code = a.code
        UNION
        SELECT
            t.country_code,
            m.*
        FROM
            medals m
            JOIN teams t ON m.winner_code = t.code
    )
SELECT
    c.name AS coach_name,
    COUNT(*) AS medal_number
FROM
    coaches c
    JOIN medal_discipline_country mdc 
    ON c.country_code = mdc.country_code
    AND c.discipline = mdc.discipline
GROUP BY
    c.name,
    c.code
ORDER BY
    medal_number DESC,
    coach_name ASC;
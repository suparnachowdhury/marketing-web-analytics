/*
TRAFFIC SOURCE TRENDING
Marketing Director:
Based on your conversion rate analysis, we bid down gsearch nonbrand on 2012-04-15.

Can you pull gsearch nonbrand trended session volume, by week, 
to see if the bid changes have caused volume to drop at all?

*/
SELECT
    -- YEAR(created_at) AS yr,
    -- WEEK(created_at) AS wk,
    MIN(DATE(created_at)) AS week_start_date,
    COUNT(website_session_id) AS sessions
FROM website_sessions
WHERE created_at < '2012-05-10'
  AND utm_source = 'gsearch'
  AND utm_campaign = 'nonbrand'
GROUP BY
    YEAR(created_at),
    WEEK(created_at);
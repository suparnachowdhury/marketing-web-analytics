/*
TRENDING WITH GRANULAR SEGMENTS
Marketing Director:
After your device-level analysis of conversion rates, we realized desktop was
 doing well, so we bid our gsearch nonbrand desktop campaigns up on 2012-05-19.

Could you pull weekly trends for both desktop and mobile so 
we can see the impact on volume?
You can use 2012-04-15 until the bid change as a baseline.

*/
SELECT
    -- YEAR(created_at),
    -- WEEK(created_at),
    MIN(DATE(created_at)) AS week_start_date,

    COUNT(DISTINCT CASE 
        WHEN device_type = 'desktop' 
        THEN website_session_id 
        ELSE NULL 
    END) AS desktop_sessions,

    COUNT(DISTINCT CASE 
        WHEN device_type = 'mobile' 
        THEN website_session_id 
        ELSE NULL 
    END) AS mobile_sessions

FROM website_sessions
WHERE created_at BETWEEN '2012-04-15' AND '2012-06-08'
  AND utm_source = 'gsearch'
  AND utm_campaign = 'nonbrand'

GROUP BY
    YEAR(created_at),
    WEEK(created_at);

    


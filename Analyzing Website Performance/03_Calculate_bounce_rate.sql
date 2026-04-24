/*
CALCULATING BOUNCE RATE
Website Manager: 
The other day you showed us that all of our traffic is landing on the homepage right now. 
We should check how that landing page is performing.
Can you pull bounce rates for traffic landing on the homepage? 
I would like to see three numbers...Sessions, Bounced Sessions, 
and % of Sessions which Bounced (aka “Bounce Rate”)
*/
CREATE TEMPORARY TABLE first_pv_per_session
SELECT 
		website_session_id,
        MIN(website_pageview_id) as first_pv
FROM website_pageviews
WHERE created_at < '2012-06-14'
GROUP BY 
		website_session_id;
        
SELECT * FROM first_pv_per_session LIMIT 5;
SELECT count(*) FROM first_pv_per_session;

CREATE TEMPORARY TABLE sessions_with_home
SELECT 
		pv.website_session_id,
        pv.pageview_url as landing_page
FROM first_pv_per_session fs
LEFT JOIN   website_pageviews pv
ON pv.website_pageview_id = fs.first_pv
WHERE pv.pageview_url = "/home";
        
-- SELECT * FROM sessions_with_home LIMIT 5;
-- SELECT count(*) FROM sessions_with_home;

CREATE TEMPORARY TABLE only_bounces_session AS         
SELECT
		sh.website_session_id,
        sh.landing_page,
        COUNT(pv.website_pageview_id) AS count_of_page_viewed
FROM sessions_with_home sh
LEFT JOIN website_pageviews pv
ON sh.website_session_id = pv.website_session_id
GROUP BY
		sh.website_session_id,
        sh.landing_page
HAVING	
		 COUNT(pv.website_pageview_id) = 1;


SELECT 
		COUNT( DISTINCT fs.website_session_id) AS sessions,
        COUNT(DISTINCT bs.website_session_id) AS bounced_sessions,
        COUNT(DISTINCT bs.website_session_id)/COUNT(DISTINCT fs.website_session_id)
* 100.0 AS bounce_rate
FROM sessions_with_home fs	
LEFT JOIN only_bounces_session bs 
ON fs.website_session_id = bs.website_session_id;
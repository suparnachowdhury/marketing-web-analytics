/*
LANDING PAGE TREND ANALYSIS
Website Manager: 
Could you pull the volume of paid search nonbrand traffic landing 
on /home and /lander-1, trended weekly since June 1st? 
I want to confirm the traffic is all routed correctly.
Could you also pull our overall paid search bounce rate trended weekly? 
I want to make sure the lander change has improved the overall picture.
*/
Could you pull the volume of paid search nonbrand traffic landing 
on /home and /lander-1, trended weekly since June 1st? 
I want to confirm the traffic is all routed correctly.
Could you also pull our overall paid search bounce rate trended weekly? 
I want to make sure the lander change has improved the overall picture.

SELECT * FROM website_sessions LIMIT 5;
SELECT   DISTINCT utm_content FROM website_sessions LIMIT 5;

-- STEP 1: Finding the landing page sessions which are the sessions with
-- minimum pageview_ids.

CREATE TEMPORARY TABLE total_traffic
SELECT
    pv.website_pageview_id,
	pv.website_session_id,
    DATE(pv.created_at) created_at,
    pv.pageview_url
FROM website_pageviews pv
INNER JOIN website_sessions ws 
ON pv.website_session_id = ws.website_session_id
WHERE pv.created_at >= '2012-06-01'
AND pv.created_at <'2012-08-31'
AND ws.utm_campaign = 'nonbrand'
AND pv.pageview_url  IN ('/home','/lander-1') ;
    
    
-- STEP 3: Filtering out only the home and lander-1 landing pages
    
CREATE TEMPORARY TABLE sessions_landing_page
SELECT 
		pv.website_session_id,
        pv.pageview_url as landing_page
FROM first_pv_per_session fs
LEFT JOIN   website_pageviews pv
ON pv.website_pageview_id = fs.first_pv
WHERE pv.pageview_url  IN ('/home','/lander-1') ;

-- STEP 4: then we count pageviews per session limiting to bounced sessions

CREATE TEMPORARY TABLE only_bounced_session AS         
SELECT
		sh.website_session_id,
        sh.landing_page,
        COUNT(pv.website_pageview_id) AS count_of_page_viewed
FROM sessions_landing_page sh
LEFT JOIN website_pageviews pv
ON sh.website_session_id = pv.website_session_id
GROUP BY
		sh.website_session_id,
        sh.landing_page
HAVING	
		 COUNT(pv.website_pageview_id) = 1;
         
-- Final output
SELECT 
	 sessions_landing_page.landing_page,
     COUNT(sessions_landing_page.website_session_id) AS sessions,
     COUNT( only_bounced_session.website_session_id) AS bounced_sessions,
     COUNT( only_bounced_session.website_session_id)/
     COUNT(sessions_landing_page.website_session_id) * 100.0 AS bounce_rate
FROM sessions_landing_page 
LEFT JOIN only_bounced_session
ON sessions_landing_page.website_session_id = only_bounced_session.website_session_id
GROUP BY sessions_landing_page.landing_page;


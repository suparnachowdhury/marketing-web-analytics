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
	pv.website_session_id,
    pv.created_at,
    pv.pageview_url,
    MIN(pv.website_pageview_id) AS first_pv
FROM website_pageviews pv
INNER JOIN website_sessions ws 
ON pv.website_session_id = ws.website_session_id
WHERE pv.created_at >= '2012-06-01'
AND pv.created_at <'2012-08-31'
AND ws.utm_campaign = 'nonbrand'
AND pv.pageview_url  IN ('/home','/lander-1') ;
 
 CREATE TEMPORARY TABLE first_pageviews
 SELECT    
	pv.website_session_id,
    MIN(pv.website_pageview_id) AS first_pv
FROM website_pageviews pv
INNER JOIN website_sessions ws 
ON pv.website_session_id = ws.website_session_id
WHERE pv.created_at >= '2012-06-01'
AND pv.created_at <'2012-08-31'
AND ws.utm_campaign = 'nonbrand'
GROUP BY
		pv.website_session_id;
    
-- STEP 3: Filtering out only the home and lander-1 landing pages
    
CREATE TEMPORARY TABLE sessions_landing_pages
SELECT 
		pv.website_session_id,
        pv.created_at,
        pv.pageview_url as landing_page
FROM first_pageviews fs
LEFT JOIN   website_pageviews pv
ON pv.website_pageview_id = fs.first_pv
WHERE pv.pageview_url  IN ('/home','/lander-1') ;


-- STEP 4: then we count pageviews per session limiting to bounced sessions

CREATE TEMPORARY TABLE only_bounced_sessions AS         
SELECT
		sh.website_session_id,
        sh.landing_page,
        COUNT(pv.website_pageview_id) AS count_of_page_viewed
FROM sessions_landing_pages sh
LEFT JOIN website_pageviews pv
ON sh.website_session_id = pv.website_session_id
GROUP BY
		sh.website_session_id,
        sh.landing_page
HAVING	
		 COUNT(pv.website_pageview_id) = 1;
         
	SELECT * FROM sessions_landing_pages LIMIT 5;
    SELECT * FROM only_bounced_sessions LIMIT 5;
-- Final output
SELECT 
week_start_date,
home_sessions,
lander1_sessions,
home_bounced_sessions/home_sessions*100 AS home_bounce_rate,
lander_bounced_sessions/lander1_sessions * 100 AS lander1_bounce_rate 
FROM (
SELECT 
	 YEAR(lp.created_at) AS yr,
     WEEK(lp.created_at) AS wk,
     MIN(DATE(lp.created_at)) AS week_start_date,
     COUNT(CASE WHEN lp.landing_page = '/home' 
				THEN lp.website_session_id ELSE NULL END ) AS home_sessions,
     COUNT(CASE WHEN lp.landing_page = '/lander-1' 
				THEN lp.website_session_id ELSE NULL END ) AS lander1_sessions,
     COUNT(CASE WHEN lp.landing_page = '/home' 
				THEN bs.website_session_id ELSE NULL END ) AS home_bounced_sessions,
	COUNT(CASE WHEN lp.landing_page = '/lander-1' 
				THEN bs.website_session_id ELSE NULL END ) AS lander_bounced_sessions
FROM sessions_landing_pages lp
LEFT JOIN only_bounced_sessions bs
ON lp.website_session_id = bs.website_session_id
GROUP BY YEAR(created_at) ,
     WEEK(created_at)) A ;


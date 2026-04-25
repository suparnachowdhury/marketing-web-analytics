/*
LANDING PAGE TREND ANALYSIS
Website Manager: 
Could you pull the volume of paid search nonbrand traffic landing 
on /home and /lander-1, trended weekly since June 1st? 
I want to confirm the traffic is all routed correctly.
Could you also pull our overall paid search bounce rate trended weekly? 
I want to make sure the lander change has improved the overall picture.
*/


SELECT * FROM website_sessions LIMIT 5;
SELECT   DISTINCT utm_content FROM website_sessions LIMIT 5;

-- STEP 1: Finding the landing page sessions which are the sessions with
-- minimum pageview_ids.

 
 CREATE TEMPORARY TABLE session_w_min_pv_id_view_count
 SELECT    
	pv.website_session_id,
    MIN(pv.website_pageview_id) AS first_pv,
    COUNT(pv.website_pageview_id) AS pageview_counts
FROM website_pageviews pv
INNER JOIN website_sessions ws 
ON pv.website_session_id = ws.website_session_id
WHERE pv.created_at >= '2012-06-01'
AND pv.created_at <'2012-08-31'
AND ws.utm_campaign = 'nonbrand'
AND ws.utm_source = 'gsearch'
GROUP BY
		pv.website_session_id;
        
        
SELECT * FROM session_w_min_pv_id_view_count LIMIT 5;
    
-- STEP 3: Filtering out only the home and lander-1 landing pages
    
CREATE TEMPORARY TABLE sessions_w_landing_page_created_at
SELECT 
		fs.*,
        pv.created_at,
        pv.pageview_url as landing_page
FROM session_w_min_pv_id_view_count fs
LEFT JOIN   website_pageviews pv
ON pv.website_pageview_id = fs.first_pv;

SELECT * FROM sessions_w_landing_page_created_at LIMIT 5;
-- STEP 4: then we count pageviews per session limiting to bounced sessions


         

-- Final output

SELECT 
	 YEARWEEK(created_at) AS year_week,
     MIN(DATE(created_at)) AS week_start_date,
     COUNT(DISTINCT website_session_id) AS total_sessions,
     COUNT(DISTINCT CASE WHEN pageview_counts = 1 
				THEN website_session_id ELSE NULL END ) AS bounced_sessions,
	COUNT(DISTINCT CASE WHEN pageview_counts = 1 
				THEN website_session_id ELSE NULL END )/
                COUNT(DISTINCT website_session_id)*100.0 AS bounced_rate,
     COUNT(CASE WHEN landing_page = '/home' 
				THEN website_session_id ELSE NULL END ) AS home_sessions,
	COUNT(CASE WHEN landing_page = '/lander-1' 
				THEN website_session_id ELSE NULL END ) AS lander1_sessions
FROM sessions_w_landing_page_created_at
GROUP BY YEARWEEK(created_at);


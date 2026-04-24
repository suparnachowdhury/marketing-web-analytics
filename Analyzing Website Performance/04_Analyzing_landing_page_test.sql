/*
ANALYZING LANDING PAGE TEST
Website Manager: 
Based on your bounce rate analysis, we ran a new custom landing page (/lander-1) 
in a 50/50 test against the homepage (/home) for our gsearch nonbrand traffic.
Can you pull bounce rates for the two groups so we can evaluate the new page?
 Make sure to just look at the time period where /lander-1 was getting traffic, 
 so that it is a fair comparison.
*/
-- STEP 1: we need to find when lander-1 page first landed
SELECT 
	MIN(created_at) AS first_created_at,
    MIN(website_pageview_id) AS first_pageview_id
FROM website_pageviews
WHERE pageview_url = '/lander-1'
AND created_at IS NOT NULL;

-- STEP 2: Finding the landing page sessions which are the sessions with
-- minimum pageview_ids.

CREATE TEMPORARY TABLE first_pv_per_session
SELECT
	pv.website_session_id,
    MIN(pv.website_pageview_id) AS first_pv
FROM website_pageviews pv
INNER JOIN website_sessions ws 
ON pv.website_session_id = ws.website_session_id
WHERE pv.website_pageview_id >= 23504
AND pv.created_at <'2012-07-28'
AND ws.utm_source = 'gsearch'
AND ws.utm_campaign = 'nonbrand'
GROUP BY 
	pv.website_session_id;
    
    
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


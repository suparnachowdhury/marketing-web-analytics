/*
FINDING TOP ENTRY PAGES
New Website Manager: 
Would you be able to pull a list of the top entry pages? I want to confirm 
where our users are hitting the site.
If you could pull all entry pages and rank them on entry volume,
that would be great.
*/

CREATE TEMPORARY TABLE first_pv_per_session
SELECT 
		website_session_id,
        MIN(website_pageview_id) as first_pv
FROM website_pageviews
WHERE created_at < '2012-06-12'
GROUP BY 
		website_session_id;
        
        
SELECT
        pv.pageview_url AS landing_page,
        COUNT(fs.website_session_id) as sessions_hitting_this_page
FROM first_pv_per_session fs
LEFT JOIN website_pageviews  pv
ON fs.first_pv = pv.website_pageview_id
GROUP BY
		pv.pageview_url;

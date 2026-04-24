/*
New Website Manager: 
Could you help me get my head around the site by pulling the most-viewed website pages, 
ranked by session volume?
*/

SELECT
	  pageview_url,
      COUNT(website_pageview_id) AS pvs
FROM website_pageviews
WHERE created_at < '2012-06-09'
GROUP BY 
		pageview_url
ORDER BY 
		pvs DESC;
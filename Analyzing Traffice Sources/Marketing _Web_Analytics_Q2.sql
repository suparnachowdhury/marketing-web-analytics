/*
Marketing Director:
Sounds like gsearch nonbrand is our major traffic source, but we need to understand 
if those sessions are driving sales.

Could you please calculate the conversion rate (CVR) from session to order? 
Based on what we're paying for clicks, we’ll need a CVR of at least 4% to make the numbers work.

If we're much lower, we’ll need to reduce bids. If we’re higher, 
we can increase bids to drive more volume.

*/
SELECT
    COUNT(w.website_session_id) AS sessions,
    COUNT(o.website_session_id) AS orders,
    COUNT(o.website_session_id) * 100.0 
        / COUNT(w.website_session_id) AS conversion_rate
FROM website_sessions w
LEFT JOIN orders o
    ON w.website_session_id = o.website_session_id
WHERE w.created_at < '2012-04-14'
  AND w.utm_source = 'gsearch'
  AND w.utm_campaign = 'nonbrand';
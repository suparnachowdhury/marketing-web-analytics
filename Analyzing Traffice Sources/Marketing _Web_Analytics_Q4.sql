/*
BID OPTIMIZATION FOR PAID TRAFFIC
Marketing Director:
I was trying to use our site on my mobile device the other day, 
and the experience was not great.

Could you pull conversion rates from session to order, by device type?

*/
SELECT
    w.device_type,
    COUNT(DISTINCT w.website_session_id) AS sessions,
    COUNT(DISTINCT o.website_session_id) AS orders,
    COUNT(DISTINCT o.website_session_id) * 100.0
        / COUNT(DISTINCT w.website_session_id) AS session_to_order_conv_ratio
FROM website_sessions w
LEFT JOIN orders o
    ON w.website_session_id = o.website_session_id
WHERE w.created_at < '2012-05-11'
  AND w.utm_source = 'gsearch'
  AND w.utm_campaign = 'nonbrand'
GROUP BY
    w.device_type;
    


/*
Finding Top Traffic Sources
Marketing Director: 
We've been live for almost a month now and we’re starting to generate sales. 
Can you help me understand where the bulk of our website sessions are coming from, 
through yesterday?
I’d like to see a breakdown by UTM source, campaign and referring domain if possible.

*/
select 
	  utm_source
      , utm_campaign
      , http_referer
      , count(website_session_id) as sessions
from website_sessions
where created_at < '2012-04-12'
group by 1,2,3
order by sessions desc;
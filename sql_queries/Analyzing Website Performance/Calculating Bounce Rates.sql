-- 定位出bounced session
CREATE TEMPORARY TABLE bounced_sessions
SELECT
  website_session_id,
  COUNT(website_pageview_id) AS pages
FROM
  website_pageviews
WHERE
  created_at < '2012-6-14'
GROUP BY
  website_session_id
HAVING
  -- 找出访问主页后随即bounce的session，即访问次数只有1次
  COUNT(website_pageview_id) = 1;
 
 SELECT
  COUNT(DISTINCT ws.website_session_id) AS sessions,
  COUNT(DISTINCT bs.website_session_id) AS bounced_sessions,
  COUNT(DISTINCT bs.website_session_id) / COUNT(DISTINCT ws.website_session_id) AS bounce_rate
FROM
  website_pageviews ws
  LEFT JOIN bounced_sessions bs ON ws.website_session_id = bs.website_session_id
WHERE
  ws.created_at < '2012-6-14';
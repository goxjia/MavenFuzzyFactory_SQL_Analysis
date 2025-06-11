USE mavenfuzzyfactory;

SELECT
	utm_source,
	utm_campaign,
	http_referer,
	count(DISTINCT website_session_id) AS sessions
FROM
	website_sessions ws
WHERE
	created_at<'2012-4-12'
GROUP BY
	1,
	2,
	3
ORDER BY
	4 DESC;
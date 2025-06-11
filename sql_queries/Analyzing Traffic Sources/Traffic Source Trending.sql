USE mavenfuzzyfactory;

SELECT
	week_start_date,
	sessions
FROM
	(
	SELECT
		WEEK(created_at) AS created_week,
		MIN(date(created_at)) AS week_start_date,
		COUNT(DISTINCT website_session_id) AS sessions
	FROM
		website_sessions ws
	WHERE
		created_at<'2012-5-10'
		AND utm_source = 'gsearch'
		AND utm_campaign = 'nonbrand'
	GROUP BY
		1) t;
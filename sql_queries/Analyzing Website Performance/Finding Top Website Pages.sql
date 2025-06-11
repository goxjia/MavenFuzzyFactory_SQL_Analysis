SELECT
	pageview_url,
	count(DISTINCT website_pageview_id) AS sessions
FROM
	website_pageviews wp
WHERE
	created_at<'2012-6-9'
GROUP BY
	1
ORDER BY
	2 DESC ;
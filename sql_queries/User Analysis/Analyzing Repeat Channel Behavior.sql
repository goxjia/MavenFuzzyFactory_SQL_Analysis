-- 观察channel_group有哪些组合
-- SELECT DISTINCT
-- 	utm_source,
-- 	utm_campaign,
-- 	http_referer
-- FROM
-- 	website_sessions
-- WHERE
-- 	created_at BETWEEN '2014-1-1'
-- 	AND '2014-11-5';
SELECT
	channel_group,
	COUNT(DISTINCT new_one) AS new_sessions,
	COUNT(DISTINCT repeat_one) AS repeat_sessions
FROM
	(
		SELECT
			*,
			CASE
				WHEN is_repeat_session = 0 THEN
					website_session_id
				ELSE
					NULL
			END AS new_one,
			CASE
				WHEN is_repeat_session = 1 THEN
					website_session_id
				ELSE
					NULL
			END AS repeat_one,
			CASE
				WHEN utm_source IS NULL
					AND utm_campaign IS NULL
					AND http_referer IS NULL THEN
					'direct_type_in'
				WHEN utm_source IS NULL
					AND utm_campaign IS NULL
					AND http_referer IS NOT NULL THEN
					'organic_search'
				WHEN utm_campaign = 'brand' THEN
					'paid_brand'
				WHEN utm_campaign = 'nonbrand' THEN
					'paid_nonbrand'
				WHEN utm_source = 'socialbook' THEN
					'paid_social'
				ELSE
					'check logic'
			END AS channel_group
		FROM
			website_sessions
		WHERE
			created_at BETWEEN '2014-1-1'
			AND '2014-11-5'
	) t
GROUP BY
	channel_group;
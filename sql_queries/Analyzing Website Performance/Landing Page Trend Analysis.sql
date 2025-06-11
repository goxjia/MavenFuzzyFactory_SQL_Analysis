-- 找出每个session的第一个pageview
CREATE TEMPORARY TABLE first_pageview SELECT
	ws.website_session_id,
	ws.created_at,
	MIN(website_pageview_id) AS first_pv_id
FROM
	website_sessions ws
	LEFT JOIN website_pageviews wp USING (website_session_id)
WHERE
	ws.created_at < '2012-08-31'
	AND ws.created_at > '2012-06-01'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand' -- 根据要求，仅选择nonbrand流量
GROUP BY
	ws.website_session_id,
	ws.created_at;
-- 为session的first_pageview匹配域名，即entry_page
CREATE TEMPORARY TABLE sessions_with_entry_page SELECT
	fp.website_session_id,
	fp.created_at,
	fp.first_pv_id,
	wp.pageview_url AS entry_page
FROM
	first_pageview fp
	LEFT JOIN website_pageviews wp ON fp.first_pv_id = wp.website_pageview_id
WHERE
	pageview_url IN ('/home', '/lander-1'); -- 仅选择entry_page为/home或/lander-1
-- 找出bounced_sessions
CREATE TEMPORARY TABLE bounced_sessions SELECT
	swep.website_session_id,
	swep.entry_page,
	COUNT(DISTINCT wp.website_pageview_id) AS count_of_page_views
FROM
	sessions_with_entry_page swep
	LEFT JOIN website_pageviews wp USING (website_session_id)
GROUP BY
	swep.website_session_id,
	swep.entry_page
HAVING
	COUNT(DISTINCT wp.website_pageview_id) = 1; -- 只选择从主页跳出的记录
-- final analysis
SELECT
	MIN(DATE(swep.created_at)) AS week_start_date, -- 找出每周的开始日期
	COUNT(DISTINCT bs.website_session_id) / COUNT(DISTINCT swep.website_session_id) AS bounce_rate,
	COUNT(DISTINCT CASE WHEN swep.entry_page = '/home' THEN swep.website_session_id ELSE NULL END) AS home_sessions, -- session的entry_page为/home的数量
	COUNT(DISTINCT CASE WHEN swep.entry_page = '/lander-1' THEN swep.website_session_id ELSE NULL END) AS lander_sessions -- session的entry_page为/lander-1的数量
FROM
	sessions_with_entry_page swep
	LEFT JOIN bounced_sessions bs ON swep.website_session_id = bs.website_session_id
GROUP BY
	YEARWEEK(swep.created_at); -- 按周分组列出，以看出trended weekly
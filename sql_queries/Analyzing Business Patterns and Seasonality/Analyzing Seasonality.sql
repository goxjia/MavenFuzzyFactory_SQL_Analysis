-- 按月展示趋势
SELECT
	YEAR(ws.created_at) AS yr,
	MONTH(ws.created_at) AS mo,
	COUNT(DISTINCT ws.website_session_id) AS sessions,
	COUNT(DISTINCT o.order_id) AS orders
FROM
	website_sessions ws
	LEFT JOIN orders o ON ws.website_session_id = o.website_session_id
WHERE
	ws.created_at < '2013-1-1'
GROUP BY
	1,
	2;
	
-- 按周展示趋势
SELECT
	-- 	YEARWEEK(ws.created_at),
	MIN(DATE(ws.created_at)) AS week_start_date,
	COUNT(DISTINCT ws.website_session_id) AS sessions,
	COUNT(DISTINCT o.order_id) AS orders
FROM
	website_sessions ws
	LEFT JOIN orders o ON ws.website_session_id = o.website_session_id
WHERE
	ws.created_at < '2013-1-1'
GROUP BY
	YEARWEEK(ws.created_at);
	
-- 11.18和11.25开始的这两周量最大，按weekday来展示趋势，如果是周末的话，需要考虑增加人手和加强库存管理等
SELECT
	WEEK(ws.created_at) AS wk,
	DATE(ws.created_at) AS dt,
	WEEKDAY(ws.created_at) AS week_day,
	COUNT(DISTINCT ws.website_session_id) AS sessions,
	COUNT(DISTINCT o.order_id) AS orders
FROM
	website_sessions ws
	LEFT JOIN orders o ON ws.website_session_id = o.website_session_id
WHERE
	ws.created_at BETWEEN '2012-11-18'
	AND '2012-12-02'
GROUP BY
	1,
	2,
	3;
-- 高峰期出现在11.23和11.26，sessions分别为3289、2160，orders分别为153、108。经确认这两天分别为black Friday 和cyber Monday
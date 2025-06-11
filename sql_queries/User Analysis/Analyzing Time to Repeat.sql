-- STEP1：找出user_id的first session_id，以及created_at
-- STEP2：上述左联结至website_sessions，找出同user_id的下一个session_id
-- STEP3：再次左联结至website_sessions，找出匹配second_session的created_at
-- STEP4：按user_id分组，聚合计算
-- STEP1
CREATE TEMPORARY TABLE first_session SELECT
	user_id,
	website_session_id AS first_session_id,
	created_at AS first_session_timestamp
FROM
	website_sessions
WHERE
	created_at BETWEEN '2014-1-1'
	AND '2014-11-3'
	AND is_repeat_session = 0; -- first sessions only
-- STEP2
CREATE TEMPORARY TABLE second_session SELECT
	fs.user_id,
	fs.first_session_id,
	fs.first_session_timestamp,
	MIN(ws.website_session_id) AS second_session_id
FROM
	first_session fs
	LEFT JOIN website_sessions ws ON fs.user_id = ws.user_id
	AND ws.website_session_id > fs.first_session_id -- 找出同个user下一个session
	AND ws.is_repeat_session = 1
	AND ws.created_at BETWEEN '2014-1-1'
	AND '2014-11-3'
GROUP BY
	1,
	2,
	3
HAVING
	MIN(ws.website_session_id) IS NOT NULL; -- 剔除只有一个session的记录
-- STEP3
CREATE TEMPORARY TABLE fully_information SELECT
	ss.user_id,
	ss.first_session_id,
	ss.first_session_timestamp,
	ss.second_session_id,
	ws.created_at AS second_session_timestamp
FROM
	second_session ss
	LEFT JOIN website_sessions ws ON ss.second_session_id = ws.website_session_id;
	
-- STEP4
SELECT
	AVG(DATEDIFF(second_session_timestamp, first_session_timestamp)) AS avg_days_first_to_second,
	MIN(DATEDIFF(second_session_timestamp, first_session_timestamp)) AS min_days_first_to_second,
	MAX(DATEDIFF(second_session_timestamp, first_session_timestamp)) AS max_days_first_to_second
FROM
	fully_information;
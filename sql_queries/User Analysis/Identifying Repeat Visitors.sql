-- STEP1：找出user_id的new session_id
-- STEP2：上述左联结至website_sessions，找出同user_id的session_id，即找出repeatd_session_id
-- STEP3：按user_id分组，聚合计算repeatd_session数量
-- STEP1
CREATE TEMPORARY TABLE user_new_session SELECT
	user_id,
	website_session_id AS new_session_id
FROM
	website_sessions
WHERE
	created_at BETWEEN '2014-1-1'
	AND '2014-11-1'
	AND is_repeat_session = 0; -- new sessions only
-- STEP2
CREATE TEMPORARY TABLE user_repeat_session SELECT
	uns.user_id,
	uns.new_session_id,
	ws.website_session_id AS repeat_session_id
FROM
	user_new_session uns
	LEFT JOIN website_sessions ws ON uns.user_id = ws.user_id
	AND ws.website_session_id > uns.new_session_id
	AND ws.is_repeat_session = 1
	AND ws.created_at BETWEEN '2014-1-1'
	AND '2014-11-1';
-- STEP3
SELECT
	repeat_sessions,
	COUNT(DISTINCT user_id) AS users
FROM
	(SELECT user_id, COUNT(DISTINCT repeat_session_id) AS repeat_sessions FROM user_repeat_session GROUP BY user_id ORDER BY repeat_sessions DESC) t
GROUP BY
	repeat_sessions;
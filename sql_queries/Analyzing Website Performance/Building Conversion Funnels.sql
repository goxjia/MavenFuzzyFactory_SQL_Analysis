-- BUSINESS CONTEXT
-- we want to build a mini conversion funnel, from /lander-2 to /cart
-- we want to know how many people reach each step, and also dropoff rates
-- for simplicity of the demo, we're looking at /lander-2 traffic only
-- for simplicity of the demo, we're lookign at customers who like Mr Fuzzy only
-- STEP 1: select all pageviews for relevant sessions
-- STEP 2: identify each relevant pageview as the specific funnel step
-- STEP 3: create the session-level conversion funnel view
-- STEP 4: aggregate the data to assess funnel performance
CREATE TEMPORARY TABLE session_level_flags SELECT
	website_session_id,
	SUM(products_page) AS products_made_it,
	SUM(mrfuzzy_page) AS mrfuzzy_made_it,
	SUM(cart_page) AS cart_made_it
FROM
	(
		SELECT
			ws.website_session_id,
			wp.pageview_url,
			wp.created_at AS pageview_created_at,
			CASE
				WHEN pageview_url = '/products' THEN
					1
				ELSE
					0
			END AS products_page,
			CASE
				WHEN pageview_url = '/the-original-mr-fuzzy' THEN
					1
				ELSE
					0
			END AS mrfuzzy_page,
			CASE
				WHEN pageview_url = '/cart' THEN
					1
				ELSE
					0
			END AS cart_page
		FROM
			website_sessions ws
			LEFT JOIN website_pageviews wp ON ws.website_session_id = wp.website_session_id
		WHERE
			ws.created_at BETWEEN '2014-01-01'
			AND '2014-02-01'
			AND wp.pageview_url IN ('/lander-2', '/products', '/the-original-mr-fuzzy', '/cart')
		ORDER BY
			ws.website_session_id ASC
	) AS pageview_level
GROUP BY
	website_session_id;
SELECT
	COUNT(DISTINCT website_session_id) AS sessions,
	SUM(products_made_it) / COUNT(DISTINCT website_session_id) AS to_products,
	SUM(mrfuzzy_made_it) / SUM(products_made_it) AS to_mrfuzzy,
	SUM(cart_made_it) / SUM(mrfuzzy_made_it) AS to_cart
FROM
	session_level_flags
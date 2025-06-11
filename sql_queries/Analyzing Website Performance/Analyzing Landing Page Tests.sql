-- Finding the first instance of /lander-1 to set analysis timeframe
SELECT
    MIN(created_at) AS first_created_at,
    MIN(website_pageview_id) AS first_pageview_id
FROM
    website_pageviews
WHERE
    pageview_url = '/lander-1';

-- Analyzing bounce rates for landing pages
WITH first_pageview AS (
    -- Identify the first pageview for each session within the analysis timeframe
    SELECT
        wp.website_session_id,
        MIN(wp.website_pageview_id) AS first_pg_id
    FROM
        website_pageviews wp
    INNER JOIN
        website_sessions ws
        ON wp.website_session_id = ws.website_session_id
    WHERE
        wp.website_pageview_id > 23504 -- Start of analysis timeframe
        AND wp.created_at < '2012-07-28' -- End of analysis timeframe
        AND ws.utm_source = 'gsearch'
        AND ws.utm_campaign = 'nonbrand'
    GROUP BY
        1
),
session_landing_page AS (
    -- Determine the landing page for each session
    SELECT
        fp.website_session_id,
        fp.first_pg_id,
        wp.pageview_url AS landing_page
    FROM
        first_pageview AS fp
    LEFT JOIN
        website_pageviews wp
        ON fp.first_pg_id = wp.website_pageview_id
    WHERE
        wp.pageview_url IN ('/home', '/lander-1') -- Restrict to '/home' and '/lander-1' for analysis
),
bounced_sessions AS (
    -- Identify sessions that bounced (only one pageview)
    SELECT
        slp.website_session_id,
        COUNT(DISTINCT wp.website_pageview_id) AS count_of_page_views
    FROM
        session_landing_page slp
    LEFT JOIN
        website_pageviews wp
        ON slp.website_session_id = wp.website_session_id
    GROUP BY
        1
    HAVING
        COUNT(DISTINCT wp.website_pageview_id) = 1
)
SELECT
    slp.landing_page,
    COUNT(DISTINCT slp.website_session_id) AS total_sessions,
    COUNT(DISTINCT bs.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT bs.website_session_id) * 1.0 / COUNT(DISTINCT slp.website_session_id) AS bounced_rate
FROM
    session_landing_page slp
LEFT JOIN
    bounced_sessions bs
    ON slp.website_session_id = bs.website_session_id
GROUP BY
    slp.landing_page
ORDER BY
    bounced_rate DESC;
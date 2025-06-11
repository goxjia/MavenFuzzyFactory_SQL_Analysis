SELECT
	YEAR(oi.created_at) AS yr,
	MONTH(oi.created_at) AS mo,
	COUNT(DISTINCT CASE WHEN oi.product_id = 1 THEN oi.order_id ELSE NULL END) AS p1_orders,
	-- 	COUNT(DISTINCT CASE WHEN oi.product_id = 1 THEN oir.order_item_refund_id ELSE NULL END) AS p1_refunds,
	COUNT(DISTINCT CASE WHEN oi.product_id = 1 THEN oir.order_item_refund_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN oi.product_id = 1 THEN oi.order_id ELSE NULL END) AS p1_refund_rt,
	COUNT(DISTINCT CASE WHEN oi.product_id = 2 THEN oi.order_id ELSE NULL END) AS p2_orders,
	-- 	COUNT(DISTINCT CASE WHEN oi.product_id = 2 THEN oir.order_item_refund_id ELSE NULL END) AS p2_refunds,
	COUNT(DISTINCT CASE WHEN oi.product_id = 2 THEN oir.order_item_refund_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN oi.product_id = 2 THEN oi.order_id ELSE NULL END) AS p2_refund_rt,
	COUNT(DISTINCT CASE WHEN oi.product_id = 3 THEN oi.order_id ELSE NULL END) AS p3_orders,
	-- 	COUNT(DISTINCT CASE WHEN oi.product_id = 3 THEN oir.order_item_refund_id ELSE NULL END) AS p3_refunds,
	COUNT(DISTINCT CASE WHEN oi.product_id = 3 THEN oir.order_item_refund_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN oi.product_id = 3 THEN oi.order_id ELSE NULL END) AS p3_refund_rt,
	COUNT(DISTINCT CASE WHEN oi.product_id = 4 THEN oi.order_id ELSE NULL END) AS p4_orders,
	-- 	COUNT(DISTINCT CASE WHEN oi.product_id = 4 THEN oir.order_item_refund_id ELSE NULL END) AS p4_refunds,
	COUNT(DISTINCT CASE WHEN oi.product_id = 4 THEN oir.order_item_refund_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN oi.product_id = 4 THEN oi.order_id ELSE NULL END) AS p4_refund_rt
FROM
	order_items oi
	LEFT JOIN order_item_refunds oir ON oi.order_item_id = oir.order_item_id
WHERE
	oi.created_at < '2014-10-15'
GROUP BY
	1,
	2;
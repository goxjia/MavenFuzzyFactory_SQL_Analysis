# 用户分析洞察 (User Analysis Insights)

本部分专注于Maven Fuzzy Factory的用户行为分析，特别是重复访问用户的识别、回访时间间隔以及他们通过哪些渠道回访，并比较新老用户的转化率和每会话收入，以更好地理解其价值。

## 1. 识别重复访客 (Identifying Repeat Visitors)

* **需求**: Tom希望了解网站访客中，有多少人会返回进行第二次会话，以评估重复访客的价值和获取成本。数据范围是2014年至今 。
* **结果**:
    | repeat_sessions | users |
    |-----------------|-------|
    | 0               | 126813|
    | 1               | 14086 |
    | 2               | 315   |
    | 3               | 4686  |
* **亮点与结论**:
    * 相当一部分客户在首次会话后会再次访问网站，有14086名用户进行了1次重复会话，315名用户进行了2次重复会话，4686名用户进行了3次重复会话 。
    * Tom认为这很有趣，并计划进一步了解这些重复访客的行为 。

## 2. 分析重复访问时间间隔 (Analyzing Time to Repeat)

* **需求**: Tom希望了解那些返回网站的客户，其首次和第二次会话之间的最短、最长和平均时间间隔。数据范围仍为2014年至今 。
* **结果**:
    | avg_days_first_to_second | min_days_first_to_second | max_days_first_to_second |
    |--------------------------|--------------------------|--------------------------|
    | 33.2622                  | 1                        | 69                       |
* **亮点与结论**:
    * 平均而言，重复访客大约在一个月（33.26天）后返回网站 。
    * 最短回访时间为1天，最长为69天 。
    * Tom计划进一步调查这些访客使用的渠道 。

## 3. 分析重复访问渠道行为 (Analyzing Repeat Channel Behavior)

* **需求**: Tom希望了解重复访客主要通过哪些渠道回访，以及公司是否多次通过付费搜索广告付费获取这些客户。他希望比较新会话和重复会话在不同渠道的分布。数据范围为2014年至今 。
* **结果**:
    | channel_group   | new_sessions | repeat_sessions |
    |-----------------|--------------|-----------------|
    | organic_search  | 7139         | 11507           |
    | paid_brand      | 6432         | 11027           |
    | direct_type_in  | 6591         | 10564           |
    | paid_nonbrand   | 119950       | 0               |
    | paid_social     | 7652         | 0               |
* **亮点与结论**:
    * 客户重复访问时，主要通过有机搜索、付费品牌和直接输入渠道返回 。
    * 只有大约三分之一的重复访客通过付费渠道返回，而且品牌点击成本低于非品牌点击 。
    * 因此，公司为后续访问支付的成本不高 。Tom好奇这些重复访问是否会转化为订单 。

## 4. 分析新旧用户转化率 (Analyzing New & Repeat Conversion Rates)

* **需求**: Morgan希望比较重复会话和新会话的转化率和每会话收入，数据范围为2014年至今 。
* **结果**:
    | is_repeat_session | sessions | conv_rate | rev_per_session |
    |-------------------|----------|-----------|-----------------|
    | 0                 | 149787   | 0.0680    | 4.343754        |
    | 1                 | 33577    | 0.0811    | 5.168828        |
* **亮点与结论**:
    * 重复会话的转化率 (0.0811) 高于新会话 (0.0680) 。
    * 重复会话的每会话收入 (5.168828) 也高于新会话 (4.343754) 。
    * Morgan认为重复会话的价值更高，因为公司为它们的后续访问支付的成本不高，这应在付费流量竞价时考虑在内 。

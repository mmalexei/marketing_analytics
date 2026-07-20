CREATE DATABASE marketing;

CREATE TABLE facebook_ads(
    date DATE,
    campaign_id VARCHAR(20),
    campaign_name VARCHAR(100),
    ad_set_id VARCHAR(20),
    ad_set_name VARCHAR(100),
    impressions int,
    clicks int,
    spend numeric(10,2),
    conversions int,
    video_views int,
    engagement_rate numeric,
    reach int,
    frequency numeric
);


CREATE TABLE google_ads(
    date DATE,
    campaign_id VARCHAR(20),
    campaign_name VARCHAR(100),
    ad_group_id VARCHAR(20),
    ad_group_name VARCHAR(100),
    impressions INT,
    clicks INT,
    cost NUMERIC(10,2),
    conversions INT,
    conversion_value NUMERIC(10,2),
    ctr NUMERIC(6,4),
    avg_cpc NUMERIC(10,2),
    quality_score INT,
    search_impression_share NUMERIC(6,4)
);

CREATE TABLE tiktok_ads(
    date DATE,
    campaign_id VARCHAR(20),
    campaign_name VARCHAR(100),
    adgroup_id VARCHAR(20),
    adgroup_name VARCHAR(100),
    impressions INT,
    clicks INT,
    cost NUMERIC(10,2),
    conversions INT,
    video_views INT,
    video_watch_25 INT,
    video_watch_50 INT,
    video_watch_75 INT,
    video_watch_100 INT,
    likes INT,
    shares INT,
    comments INT
);

COPY facebook_ads
FROM 'D:\Pruebas\Pureba tecnica\engagement-lead-assignment\01_facebook_ads.csv'
DELIMITER ','
CSV HEADER;

COPY google_ads
FROM 'D:\Pruebas\Pureba tecnica\engagement-lead-assignment\02_google_ads.csv'
DELIMITER ','
CSV HEADER;

COPY tiktok_ads
FROM 'D:\Pruebas\Pureba tecnica\engagement-lead-assignment\03_tiktok_ads.csv'
DELIMITER ','
CSV HEADER;

SELECT count(*) FROM tiktok_ads


CREATE TABLE facebook_dummy(
    date DATE,
    campaign_id VARCHAR(20),
    campaign_name VARCHAR(100),
    ad_group_id VARCHAR(20),
    ad_group_name VARCHAR(100),
    impressions int,
    clicks int,
    cost numeric(10,2),
    conversions int,
    video_views int,
    engagement_rate numeric,
    reach int,
    frequency numeric,
    ctr FLOAT,
    view_rate FLOAT,
    cpc FLOAT,
    conversion_rate FLOAT,
    channel VARCHAR(50),
    data_source VARCHAR(50)
);

CREATE TABLE google_dummy(
    date DATE,
    campaign_id VARCHAR(20),
    campaign_name VARCHAR(100),
    ad_group_id VARCHAR(20),
    ad_group_name VARCHAR(100),
    impressions INT,
    clicks INT,
    cost NUMERIC(10,2),
    conversions INT,
    conversion_value NUMERIC(10,2),
    ctr NUMERIC(6,4),
    cpc NUMERIC(10,2),
    quality_score INT,
    search_impression_share NUMERIC(6,4),
    conversion_rate float,
    channel VARCHAR(50),
    data_source VARCHAR(50)
);


CREATE TABLE tiktok_dummy(
    date DATE,
    campaign_id VARCHAR(20),
    campaign_name VARCHAR(100),
    ad_group_id VARCHAR(20),
    ad_group_name VARCHAR(100),
    impressions INT,
    clicks INT,
    cost NUMERIC(10,2),
    conversions INT,
    video_views INT,
    video_watch_25 INT,
    video_watch_50 INT,
    video_watch_75 INT,
    video_watch_100 INT,
    likes INT,
    shares INT,
    comments INT,
    ctr float,
    view_rate FLOAT,
    cpc FLOAT,
    conversion_rate FLOAT,
    channel VARCHAR(50),
    data_source VARCHAR(50)
);

COPY facebook_dummy
FROM 'D:\Pruebas\marketing_analytics\dummy_data\fb_dummy.csv'
DELIMITER ','
CSV HEADER;

COPY google_dummy
FROM 'D:\Pruebas\marketing_analytics\dummy_data\gg_dummy.csv'
DELIMITER ','
CSV HEADER;

COPY tiktok_dummy
FROM 'D:\Pruebas\marketing_analytics\dummy_data\tt_dummy.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE marketing_data as 
SELECT
    date,
    campaign_id,
    campaign_name,
    ad_group_id,
    ad_group_name,

    channel,
    data_source,

    impressions,
    clicks,
    cost,
    ctr,
    cpc,

    conversions,
    conversion_rate,

    video_views,
    view_rate,

    engagement_rate,
    reach,
    frequency,

    NULL::NUMERIC AS conversion_value,
    NULL::NUMERIC AS quality_score,
    NULL::NUMERIC AS search_impression_share,

    NULL::INT AS video_watch_25,
    NULL::INT AS video_watch_50,
    NULL::INT AS video_watch_75,
    NULL::INT AS video_watch_100,

    NULL::INT AS likes,
    NULL::INT AS shares,
    NULL::INT AS comments

FROM facebook_dummy
UNION ALL

SELECT
    date,
    campaign_id,
    campaign_name,
    ad_group_id,
    ad_group_name,

    channel,
    data_source,

    impressions,
    clicks,
    cost,
    ctr,
    cpc,

    conversions,
    conversion_rate,

    NULL,
    NULL,

    NULL,
    NULL,
    NULL,

    conversion_value,
    quality_score,
    search_impression_share,

    NULL,
    NULL,
    NULL,
    NULL,

    NULL,
    NULL,
    NULL

FROM google_dummy
UNION ALL

SELECT
    date,
    campaign_id,
    campaign_name,
    ad_group_id,
    ad_group_name,

    channel,
    data_source,

    impressions,
    clicks,
    cost,
    ctr,
    cpc,

    conversions,
    conversion_rate,

    video_views,
    view_rate,

    NULL,
    NULL,
    NULL,

    NULL,
    NULL,
    NULL,

    video_watch_25,
    video_watch_50,
    video_watch_75,
    video_watch_100,

    likes,
    shares,
    comments

FROM tiktok_dummy;

SELECT * FROM marketing_data

SELECT
    channel,
    COUNT(*) AS campaigns,
    SUM(cost) AS total_cost,
    SUM(clicks) AS total_clicks,
    SUM(conversions) AS total_conversions
FROM marketing_data
GROUP BY channel;

SELECT
    data_source,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    SUM(cost) AS cost
FROM marketing_data
GROUP BY data_source;
-- string to datetimestamp: https://cloud.google.com/bigquery/docs/reference/standard-sql/timestamp_functions#parse_timestamp
-- change timezone: https://stackoverflow.com/questions/12482637/bigquery-converting-to-a-different-timezone

SELECT
    clientip,
    Name,
    total,
    lost,
    time,
    datetime(
        parse_timestamp("%F %T", time, "Asia/Shanghai"),
        "America/Los_Angeles"
    ) as google_log_time
FROM
    `opscenter.network_diagnosis_asia.htzx_asia` as a --, unnest(tracert) as b
WHERE
    ClientIP = '223.205.38.233' --   and UserID like '%9896291%'
    and Diagtype = 1 --   and total = lost
    --   and b.hop = '*'
order by
    Time
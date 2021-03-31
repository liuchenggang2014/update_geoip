-- percentile search example
-- by 15 min to percentile the ping latency of client diagnose data of zl
SELECT
    DISTINCT TIMESTAMP_SECONDS(
        15 * 60 * DIV(
            UNIX_SECONDS(PARSE_TIMESTAMP('%F %H:%M:%S', time)),
            15 * 60
        )
    ) timekey,
    PERCENTILE_CONT(Average, 0.9) OVER(
        PARTITION BY TIMESTAMP_SECONDS(
            15 * 60 * DIV(
                UNIX_SECONDS(PARSE_TIMESTAMP('%F %H:%M:%S', time)),
                15 * 60
            )
        )
    ) AS p90
FROM
    `opscenter.network_diagnosis_asia.htzx_asia` nt
    INNER JOIN `opscenter.networktest.GeoIP_Country_Range` gcr ON NET.IP_FROM_STRING(nt.ClientIP) < gcr.end_ip_byte
    AND NET.IP_FROM_STRING(nt.ClientIP) > gcr.start_ip_byte
WHERE
    nt.Diagtype = 4
    and gcr.country_iso_code = 'MY'
    AND nt.Time > "2021-03-31 14:00:00"
    AND nt.Time <= "2021-03-31 14:30:00"
    AND nt.Average != 0
    AND nt.Average < 1000
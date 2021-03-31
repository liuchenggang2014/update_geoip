-- NET.IP_FROM_STRING
-- https://cloud.google.com/bigquery/docs/reference/standard-sql/net_functions#netip_from_string
-- convert the ip address into bytes to compare the subnet's startip and end ip

SELECT
  *
FROM
  `opscenter.networktest.GeoIP_ISP_Range`
WHERE
  asn = '9908'
  AND NET.IP_FROM_STRING(start_IP) < NET.IP_FROM_STRING('61.18.36.61')
  and NET.IP_FROM_STRING(end_IP) > NET.IP_FROM_STRING('61.18.36.61')


-- search by asn number 
SELECT a.ClientIP, b.start_IP, b.end_IP, b.asn, a.time FROM `opscenter.network_diagnosis_asia.htzx_asia` as a
inner join 
`opscenter.networktest.GeoIP_ISP_Range` as b
on NET.IP_FROM_STRING(a.ClientIP) between  b.start_ip_byte and b.end_ip_byte 
where b.asn = '9908'
and a.time like '%2021%'
order by a.time desc
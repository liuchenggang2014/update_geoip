-- by country code to search the high latency data in gaming diagtype = 4 and latency > 300
-- group by the isp and asn 
-- to trouble shooting the data for YingHao
  
  
with a as(
SELECT
  nt.ClientIP, nt.Average, gcr.*, gir.*
FROM
  `opscenter.network_diagnosis_asia.htzx_asia` nt
INNER JOIN
  `opscenter.networktest.GeoIP_Country_Range` gcr
ON
  NET.IP_FROM_STRING(nt.ClientIP) < gcr.end_ip_byte
  AND NET.IP_FROM_STRING(nt.ClientIP) > gcr.start_ip_byte
inner join
`opscenter.networktest.GeoIP_ISP_Range` gir
ON
  NET.IP_FROM_STRING(nt.ClientIP) < gIr.end_ip_byte
  AND NET.IP_FROM_STRING(nt.ClientIP) > gIr.start_ip_byte
WHERE
  nt.Diagtype = 4
  and gcr.country_iso_code = 'MY'
  AND nt.Time > "2021-03-31 09:00:00"
  # AND nt.Time <= "2021-03-31 14:30:00"
  AND nt.Average != 0
  and nt.Average > 300
)
select country_iso_code,isp,asn,count(1) as diag_counts, avg(Average) as ave_latency
from a group by country_iso_code,isp, asn
  # group by nt.UserID
  # AND nt.Average < 1000

order by 4 desc
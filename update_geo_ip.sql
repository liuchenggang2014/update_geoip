CREATE TEMP FUNCTION cidrToRange(CIDR STRING)
RETURNS STRUCT<start_IP STRING, end_IP STRING>
LANGUAGE js AS """
  var beg = CIDR.substr(CIDR,CIDR.indexOf('/'));
  var end = beg;
  var off = (1<<(32-parseInt(CIDR.substr(CIDR.indexOf('/')+1))))-1; 
  var sub = beg.split('.').map(function(a){return parseInt(a)});
  var buf = new ArrayBuffer(4); 
  var i32 = new Uint32Array(buf);
  i32[0]  = (sub[0]<<24) + (sub[1]<<16) + (sub[2]<<8) + (sub[3]) + off;
  var end = Array.apply([],new Uint8Array(buf)).reverse().join('.');
  return {start_IP: beg, end_IP: end};
"""; 
create or replace table `opscenter.networktest.GeoIP_ISP_Range` as (
SELECT network, IP_range.*,isp,asn,aso
FROM `opscenter.networktest.GeoIP_ISP`,
UNNEST([cidrToRange(network)]) IP_range );

create or replace table `opscenter.networktest.GeoIP_ISP_Range` as (
SELECT network, IP_range.*,country_name, country_iso_code
FROM `opscenter.networktest.GeoIP_ISP`,
UNNEST([cidrToRange(network)]) IP_range );
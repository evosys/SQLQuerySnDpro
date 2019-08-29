select distinct ps.DISTRIBUTOR, ps.DSR,
 COUNT(distinct town+locality+slocality+pop+cast(status_Date as varchar)) as OutletCount
,Jc.JCNO 
from POP_STATUS ps
join JC_WEEK jc on ps.STATUS_DATE between jc.START_DATE and jc.END_DATE
join DSR ds on ps.DISTRIBUTOR = ds.DISTRIBUTOR and ps.DSR = ds.DSR
where YEAR(status_Date)='2017' and (jc.week_no between '32' and '35') and ps.distributor ='93010001'
and ps.dsr in (select distinct dsr from dsr where job_type in ('01','03') and countersale_YN='N' )
group by ps.DISTRIBUTOR, ps.DSR, jc.JCNO

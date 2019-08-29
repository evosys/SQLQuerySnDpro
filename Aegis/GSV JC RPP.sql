
select dlv.COMP2_DESC Region,dlv.COMP3_DESC Area,t.LDESC Town,
p.distributor,d.NAME, p.town+p.locality+p.slocality+p.pop popcode , replace(p.name,char(9),'') outlet_name ,
case 
when p.active = 1 then 'Active'
when p.active = 0 then 'InActive'
end Store_ActiveClosed,
[01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12]
,rp.RPP
from pop p
left join distributor d on d.DISTRIBUTOR = p.DISTRIBUTOR
 left join TOWN t on d.TOWN =t.TOWN and t.GEOCODE = d.GEOCODE
left join (
		select da.DISTRIBUTOR,da.VALUE_COMB,clvl.comp2_desc ,clvl.comp3_desc from DISTRIBUTOR_ASSOCIATION da
		join
		vw_complevel clvl on da.VALUE_COMB= clvl.COMPCODE 
		join 
		( 
			select distinct DISTRIBUTOR, COUNT (DISTRIBUTOR) AS CNT from DISTRIBUTOR_ASSOCIATION
			where FIELD_COMB = 'compcode'
			group by DISTRIBUTOR
		) dbl on da.SEQ_NO= dbl.CNT and dbl.DISTRIBUTOR =da.DISTRIBUTOR
	) dlv on p.distributor = dlv.distributor
---- GSV start
left join (
select distinct  distributor,codele, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12]
from 
(
select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele,jw.JCNO,
 sum(((cm.net_amount/1.1)-cm.tot_discount)) GSV
from cashmemo cm 
left join jc_week jw on cm.doc_date between jw.start_date and jw.end_date 
where cm.VISIT_TYPE = '02' and jw.year = '2018'
group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop ,jw.JCNO
) x
pivot
    (
      sum(GSV) for jcno in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12])
    ) as PVT
)gs on gs.distributor = p.distributor and p.town+p.locality+p.slocality+p.pop = gs.codele
--GSV end

-- test rpp
left join (
select pmb.DISTRIBUTOR,cmt.codepop,
(cmt.sales/(11 - pmb.Status)) RPP
from 
 (
select cm.DISTRIBUTOR, cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP codepop , SUM(((cm.net_amount/1.1)-cm.tot_discount)) sales from cashmemo cm
where cm.visit_type = '02' and year(cm.DOC_DATE) = '2018'
group by cm.DISTRIBUTOR, cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP ) 
cmt 
---- join untk membuat pembaginya
left join (
select p.DISTRIBUTOR, p.town+p.locality+p.slocality+p.pop codepop,jw.JCNO,jw.year,
(case when jw.year = year(getdate()) then jw.JCNO 
when jw.year <> year(getdate()) then '1' end )as [Status]
 from pop p
join jc_week jw on p.identify_on between jw.start_date and jw.end_date)
 pmb  on cmt.codepop = pmb.codepop and cmt.DISTRIBUTOR = pmb.DISTRIBUTOR
 ) rp on rp.DISTRIBUTOR =p.DISTRIBUTOR and rp.codepop = p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP

 where p.ACTIVE = '1' and ISNUMERIC(p.distributor) = '1'
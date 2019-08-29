-- start no 1
select ds.DISTRIBUTOR, ds.DSR,ds.NAME ,ph.LDESC pjp,sc.LDESC selling_category from DSR ds
	join PJP_HEAD ph on ph.DSR =ds.DSR and ph.DISTRIBUTOR = ds.DISTRIBUTOR
	join SELLING_CATEGORY sc on sc.DISTRIBUTOR = ds.DISTRIBUTOR and sc.SELL_CATEGORY = ph.SELL_CATEGORY
where --ds.dsr ='10' and ds.DISTRIBUTOR = '15060926' and 
	ph.ACTIVE = 1 and ds.job_type <>'02' and sc.LDESC like '%fast%'
-- end no 1
-- Start no 2
select sp.selling_category,se.LDESC sub_elemt,count(p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP) Total_outlet 
from pop p
	join (select distinct z.distributor,z.town,z.locality,z.slocality,z.pop,
		skt.LDESC selling_category,z.pjp,ph.DSR,ds.name,sc.LDESC section 
		from SECTION_POP z
			join PJP_HEAD ph on z.DISTRIBUTOR=ph.DISTRIBUTOR and z.PJP=ph.PJP and z.SELL_CATEGORY=ph.SELL_CATEGORY
			join  DSR ds on ph.DISTRIBUTOR=ds.DISTRIBUTOR and ph.DSR=ds.DSR
			join SECTION sc on sc.DISTRIBUTOR =z.DISTRIBUTOR and sc.SELL_CATEGORY =z.SELL_CATEGORY and sc.SECTION = z.SECTION
			join SELLING_CATEGORY skt on skt.SELL_CATEGORY = z.SELL_CATEGORY and skt.DISTRIBUTOR =z.DISTRIBUTOR
		where ds.job_type <>'02' and skt.LDESC like '%fast%'
	) sp on p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP=sp.DISTRIBUTOR+sp.TOWN+sp.LOCALITY+sp.SLOCALITY+sp.POP
	left join SUB_ELEMENT se on se.SUB_ELEMENT =p.SUB_ELEMENT
where -- p.ACTIVE ='1' and
	isnumeric(p.distributor)=1
group by sp.selling_category,se.LDESC
 ---end no 2
 
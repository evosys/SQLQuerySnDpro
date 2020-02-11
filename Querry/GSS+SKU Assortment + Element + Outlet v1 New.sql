with

z as (

select distinct p.DISTRIBUTOR+p.town+locality+slocality+pop as DTLE, p.DISTRIBUTOR, dt.cust_type, dt.complvl2, 
dt.complvl3, p.Town+Locality+Slocality+Pop as LE, se.eledesc, tw.ldesc as tow, p.street as st  from pop p

join (select distinct sub_element, s.element, e.ldesc as eledesc from sub_element s
      join element e on s.element = e.element and s.master_channel+s.channel+s.sub_channel
      = e.master_channel+e.channel+e.sub_channel
      )se on p.sub_element = se.sub_element

join town tw on p.town = tw.town

join (select d.Distributor, cus.VALUE_COMB as cust_type, das.complvl2, das.complvl3 from distributor d
      join (select distinct da.distributor,value_comb, ct.complvl2, ct.complvl3 from distributor_association da
            join (select distinct compcode, t.comp3, c3.ldesc as complvl3, c2.ldesc as complvl2 from comp_table t
                  join comp_level3 c3 on t.comp3 = c3.comp3 and t.comp2=c3.comp2 
                  and t.comp1 = c3.comp1
				  join comp_level2 c2 on  t.comp2=c2.comp2 and t.comp1 = c2.comp1
            )ct on da.value_comb = ct.compcode
            where field_comb='Compcode' and seq_no=1
        )das on d.DISTRIBUTOR = das.DISTRIBUTOR
       join (select distributor, VALUE_COMB from DISTRIBUTOR_ASSOCIATION where FIELD_COMB='cust_type'
		)cus on d.DISTRIBUTOR = cus.DISTRIBUTOR
	  where isnumeric(d.distributor)=1
	  )dt on p.DISTRIBUTOR = dt.DISTRIBUTOR
	  
),
 
x1 as(
		  select distinct cd.DISTRIBUTOR, sku, jc.jcno, jc.YEAR, cm.LE from cashmemo_detail cd
		  
		  join JC_WEEK jc on cd.DOC_DATE between jc.START_DATE and jc.END_DATE
		  
		  join (select distinct DISTRIBUTOR, doc_no, doc_date, TOWN+LOCALITY+slocality+pop as LE from cashmemo
				where VISIT_TYPE in('01','02') 
				)cm on cd.DISTRIBUTOR = cm.DISTRIBUTOR and cd.DOC_NO = cm.DOC_NO
				  and cd.DOC_DATE = cm.DOC_DATE
	   where jc.JCNO = '01' and jc.YEAR='2016'
),

 
x2 as(
		  select distinct cd.DISTRIBUTOR, sku, jc.jcno, jc.YEAR, cm.LE from cashmemo_detail cd
		  
		  join JC_WEEK jc on cd.DOC_DATE between jc.START_DATE and jc.END_DATE
		  
		  join (select distinct DISTRIBUTOR, doc_no, doc_date, TOWN+LOCALITY+slocality+pop as LE from cashmemo
				where VISIT_TYPE in('01','02') 
				)cm on cd.DISTRIBUTOR = cm.DISTRIBUTOR and cd.DOC_NO = cm.DOC_NO
				  and cd.DOC_DATE = cm.DOC_DATE
	   where jc.JCNO = '02' and jc.YEAR='2016'
),

x3 as(
		  select distinct cd.DISTRIBUTOR, sku, jc.jcno, jc.YEAR, cm.LE from cashmemo_detail cd
		  
		  join JC_WEEK jc on cd.DOC_DATE between jc.START_DATE and jc.END_DATE
		  
		  join (select distinct DISTRIBUTOR, doc_no, doc_date, TOWN+LOCALITY+slocality+pop as LE from cashmemo
				where VISIT_TYPE in('01','02') 
				)cm on cd.DISTRIBUTOR = cm.DISTRIBUTOR and cd.DOC_NO = cm.DOC_NO
				  and cd.DOC_DATE = cm.DOC_DATE
	   where jc.JCNO = '03' and jc.YEAR='2016'
),

x4 as(
		  select distinct cd.DISTRIBUTOR, sku, jc.jcno, jc.YEAR, cm.LE from cashmemo_detail cd
		  
		  join JC_WEEK jc on cd.DOC_DATE between jc.START_DATE and jc.END_DATE
		  
		  join (select distinct DISTRIBUTOR, doc_no, doc_date, TOWN+LOCALITY+slocality+pop as LE from cashmemo
				where VISIT_TYPE in('01','02') 
				)cm on cd.DISTRIBUTOR = cm.DISTRIBUTOR and cd.DOC_NO = cm.DOC_NO
				  and cd.DOC_DATE = cm.DOC_DATE
	   where jc.JCNO = '04' and jc.YEAR='2016'
),

x5 as(
		  select distinct cd.DISTRIBUTOR, sku, jc.jcno, jc.YEAR, cm.LE from cashmemo_detail cd
		  
		  join JC_WEEK jc on cd.DOC_DATE between jc.START_DATE and jc.END_DATE
		  
		  join (select distinct DISTRIBUTOR, doc_no, doc_date, TOWN+LOCALITY+slocality+pop as LE from cashmemo
				where VISIT_TYPE in('01','02') 
				)cm on cd.DISTRIBUTOR = cm.DISTRIBUTOR and cd.DOC_NO = cm.DOC_NO
				  and cd.DOC_DATE = cm.DOC_DATE
	   where jc.JCNO = '05' and jc.YEAR='2016'
),

x6 as(
		  select distinct cd.DISTRIBUTOR, sku, jc.jcno, jc.YEAR, cm.LE from cashmemo_detail cd
		  
		  join JC_WEEK jc on cd.DOC_DATE between jc.START_DATE and jc.END_DATE
		  
		  join (select distinct DISTRIBUTOR, doc_no, doc_date, TOWN+LOCALITY+slocality+pop as LE from cashmemo
				where VISIT_TYPE in('01','02') 
				)cm on cd.DISTRIBUTOR = cm.DISTRIBUTOR and cd.DOC_NO = cm.DOC_NO
				  and cd.DOC_DATE = cm.DOC_DATE
	   where jc.JCNO = '06' and jc.YEAR='2016'
),

x7 as(
		  select distinct cd.DISTRIBUTOR, sku, jc.jcno, jc.YEAR, cm.LE from cashmemo_detail cd
		  
		  join JC_WEEK jc on cd.DOC_DATE between jc.START_DATE and jc.END_DATE
		  
		  join (select distinct DISTRIBUTOR, doc_no, doc_date, TOWN+LOCALITY+slocality+pop as LE from cashmemo
				where VISIT_TYPE in('01','02') 
				)cm on cd.DISTRIBUTOR = cm.DISTRIBUTOR and cd.DOC_NO = cm.DOC_NO
				  and cd.DOC_DATE = cm.DOC_DATE
	   where jc.JCNO = '07' and jc.YEAR='2016'
),

x8 as(
		  select distinct cd.DISTRIBUTOR, sku, jc.jcno, jc.YEAR, cm.LE from cashmemo_detail cd
		  
		  join JC_WEEK jc on cd.DOC_DATE between jc.START_DATE and jc.END_DATE
		  
		  join (select distinct DISTRIBUTOR, doc_no, doc_date, TOWN+LOCALITY+slocality+pop as LE from cashmemo
				where VISIT_TYPE in('01','02') 
				)cm on cd.DISTRIBUTOR = cm.DISTRIBUTOR and cd.DOC_NO = cm.DOC_NO
				  and cd.DOC_DATE = cm.DOC_DATE
	   where jc.JCNO = '08' and jc.YEAR='2016'
),

x9 as(
		  select distinct cd.DISTRIBUTOR, sku, jc.jcno, jc.YEAR, cm.LE from cashmemo_detail cd
		  
		  join JC_WEEK jc on cd.DOC_DATE between jc.START_DATE and jc.END_DATE
		  
		  join (select distinct DISTRIBUTOR, doc_no, doc_date, TOWN+LOCALITY+slocality+pop as LE from cashmemo
				where VISIT_TYPE in('01','02') 
				)cm on cd.DISTRIBUTOR = cm.DISTRIBUTOR and cd.DOC_NO = cm.DOC_NO
				  and cd.DOC_DATE = cm.DOC_DATE
	   where jc.JCNO = '09' and jc.YEAR='2016'
),

xa as(
		  select distinct cd.DISTRIBUTOR, sku, jc.jcno, jc.YEAR, cm.LE from cashmemo_detail cd
		  
		  join JC_WEEK jc on cd.DOC_DATE between jc.START_DATE and jc.END_DATE
		  
		  join (select distinct DISTRIBUTOR, doc_no, doc_date, TOWN+LOCALITY+slocality+pop as LE from cashmemo
				where VISIT_TYPE in('01','02') 
				)cm on cd.DISTRIBUTOR = cm.DISTRIBUTOR and cd.DOC_NO = cm.DOC_NO
				  and cd.DOC_DATE = cm.DOC_DATE
	   where jc.JCNO = '10' and jc.YEAR='2016'
),

xb as(
		  select distinct cd.DISTRIBUTOR, sku, jc.jcno, jc.YEAR, cm.LE from cashmemo_detail cd
		  
		  join JC_WEEK jc on cd.DOC_DATE between jc.START_DATE and jc.END_DATE
		  
		  join (select distinct DISTRIBUTOR, doc_no, doc_date, TOWN+LOCALITY+slocality+pop as LE from cashmemo
				where VISIT_TYPE in('01','02') 
				)cm on cd.DISTRIBUTOR = cm.DISTRIBUTOR and cd.DOC_NO = cm.DOC_NO
				  and cd.DOC_DATE = cm.DOC_DATE
	   where jc.JCNO = '11' and jc.YEAR='2016'
),

xc as(
		  select distinct cd.DISTRIBUTOR, sku, jc.jcno, jc.YEAR, cm.LE from cashmemo_detail cd
		  
		  join JC_WEEK jc on cd.DOC_DATE between jc.START_DATE and jc.END_DATE
		  
		  join (select distinct DISTRIBUTOR, doc_no, doc_date, TOWN+LOCALITY+slocality+pop as LE from cashmemo
				where VISIT_TYPE in('01','02') 
				)cm on cd.DISTRIBUTOR = cm.DISTRIBUTOR and cd.DOC_NO = cm.DOC_NO
				  and cd.DOC_DATE = cm.DOC_DATE
	   where jc.JCNO = '12' and jc.YEAR='2016'
),

y1 as(
      select distinct DISTRIBUTOR, DOC_NO, Net_amount, jc.jcno, jc.YEAR, TOWN+LOCALITY+SLOCALITY+pop as LE from cashmemo cm
	  
	  join JC_WEEK jc on cm.DOC_DATE between jc.START_DATE and jc.END_DATE
	  
	  where  jc.JCNO = '01' and jc.YEAR='2016' and VISIT_TYPE in('01','02') 
	   
),

y2 as(
      select distinct DISTRIBUTOR, DOC_NO, Net_amount, jc.jcno, jc.YEAR, TOWN+LOCALITY+SLOCALITY+pop as LE from cashmemo cm
	  
	  join JC_WEEK jc on cm.DOC_DATE between jc.START_DATE and jc.END_DATE
	  
	  where jc.JCNO = '02' and jc.YEAR='2016' and VISIT_TYPE in('01','02') 
	   
),

y3 as(
      select distinct DISTRIBUTOR, DOC_NO, Net_amount, jc.jcno, jc.YEAR, TOWN+LOCALITY+SLOCALITY+pop as LE from cashmemo cm
	  
	  join JC_WEEK jc on cm.DOC_DATE between jc.START_DATE and jc.END_DATE
	  
	  where jc.JCNO = '03' and jc.YEAR='2016' and VISIT_TYPE in('01','02') 
	   
),

y4 as(
      select distinct DISTRIBUTOR, DOC_NO, Net_amount, jc.jcno, jc.YEAR, TOWN+LOCALITY+SLOCALITY+pop as LE from cashmemo cm
	  
	  join JC_WEEK jc on cm.DOC_DATE between jc.START_DATE and jc.END_DATE
	  
	  where jc.JCNO = '04' and jc.YEAR='2016' and VISIT_TYPE in('01','02') 
	   
),

y5 as(
      select distinct DISTRIBUTOR, DOC_NO, Net_amount, jc.jcno, jc.YEAR, TOWN+LOCALITY+SLOCALITY+pop as LE from cashmemo cm
	  
	  join JC_WEEK jc on cm.DOC_DATE between jc.START_DATE and jc.END_DATE
	  
	  where jc.JCNO = '05' and jc.YEAR='2016' and VISIT_TYPE in('01','02') 
	   
),

y6 as(
      select distinct DISTRIBUTOR, DOC_NO, Net_amount, jc.jcno, jc.YEAR, TOWN+LOCALITY+SLOCALITY+pop as LE from cashmemo cm
	  
	  join JC_WEEK jc on cm.DOC_DATE between jc.START_DATE and jc.END_DATE
	  
	  where  jc.JCNO = '06' and jc.YEAR='2016' and VISIT_TYPE in('01','02') 
	   
),

y7 as(
      select distinct DISTRIBUTOR, DOC_NO, Net_amount, jc.jcno, jc.YEAR, TOWN+LOCALITY+SLOCALITY+pop as LE from cashmemo cm
	  
	  join JC_WEEK jc on cm.DOC_DATE between jc.START_DATE and jc.END_DATE
	  
	  where  jc.JCNO = '07' and jc.YEAR='2016' and VISIT_TYPE in('01','02') 
	   
),

y8 as(
      select distinct DISTRIBUTOR, DOC_NO, Net_amount, jc.jcno, jc.YEAR, TOWN+LOCALITY+SLOCALITY+pop as LE from cashmemo cm
	  
	  join JC_WEEK jc on cm.DOC_DATE between jc.START_DATE and jc.END_DATE
	  
	  where  jc.JCNO = '08' and jc.YEAR='2016' and VISIT_TYPE in('01','02') 
	   
),

y9 as(
      select distinct DISTRIBUTOR, DOC_NO, Net_amount, jc.jcno, jc.YEAR, TOWN+LOCALITY+SLOCALITY+pop as LE from cashmemo cm
	  
	  join JC_WEEK jc on cm.DOC_DATE between jc.START_DATE and jc.END_DATE
	  
	  where jc.JCNO = '09' and jc.YEAR='2016' and VISIT_TYPE in('01','02') 
	   
),

ya as(
      select distinct DISTRIBUTOR, DOC_NO, Net_amount, jc.jcno, jc.YEAR, TOWN+LOCALITY+SLOCALITY+pop as LE from cashmemo cm
	  
	  join JC_WEEK jc on cm.DOC_DATE between jc.START_DATE and jc.END_DATE
	  
	  where  jc.JCNO = '10' and jc.YEAR='2016' and VISIT_TYPE in('01','02') 
	   
),

yb as(
      select distinct DISTRIBUTOR, DOC_NO, Net_amount, jc.jcno, jc.YEAR, TOWN+LOCALITY+SLOCALITY+pop as LE from cashmemo cm
	  
	  join JC_WEEK jc on cm.DOC_DATE between jc.START_DATE and jc.END_DATE
	  
	  where  jc.JCNO = '11' and jc.YEAR='2016' and VISIT_TYPE in('01','02') 
	   
),

yc as(
      select distinct DISTRIBUTOR, DOC_NO, Net_amount, jc.jcno, jc.YEAR, TOWN+LOCALITY+SLOCALITY+pop as LE from cashmemo cm
	  
	  join JC_WEEK jc on cm.DOC_DATE between jc.START_DATE and jc.END_DATE
	  
	  where  jc.JCNO = '12' and jc.YEAR='2016' and VISIT_TYPE in('01','02') 
	   
) 


select distinct complvl2 as Region, complvl3 as Area, ma.DISTRIBUTOR, cust_type as [Distributor Type] , 
ma.LE as [Outlet Code], eledesc as [Channel Level4], tow as [Town], st as [Outlet Address], 
a1.CN as SKJan, a2.CN as SKFEB, a3.CN AS SKMAR, a4.CN AS SKAP, a5.CN AS SKMAY, a6.CN AS SKJUN, 
a7.CN AS SKJUL, a8.CN AS SKAUG, a9.CN AS SKSEP, aa.CN AS SKOCT, ab.CN AS SKNOV, ac.CN AS SKDEC,
b1.GSS as Jan, b2.GSS as Feb, b3.GSS as Mar, b4.GSS as Ap, b5.GSS as may, b6.GSS as jun, b7.GSS as jul, 
b8.GSS as aug, b9.GSS as sep, b10.GSS as oct, b11.GSS as nov, b12.GSS as dece  from z ma

left join (select distinct Distributor, LE, COUNT(sku) as CN from x1
           group by Distributor, LE ) a1 on ma.DISTRIBUTOR = a1.distributor  and ma.LE = a1.LE
left join (select distinct Distributor, LE, COUNT(sku) as CN from x2
           group by Distributor, LE ) a2 on ma.DISTRIBUTOR = a2.distributor  and ma.LE = a2.LE
left join (select distinct Distributor, LE, COUNT(sku) as CN from x3
           group by Distributor, LE ) a3 on ma.DISTRIBUTOR = a3.distributor  and ma.LE = a3.LE
left join (select distinct Distributor, LE, COUNT(sku) as CN from x4
           group by Distributor, LE ) a4 on ma.DISTRIBUTOR = a4.distributor  and ma.LE = a4.LE
left join (select distinct Distributor, LE, COUNT(sku) as CN from x5
           group by Distributor, LE ) a5 on ma.DISTRIBUTOR = a5.distributor  and ma.LE = a5.LE
left join (select distinct Distributor, LE, COUNT(sku) as CN from x6
           group by Distributor, LE ) a6 on ma.DISTRIBUTOR = a6.distributor  and ma.LE = a6.LE
left join (select distinct Distributor, LE, COUNT(sku) as CN from x7
           group by Distributor, LE ) a7 on ma.DISTRIBUTOR = a7.distributor  and ma.LE = a7.LE
left join (select distinct Distributor, LE, COUNT(sku) as CN from x8
           group by Distributor, LE ) a8 on ma.DISTRIBUTOR = a8.distributor  and ma.LE = a8.LE
left join (select distinct Distributor, LE, COUNT(sku) as CN from x9
           group by Distributor, LE ) a9 on ma.DISTRIBUTOR = a9.distributor  and ma.LE = a9.LE
left join (select distinct Distributor, LE, COUNT(sku) as CN from xa
           group by Distributor, LE ) aa on ma.DISTRIBUTOR = aa.distributor  and ma.LE = aa.LE
left join (select distinct Distributor, LE, COUNT(sku) as CN from xb
           group by Distributor, LE ) ab on ma.DISTRIBUTOR = ab.distributor  and ma.LE = ab.LE
left join (select distinct Distributor, LE, COUNT(sku) as CN from xc
           group by Distributor, LE ) ac on ma.DISTRIBUTOR = ac.distributor  and ma.LE = ac.LE
left join (select distinct Distributor, LE, SUM(NET_AMOUNT/1.1) as GSS from y1
           group by Distributor, LE ) b1 on ma.DISTRIBUTOR = b1.DISTRIBUTOR and ma.LE = b1.LE
left join (select distinct Distributor, LE, SUM(NET_AMOUNT/1.1) as GSS from y2
           group by Distributor, LE ) b2 on ma.DISTRIBUTOR = b2.DISTRIBUTOR and ma.LE = b2.LE
left join (select distinct Distributor, LE, SUM(NET_AMOUNT/1.1) as GSS from y3
           group by Distributor, LE ) b3 on ma.DISTRIBUTOR = b3.DISTRIBUTOR and ma.LE = b3.LE
left join (select distinct Distributor, LE, SUM(NET_AMOUNT/1.1) as GSS from y4
           group by Distributor, LE ) b4 on ma.DISTRIBUTOR = b4.DISTRIBUTOR and ma.LE = b4.LE
left join (select distinct Distributor, LE, SUM(NET_AMOUNT/1.1) as GSS from y5
           group by Distributor, LE ) b5 on ma.DISTRIBUTOR = b5.DISTRIBUTOR and ma.LE = b5.LE
left join (select distinct Distributor, LE, SUM(NET_AMOUNT/1.1) as GSS from y6
           group by Distributor, LE ) b6 on ma.DISTRIBUTOR = b6.DISTRIBUTOR and ma.LE = b6.LE
left join (select distinct Distributor, LE, SUM(NET_AMOUNT/1.1) as GSS from y7
           group by Distributor, LE ) b7 on ma.DISTRIBUTOR = b7.DISTRIBUTOR and ma.LE = b7.LE
left join (select distinct Distributor, LE, SUM(NET_AMOUNT/1.1) as GSS from y8
           group by Distributor, LE ) b8 on ma.DISTRIBUTOR = b8.DISTRIBUTOR and ma.LE = b8.LE
left join (select distinct Distributor, LE, SUM(NET_AMOUNT/1.1) as GSS from y9
           group by Distributor, LE ) b9 on ma.DISTRIBUTOR = b9.DISTRIBUTOR and ma.LE = b9.LE
left join (select distinct Distributor, LE, SUM(NET_AMOUNT/1.1) as GSS from ya
           group by Distributor, LE ) b10 on ma.DISTRIBUTOR = b10.DISTRIBUTOR and ma.LE = b10.LE
left join (select distinct Distributor, LE, SUM(NET_AMOUNT/1.1) as GSS from yb
           group by Distributor, LE ) b11 on ma.DISTRIBUTOR = b11.DISTRIBUTOR and ma.LE = b11.LE
left join (select distinct Distributor, LE, SUM(NET_AMOUNT/1.1) as GSS from yc
           group by Distributor, LE ) b12 on ma.DISTRIBUTOR = b12.DISTRIBUTOR and ma.LE = b12.LE

where ma.DISTRIBUTOR in (
'15249837',
'15250140',
'15250153',
'15250189',
'15250334',
'15251428',
'15251430',
'15251536',
'15252343',
'15253826',
'15254667',
'15255686',
'15256190',
'15256594',
'15256622',
'15256718',
'15256784',
'15257529',
'15258079',
'15258645',
'15258646',
'15259663',
'15259702',
'15260125',
'15260260',
'15260499',
'15260849',
'15260860',
'15261006',
'15261011',
'15261113',
'15261120',
'15261370',
'15261414',
'15261421',
'15261518',
'15261547',
'15261555',
'15261556',
'15261567',
'15261628',
'15261648',
'15263295',
'15266545',
'15266690',
'15266921',
'15266931',
'15268038',
'15268187',
'15270721',
'15270779',
'15271602',
'15271607',
'15271608',
'15272585',
'15272641',
'15275989',
'15277851',
'15278468',
'15279033',
'15279375',
'15279835',
'15280259',
'15280837',
'15280990',
'15281408',
'15281629',
'15281632',
'15281670',
'15281874',
'15286697',
'15287281',
'15298186',
'15299978',
'15299979',
'15299980',
'15300064',
'15300065',
'15300300',
'15301046',
'15301915',
'15302627',
'15303301',
'15305006',
'15305483',
'15305497',
'15305871',
'15305873',
'15307420',
'15308523',
'15308561',
'15308809',
'15308933',
'15309146',
'15309225',
'15309234',
'15310522',
'15310523',
'15315318',
'15315705',
'15315813',
'15315814',
'15315824',
'91007001',
'91009001',
'91017001',
'91020001',
'91025001',
'91029001',
'91031001',
'91035001',
'91083001',
'91085001',
'91086001',
'91087001',
'91089001',
'91090001',
'91097001',
'91204001',
'91205001',
'91211001',
'91289001',
'91291001',
'91292001',
'91294001',
'91402001',
'91403001',
'91404001',
'91406001',
'91407001',
'91409001',
'91411001',
'91412001',
'91413001',
'91414001',
'91415001',
'91416001',
'91418001',
'91421001',
'91451001',
'91604001',
'91608001',
'91611001',
'91614001',
'91619001',
'91627001',
'91629001',
'91652001',
'91653001',
'91695001',
'91801001',
'91845001',
'91883001',
'91890001',
'91894001',
'91895001',
'91898001',
'91899001',
'92002001',
'92005001',
'92011001',
'92012001',
'92013001',
'92014001',
'92014002',
'92088001',
'92090001',
'92213001',
'92214001',
'92215001',
'92219001',
'92220001',
'92221001',
'92404001',
'92404102',
'92407001',
'92408001',
'92409001',
'92410001',
'92412001',
'92431001',
'92432001',
'92604001',
'92605001',
'92606001',
'92610001',
'92614001',
'92617001',
'92618001',
'92621001',
'92623001',
'92670001',
'92695001',
'92698001',
'92801001',
'92802001',
'92803001',
'92816001',
'92894001',
'93002001',
'93004001',
'93009001',
'93010001',
'93011001',
'93012001',
'93026001',
'93047001',
'93310001',
'93323001',
'93503001',
'93504001',
'93511001',
'93517001',
'93518001',
'93519001',
'93528001',
'93801001',
'93808001',
'93809001',
'94001101',
'94002101',
'94005101',
'94008001',
'94016001',
'94025001',
'94027001',
'94030001',
'94032001',
'94092001',
'94207001',
'94210001',
'94212001',
'94222001',
'94228001',
'94282001',
'94295001',
'94296001',
'94402001',
'94403001',
'94404001',
'94407001',
'94409001',
'94415001',
'94418001'
)
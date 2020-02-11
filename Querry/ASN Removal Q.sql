declare @dateto datetime, @datafrom datetime;
set @datafrom ='20170327';
set @dateto='20170410';

select dt.DISTRIBUTOR, dt.Name as [Distributor Name] ,comp.comp3_desc Area ,
tdt.value_comb Distributor_Type,ra.CN as [Total Removal], td.SKU, td.SK, td.SKUCN  

from DISTRIBUTOR dt

join (select distinct r.DISTRIBUTOR, COUNT(r.Doc_no) as CN from RA_HEAD r
      
      join (select distinct distributor, doc_no, sub_document from TRANS_DETAIL
            where document='ra' and (DOC_DATE between @datafrom and @dateto)
            ) t on r.DISTRIBUTOR = t.distributor and r.DOC_NO = t.doc_no and r.SUB_DOCUMENT = t.sub_document
      
      where (COMMENTS  like '%Rem%'or COMMENTS  like'%RMV%')
      
      group by r.DISTRIBUTOR
)ra on dt.DISTRIBUTOR = ra.DISTRIBUTOR

join (select distinct t.DISTRIBUTOR, t.SKU, s.LDESC as SK, COUNT(t.SKU) as SKUCN from TRANS_DETAIL t
      
      join sku s on t.sku = s.SKU
      
      join (select distinct distributor, doc_no, doc_date, SUB_DOCUMENT from ra_head
            where 
            (comments  like '%REM%' or comments  like'%RMv%')
        ) r on t.distributor = r.DISTRIBUTOR and t.DOC_NO = r.DOC_NO and t.SUB_DOCUMENT = r.SUB_DOCUMENT
      
      where t.DOCUMENT='RA' and t.DOC_DATE between @datafrom and @dateto
      
      group by t.DISTRIBUTOR, t.sku, s.LDESC
 )td on dt.DISTRIBUTOR=td.DISTRIBUTOR
join (
	select da.distributor,
	case 
	when value_comb = '0.2' then 'GT'
	when value_comb = '0.3' then 'MT'
	end
	value_comb from distributor_association da
	where da.field_comb = 'da_fixed_discount')
	 tdt on tdt.distributor = dt.distributor
join (
	select da.distributor,clv.COMP3_DESC from distributor_association da
	join ( 
		select distinct DISTRIBUTOR, COUNT (DISTRIBUTOR) AS CNT from DISTRIBUTOR_ASSOCIATION
		where FIELD_COMB = 'compcode'
		group by DISTRIBUTOR
		) dbl on da.seq_no = dbl.CNT and dbl.DISTRIBUTOR = da.DISTRIBUTOR
	join vw_complevel clv on clv.compcode = da.value_comb
	where da.field_comb = 'COMPCODE' ) 
comp on comp.distributor = dt.distributor

go


select  * from TRANS_DETAIL t
      
      join sku s on t.sku = s.SKU
      
      join (select distinct distributor, doc_no, doc_date, SUB_DOCUMENT from ra_head
            where (comments like '%REM%' or comments like'%RMv%')
        ) r on t.distributor = r.DISTRIBUTOR and t.DOC_NO = r.DOC_NO and t.SUB_DOCUMENT = r.SUB_DOCUMENT
      
      where t.DOCUMENT='RA' and t.DOC_DATE between '20170313' and '20170320' and t.DISTRIBUTOR ='15094890' and t.sku='21011521'
      
      
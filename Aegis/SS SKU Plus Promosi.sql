---Report Secondary sales + Promosi
select dlv.COMP2_DESC REGION,dlv.COMP3_DESC AREA,cm.DISTRIBUTOR,dt.NAME as 'DISTRIBUTOR NAME',PJP as'PJP ID',
DSR as 'DSR ID',cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP as 'Outlet ID',replace(p.name,char(9),'') as 'Outlet Name',
cm.CASHMEMO_TYPE, cm.DOC_NO as 'DOC NO SALES',d.LDESC as'Document',ct.LDESC as 'Cashmemo Type', cm.COMMENTS,
convert(varchar,cm.DOC_date,105) as 'DOC DATE',
convert(varchar,cm.DELV_DATE,105) as 'DELV DATE', cd.SKU,((cd.QTY1*s.SELL_FACTOR1)+ (cd.QTY2*s.SELL_FACTOR2)+cd.QTY3) as 'SERVICE ORDER (Pcs)'
,cd.AMOUNT as 'SERVICE VALUE',sd.[OPSO ID],sd.[Kode Promosi],sd.[Keterangan Promosi],sd.[Value Discount]
from cashmemo cm
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
	) dlv on cm.distributor = dlv.distributor
	left join DISTRIBUTOR dt on dt.DISTRIBUTOR =cm.DISTRIBUTOR
join  CASHMEMO_DETAIL  cd on cd.DOC_NO = cm.DOC_NO and cd.DISTRIBUTOR = cm.DISTRIBUTOR
left join pop p on p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = cm.DISTRIBUTOR+cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP
left join SKU s on s.SKU = cd.SKU
left join (select  ps.pbs_scheme_id as 'OPSO ID',ps.pbs_scheme_id2 as 'Kode Promosi',
ps.pbs_desc as 'Keterangan Promosi',sd.DISTRIBUTOR,sd.DOCUMENT,sd.SUB_DOCUMENT,sd.DOC_NO,sd.DOC_DATE,sdd.SKU,SDD.DISCOUNT as 'Value Discount'
 from SCHEME_DISCOUNT SD
left JOIN 	dbo.SCHEME_DISCOUNT_DETAIL AS SDD ON SD.COMPANY = SDD.COMPANY AND SD.DISTRIBUTOR = SDD.DISTRIBUTOR AND
 SD.[DOCUMENT] = SDD.[DOCUMENT] AND 
 SD.SUB_DOCUMENT = SDD.SUB_DOCUMENT AND 
 SD.DOC_NO = SDD.DOC_NO AND SD.Mp_Code = SDD.Mp_Code AND SD.Seq_Id = SDD.Seq_Id 
 left join pb_setup ps on ps.pbs_mp_code = sd.Mp_Code and sd.Seq_Id =ps.pbs_seqid) sd on sd.DISTRIBUTOR=cm.DISTRIBUTOR and
 sd.DOC_NO = cm.DOC_NO and sd.DOCUMENT = cm.DOCUMENT and sd.SUB_DOCUMENT = cm.SUB_DOCUMENT and sd.sku = cd.sku
 left join DOCUMENT d on d.DOCUMENT = cm.DOCUMENT and d.SUB_DOCUMENT = cm.SUB_DOCUMENT
 left join CASHMEMO_TYPE ct on ct.CASHMEMO_TYPE = cm.CASHMEMO_TYPE
where cm.VISIT_TYPE = '02' and
cm.DOC_DATE between '20190401' and '20190531' 
and cm.distributor in (
'15061608')
and cd.SKU in ('67069765',
'62072024','67543240','67103389','67103391',
'67465881','67438433','67719165','67477380',
'21075851','67272001','67502391')
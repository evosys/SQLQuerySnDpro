
select dlv.COMP2_DESC Region, dlv.COMP3_DESC Area,
	p.distributor, d.NAME, p.distributor+p.town+p.locality+p.slocality+p.pop as 'SND outlet Code', p.town+p.locality+p.slocality+p.pop popcode , replace(p.name,char(9),'') outlet_name ,
	case 
when p.active = 1 then 'Active'
when p.active = 0 then 'InActive'
end Store_ActiveClosed, elm.LDESC Outlet_element , elm.Desc_se Outlet_SubElement, p.LATITUDE, p.LONGITUDE,
	--[201841],[201842],[201843],[201844], [201845], [201846], [201847], [201848], [201849], [201850], [201851], [201852], [201901],[201902], [201903], [201904], [201905], [201906], [201907], [201908], [201909], [201910], [201911], [201912], [201913], [201914],[201915], [201916], [201917], [201918],[201919],[201920],[201921],[201922],[201923],[201924],[201925],[201926],[201927],[201928],[201929],[201930],[201931],
	[201932], [201933],
	[201934], [201935], [201936], [201937], [201938], [201939], [201940], [201941], [201942], [201943], [201944], [201945], [201946], [201947], [201948], [201949], [201950], [201951], [201952],
	[202001], [202002], [202003], [202004], [202005], [202006],[202007]
from pop p
	left join distributor d on d.DISTRIBUTOR = p.DISTRIBUTOR
	join (select se.SUB_ELEMENT, se.LDESC Desc_se , e.ELEMENT, e.LDESC
	from SUB_ELEMENT se
		join ELEMENT e on e.ELEMENT = se.ELEMENT and e.CHANNEL =se.CHANNEL and e.SUB_CHANNEL = se.SUB_CHANNEL and e.MASTER_CHANNEL =se.MASTER_CHANNEL
	) elm on elm.SUB_ELEMENT = p.SUB_ELEMENT
	left join (
		select da.DISTRIBUTOR, da.VALUE_COMB, clvl.comp2_desc , clvl.comp3_desc
	from DISTRIBUTOR_ASSOCIATION da
		join
		vw_complevel clvl on da.VALUE_COMB= clvl.COMPCODE
		join
		( 
			select distinct DISTRIBUTOR, COUNT (DISTRIBUTOR) AS CNT
		from DISTRIBUTOR_ASSOCIATION
		where FIELD_COMB = 'compcode'
		group by DISTRIBUTOR
		) dbl on da.SEQ_NO= dbl.CNT and dbl.DISTRIBUTOR =da.DISTRIBUTOR
	) dlv on p.distributor = dlv.distributor


	--- fcm
	left join (
select distinct distributor, codele,
		--[201841],[201842],[201843],[201844], [201845], [201846], [201847], [201848], [201849], [201850], [201851], [201852], [201901],[201902], [201903], [201904], [201905], [201906], [201907], [201908], [201909], [201910], [201911], [201912], [201913], [201914],[201915], [201916], [201917], [201918],[201919],[201920],[201921],[201922],[201923],[201924],[201925],[201926],[201927],[201928],[201929],[201930],[201931],
		[201932], [201933],
		[201934], [201935], [201936], [201937], [201938], [201939], [201940], [201941], [201942], [201943], [201944], [201945], [201946], [201947], [201948], [201949], [201950], [201951], [201952],
		[202001], [202002], [202003], [202004], [202005], [202006], [202007]
	from
		(
select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele, jw.YEAR+jw.WEEK_NO yeweek,
			SUM(((cm.net_amount/1.1)-cm.tot_discount)) GSV
		from cashmemo cm
			left join jc_week jw on cm.doc_date between jw.start_date and jw.end_date
		where cm.VISIT_TYPE = '02'
			and SUB_DOCUMENT not in ('02','04')
			and jw.YEAR+jw.WEEK_NO in (
--'201841','201842','201843','201844', '201845', '201846', '201847', '201848', '201849', '201850', '201851', '201852', '201901','201902', '201903', '201904', '201905', '201906', '201907', '201908', '201909', '201910', '201911', '201912', '201913', '201914','201915', '201916', '201917', '201918','201919','201920','201921','201922','201923','201924','201925','201926','201927','201928','201929','201930','201931',
'201932','201933',
'201934','201935','201936','201937','201938','201939','201940','201941','201942','201943','201944','201945','201946','201947','201948','201949','201950','201951','201952',
'202001','202002','202003','202004','202005','202006','202007')
		group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop ,jw.YEAR+jw.WEEK_NO
) x
pivot
    (
      sum(GSV) for yeweek in (
--[201841],[201842],[201843],[201844], [201845], [201846], [201847], [201848], [201849], [201850], [201851], [201852], [201901],[201902], [201903], [201904], [201905], [201906], [201907], [201908], [201909], [201910], [201911], [201912], [201913], [201914],[201915], [201916], [201917], [201918],[201919],[201920],[201921],[201922],[201923],[201924],[201925],[201926],[201927],[201928],[201929],[201930],[201931],
[201932],[201933],
[201934],[201935],[201936],[201937],[201938],[201939],[201940],[201941],[201942],[201943],[201944],[201945],[201946],[201947],[201948],[201949],[201950],[201951],[201952],
[202001],[202002],[202003],[202004],[202005], [202006],[202007]
)
    ) as PVT
)fcm on fcm.distributor = p.distributor and p.town+p.locality+p.slocality+p.pop = fcm.codele
--end fcm

where p.ACTIVE = '1' and ISNUMERIC(p.distributor) = '1'
	and p.DISTRIBUTOR not in ('15440642','15440643','15441941','15446779','15451130','15451701')
	

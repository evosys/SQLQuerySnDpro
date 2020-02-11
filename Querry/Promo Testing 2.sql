select pbs_scheme_id2, pbs_desc, fb.ldesc, CONVERT(varchar,pbs_period_fr,105) as fr, CONVERT(varchar,pbs_period_to,105) as pto,
CONVERT(varchar,DATE_ENTRY,105) as entryd, pbs_expire,fb.expire, fb.sku, fb.brand_product, fb.amount_fr,
fb.amount_to, fb.discount_qty, fb.discount_val, fb.divided_unit, fb.purchase_limit from pb_setup ps 

join(
		select distinct fc.mp_code, fc.seq_id, fc.serial_no, field_comb, brand_product, quantity_fr, 
		quantity_to, amount_fr, amount_to, discount_qty, discount_val, divided_unit, purchase_limit, valid,LDESC, 
		convert(varchar,DATE_ENTRY,105) as DateEntry, sv.sku, sv.[STATUS], expire from FIELD_COMB fc
		
		join (select distinct (cast(mp_code as varchar)+cast(seq_id as varchar)+cast(serial_no as varchar)) as newcode,
		      company, sku, [status] from scheme_variant
		      ) sv on cast(fc.mp_code as varchar)+cast(fc.seq_id as varchar)+cast(fc.serial_no as varchar) = sv.newcode
		
		where fc.mp_code+fc.seq_id in (select distinct pbs_mp_code+pbs_seqid from pb_setup 
		where left(pbs_scheme_id2,2) in ('BA' ,'LI','SE')) 
		

)fb on ps.pbs_mp_code = fb.mp_code and ps.pbs_seqid = fb.seq_id and convert(varchar,ps.DATE_ENTRY,105)= fb.DateEntry




where left(pbs_scheme_id2,2) in ('BA' ,'LI','SE')



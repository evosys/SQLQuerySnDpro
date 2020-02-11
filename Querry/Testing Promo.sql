select * from pb_setup where left(pbs_scheme_id2,2) in ('BA' ,'LI','SE')

select * from FIELD_COMB where mp_code+seq_id in (select distinct pbs_mp_code+pbs_seqid from pb_setup 
where left(pbs_scheme_id2,2) in ('BA' ,'LI','SE'))

select mv.Company, mv.main_process, mv.seq_id,variable_name, variable_type, variable_value,
USER_ENTRY, mvd.TableName, mvd.ColumnName, mvd.Operator, mvd.Value, mvd.Ref_Table from memory_variable mv

join memory_variable_Detail mvd on mvd.MAIN_PROCESS+mvd.SEQ_ID =mv.main_process+mv.seq_id 

where mv.main_process+mv.seq_id in (select distinct pbs_mp_code+pbs_seqid from pb_setup 
where left(pbs_scheme_id2,2) in ('BA' ,'LI','SE'))

go
select * from memory_variable
select * from memory_variable_Detail
SELECT * FROM scheme_variant
SELECT * FROM DISCOUNT_TYPE
SELECT * FROM SCHEME_ALLOCATION_ONSALE
SELECT * FROM SCHEME_LIMITS
select * from SCHEME_TYPE
go

select * from pb_setup ps 

join discount_type dp on ps.DISCOUNT_TYPE = dp.DISCOUNT_TYPE


join (select distinct COMPANY, mp_code,seq_id, serial, condition, QUANTITY_FR, QUANTITY_TO 
      group_operand from scheme_limits) sl

join(
	select mv.Company, mv.main_process, mv.seq_id,variable_name, variable_type, variable_value,
	USER_ENTRY, mvd.TableName, mvd.ColumnName, mvd.Operator, mvd.Value, mvd.Ref_Table, 
	convert(varchar,mv.DATE_ENTRY,105) from memory_variable mv

	join memory_variable_Detail mvd on mvd.MAIN_PROCESS+mvd.SEQ_ID =mv.main_process+mv.seq_id 

	where mv.main_process+mv.seq_id in (select distinct pbs_mp_code+pbs_seqid from pb_setup 
	where left(pbs_scheme_id2,2) in ('BA' ,'LI','SE')) and mv.main_process+mv.seq_id='00111'
)mv

join(
		select distinct fc.mp_code,fc.seq_id,fc.serial_no, field_comb, brand_product, quantity_fr, 
		quantity_to, amount_fr, amount_to, discount_qty, discount_val, divided_unit, purchase_limit, valid,LDESC, 
		convert(varchar,DATE_ENTRY,105) as DateEntry, sv.sku, sv.status from FIELD_COMB fc
		
		join (select distinct (cast(mp_code as varchar)+cast(seq_id as varchar)+cast(serial_no as varchar)) as newcode,
		      company, sku, [status] from scheme_variant
		      ) sv on cast(fc.mp_code as varchar)+cast(fc.seq_id as varchar)+cast(fc.serial_no as varchar) = sv.newcode
		
		where fc.mp_code+fc.seq_id in (select distinct pbs_mp_code+pbs_seqid from pb_setup 
		where left(pbs_scheme_id2,2) in ('BA' ,'LI','SE')) 
		

)fb



where left(pbs_scheme_id2,2) in ('BA' ,'LI','SE')



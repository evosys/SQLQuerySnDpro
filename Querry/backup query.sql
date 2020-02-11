select * from distributor

backup database Centegy_SnDPro_UID
to disk = 'D:\OSDP\Backup\Database\BK_OSDP_15089473_BeforeKnockOff_24032018_2124.bak'
go

backup database Centegy_SnDPro_UID
to disk = 'D:\OSDP\Backup\Database\BK_OSDP_15089473_BeforeGolive_2403018_2141.bak'
go


begin transaction
--update
select * from payment_head where status = 'f'
commit

select * from payment_head ph
where ph.COMPANY = '06' and ph.DISTRIBUTOR = '15222365' 
and ph.DOC_NO like '%3018112546%'

582339864

select * from payment_head ph
where ph.COMPANY = '03' and ph.DISTRIBUTOR = '15222365' 
and ph.DOC_NO in ('3018112546',
'3018112557',
'3018112560',
'3018112561',
'3018203364',
'3018203365',
'3018203366',
'3018203367',
'3018203368',
'3018203379',
'3018203380',
'3018203382',
'3018203383',
'3018155412',
'3018155416',
'3018155418',
'3018155420',
'3018155421',
'3018237594',
'3018237595',
'3018237596',
'3018237597',
'3018237598',
'3018237599',
'3018237600',
'3018237601',
'3018237602',
'3018237603',
'3018237604',
'3018237605',
'3018248470',
'3018248471',
'3018248472',
'3018248474'
) 
and not(isnull(PH.TOTAL_ADJUSTED_AMOUNT,0)  = isnull(PH.NET_AMOUNT,0));

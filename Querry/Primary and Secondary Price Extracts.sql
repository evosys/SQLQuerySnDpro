select distinct distributor as [CustomerCode], ps.sku as [ProductCode], 
convert(varchar(8),effective_date,112) as [ValidFrom], 
convert(varchar(8),effective_todate,112) as [ValidTo],'CS' as [UOM], 
round(Price_Unit3*sk.sell_factor1,0 ) as [TradePrice] from PRICE_STRUCTURE ps
join (select distinct sku, sell_factor1 from sku) sk
 on ps.sku = sk.sku
where ps.distributor in(
select distinct distributor from HPC_Golive6March17.dbo.distributor)
go
select distinct distributor as [CustomerCode], ps.sku as [ProductCode], 
convert(varchar(8),effective_date,112) as [ValidFrom], 
convert(varchar(8),effective_todate,112) as [ValidTo],'CS' as [UOM], 
round(PRICE_PURCHASE3*sk.sell_factor1,0) as [ListPrice] 
from PRICE_STRUCTURE ps
join (select distinct sku, sell_factor1 from sku) sk
 on ps.sku = sk.sku
where ps.distributor in (
select distinct distributor from HPC_Golive6March17.dbo.distributor) 
go


---AMAZON SALE REPORT---
select * from [Amazon Sale Report]
order by [index]


--Check For Duplicate And Remove Them--

with cte_duplicate as(
select [index],[Order ID],Date,Status,Fulfilment,[Sales Channel ],
[ship-service-level],Style,Category,Size,SKU,
ASIN,Qty,Amount,[ship-city],[ship-state],
ROW_NUMBER() over( partition by [Order ID],date,status,fulfilment,[sales channel],[ship-service-level]
,category,size order by [Order ID]) as RowNum
from [Amazon Sale Report]
)
select * from cte_duplicate
where RowNum>1
order by rownum

with cte_duplicate as(
select [index],[Order ID],Date,Status,Fulfilment,[Sales Channel ],
[ship-service-level],Style,Category,Size,SKU,
ASIN,Qty,Amount,[ship-city],[ship-state],
ROW_NUMBER() over( partition by [Order ID],date,status,fulfilment,[sales channel],[ship-service-level]
,category,size order by [Order ID]) as RowNum
from [Amazon Sale Report]
)
delete from cte_duplicate
where RowNum>1


--Delete Unused Columns And Alter Date--

alter table [Amazon Sale Report]
drop column [Courier Status],currency,[ship-postal-code],[promotion-ids],[fulfilled-by],[Unnamed: 22]

alter table [Amazon Sale Report]
alter column Date date


--Replace Some Values In Different Columns--

Update [Amazon Sale Report]
set Status=
CASE
when Status = 'Cancelled' then 'Cancelled'
when Status IN ('Pending','Pending - Waiting for Pick Up') then 'Pending'
when Status IN ('Shipped - Out for Delivery','Shipped','Shipped - Delivered to Buyer','Shipped - Picked Up','Shipping') 
then 'Shipped - Delivered/On the Way'
when Status IN ('Shipped - Damaged','Shipped - Lost in Transit','Shipped - Rejected by Buyer','Shipped - Returned to Seller','Shipped - Returning to Seller') 
then 'Shipped - Issue'
ELSE Status
END;


Update [Amazon Sale Report]
set Category=
CASE
when Category ='kurta' then 'Kurta'
when Category in ('Ethnic Dress','Western Dress') then 'Dress'
else Category
END;


alter table  [Amazon Sale Report]
alter column B2B char(10)

Update [Amazon Sale Report]
set B2B=
CASE
when B2B=0 then 'NO'
when B2B=1 then 'YES'
else B2B
END;


--Updates Qty And Amount Column And Edit Null Values--

Update [Amazon Sale Report]
set Amount = 0
where Amount is null 



select Qty,avg(Amount) as "Average Amount For Qty1"
from [Amazon Sale Report]
where Qty=1 and Amount>0
group by Qty

Update [Amazon Sale Report]
set Amount =
(select avg(Amount)
from [Amazon Sale Report]
where Qty=1 and Amount>0
)
where Qty=1 and Amount=0;



select Qty,avg(Amount) as "Average Amount For Qty2"
from [Amazon Sale Report]
where Qty=2 and Amount>0
group by Qty

Update [Amazon Sale Report]
set Amount =
(select avg(Amount)
from [Amazon Sale Report]
where Qty=2 and Amount>0
)
where Qty=2 and Amount=0;


select Qty,avg(Amount) as "Average Amount For Qty3"
from [Amazon Sale Report]
where Qty=3 and Amount>0
group by Qty

Update [Amazon Sale Report]
set Amount =
(select avg(Amount)
from [Amazon Sale Report]
where Qty=3 and Amount>0
)
where Qty=3 and Amount=0;




select Qty,avg(Amount) as "Average Amount For Qty4"
from [Amazon Sale Report]
where Qty=4 and Amount>0
group by Qty


Update [Amazon Sale Report]
set Amount =
(select avg(Amount)
from [Amazon Sale Report]
where Qty=4 and Amount>0
)
where Qty=4 and Amount=0;

select AVG(Amount) as "Average Amount"
from [Amazon Sale Report]
where Amount>0

Update [Amazon Sale Report]
set Amount =
(select avg(Amount)
from [Amazon Sale Report]
where Amount>0
)
where Amount=0 and Qty<>0;


--Updates City,State And Country And Process Null Values--


Update [Amazon Sale Report]
SET [ship-city]=(
    select top 1 [ship-city]
    from [Amazon Sale Report]
	where[ship-city] is not null
	order by NEWID()
)
where [ship-city] is null;

Update [Amazon Sale Report]
SET [ship-state]=(
    select top 1 [ship-state]
    from [Amazon Sale Report]
	where[ship-state] is not null
	order by NEWID()
)
where [ship-state] is null;

Update [Amazon Sale Report]
set [ship-country]='India'
where [ship-country] is null

-----------------------------------------------------------------------------------------------------------------------------
---SALE REPORT---
select * from [Sale Report]

select a.SKU,s.[SKU Code],a.Style,s.[Design No#],a.Category,s.Category,a.Size,s.Size
from [Amazon Sale Report]a join [Sale Report]s
on a.SKU=s.[SKU Code]
--where a.Category <> s.Category
--where a.Size <> s.Size
order by a.Category


--Replace Some Values In Different Columns--

/*CATEGORY*/
Update [Sale Report]
set Category=
CASE
when Category ='BLOUSE' then 'Blouse'
when Category in('PALAZZO','AN : LEGGINGS', 'PANT','SKIRT','JUMPSUIT','SHARARA','BOTTOM','SKIRT') then 'Bottom'
when Category = 'DRESS' then 'Dress'
when Category in('KURTA','KURTI') then 'Kurta'
when Category ='SAREE' then 'Saree'
when Category in('SET','KURTA SET','NIGHT WEAR','CROP TOP WITH PLAZZO','LEHENGA CHOLI') then 'Set'
when Category in('TUNIC','TOP','CROP TOP','CARDIGAN') then 'Top'
else Category
END;

select  a.Category,s.Category,a.Size,s.Size
from [Amazon Sale Report]a join [Sale Report]s
on a.SKU=s.[SKU Code] and a.Category <> s.Category
and s.Category='Kurta'
order by a.Category

select  a.Category,s.Category,a.Size,s.Size
from [Amazon Sale Report]a join [Sale Report]s
on a.SKU=s.[SKU Code] and a.Category <> s.Category
and s.Category='Dress'
order by a.Category

Update s
set s.Category='Dress'
from [Sale Report] s
join [Amazon Sale Report] a
on a.SKU=s.[SKU Code] and a.Category <> s.Category 
where a.Category <> s.Category 
and s.Category='Kurta'

Update s
set s.Category='Set'
from [Sale Report] s
join [Amazon Sale Report] a
on a.SKU=s.[SKU Code] and a.Category <> s.Category 
where a.Category <> s.Category 
and s.Category='Dress'

Update s
set s.Category='Set'
from [Sale Report] s
join [Amazon Sale Report] a
on a.SKU=s.[SKU Code] and a.Category <> s.Category 
where a.Category <> s.Category 
and s.Category='Bottom'


select  a.Category,s.Category,a.Size,s.Size
from [Amazon Sale Report]a join [Sale Report]s
on a.SKU=s.[SKU Code] and a.Category <> s.Category
and s.Category='Dress'
order by a.Category


select  a.Category,s.Category,a.Size,s.Size
from [Amazon Sale Report]a join [Sale Report]s
on a.SKU=s.[SKU Code] 
order by a.Category

select a.Category,s.Category,a.Size,s.Size
from [Amazon Sale Report]a join [Sale Report]s
on a.SKU=s.[SKU Code] 
where s.Category is null
order by a.Category


Update [Sale Report]
set Category='Dupatta'
where Category is null

/*SIZE*/
select distinct Size from [Sale Report]
order  by Size

select a.Size,s.Size
from [Amazon Sale Report]a join [Sale Report]s
on a.SKU=s.[SKU Code] 
order by a.Size

Update [Sale Report]
set Size=
CASE
when Size='FREE' then 'Free'
when Size='XXXL' then '3XL' 
else Size
END

--Update Null Values In Different Columns--

delete from [Sale Report]
where 
[SKU Code] is null 
and [Design No#] is null
and Size is null
and Stock is null
and Color is null
--------------------------------------------------------------------------------------------------------------------------
-- INTERNATIONAL SALE REPORT--
select  * from [International Sale Report]
--where date is null
--where customer is null
--where Style is null
--where size is null
--where pcs is null
--where rate is null
--where [GROSS AMT] is null
--where SKU is null 

--Update Date And Null Values--
update [International Sale Report]
set DATE=Months
where DATE is null

alter table [International Sale Report]
drop column Months

delete from [International Sale Report]
where DATE is null 

delete from [International Sale Report]
where CUSTOMER is null

delete from [International Sale Report]
where CUSTOMER is null

--Update Size Column--
select distinct Size from [International Sale Report]
order by Size

select s.[SKU Code],i.SKU,s.Category,s.Size,i.Size
from [Sale Report] s
join [International Sale Report] i
on s.[SKU Code]=i.SKU
order by s.Size


Update i 
set i.Size='XS'
from [Sale Report] s
join [International Sale Report] i
on s.[SKU Code]=i.SKU
where s.Size='XS'

Update i 
set i.Size='4XL'
from [Sale Report] s
join [International Sale Report] i
on s.[SKU Code]=i.SKU
where s.Size='4XL'

Update i 
set i.Size='XL'
from [Sale Report] s
join [International Sale Report] i
on s.[SKU Code]=i.SKU
where s.Size='XL'

Update i 
set i.Size='Free'
from [Sale Report] s
join [International Sale Report] i
on s.[SKU Code]=i.SKU
where s.Size='Free'

Update i 
set i.Size='3XL'
from [Sale Report] s
join [International Sale Report] i
on s.[SKU Code]=i.SKU
where s.Size='3XL'


Update i 
set i.Size='M'
from [Sale Report] s
join [International Sale Report] i
on s.[SKU Code]=i.SKU
where s.Size='M'


Update i 
set i.Size='S'
from [Sale Report] s
join [International Sale Report] i
on s.[SKU Code]=i.SKU
where s.Size='S'

select * from [International Sale Report]
where Size not in ('XL','XS','XXL','M','S','Free','L','6XL','5XL','4XL','3XL')
order by Size

Update [International Sale Report]
set Size= 
CASE
when Size in('1','2') then 'XS'
when Size in('10','15','1000') then 'L'
when Size in('3','XXXL','xxxl') then '3XL'
when Size='4' then '4XL'
when Size='5' then '5XL'
when Size in('6','600','698','7') then '6XL'
else Size
END

alter table [International Sale Report]
add  GROSS_TWO float

UPDATE [International Sale Report]
SET [GROSS_TWO] = [PCS] * [RATE];

alter table [International Sale Report]
drop column [GROSS AMT]

-------------------------------------------------------------------------------------------------------------------------------
--MARCH - MAY--
select *from [March-2021]

select *from [May-2022]

--Update Some Values In Different Columns--
update [March-2021]
set Category=
CASE
when Category='Tops' then 'Top'
when Category='Kurta Set' then 'Set'
when Category='Gown' then 'Top'
else Category
END


update m
set m.Category=mar.Category
from [March-2021] mar join [May-2022] m
on mar.Sku=m.Sku

update [March-2021]
set Catalog = (
    select top 1 Catalog
    from [March-2021]
    where Catalog is not null
    ORDER BY newid()
	)
where catalog='Nill';


update m
set m.Catalog=mar.Catalog
from [March-2021] mar join [May-2022] m
on mar.Sku=m.Sku


update [March-2021]
set Category = (
    select top 1 Category
    from [March-2021]
    where Category is not null
    ORDER BY newid()
	)
where Category='Nill';
	
update m
set m.Category=mar.Category
from [March-2021] mar join [May-2022] m
on mar.Sku=m.Sku
where m.Category='Nill'

--Updates Some Null Values And Remove Unused Data--
alter table [March-2021]
drop column [MRP Old]

alter table [May-2022]
drop column [MRP Old]


select [Final MRP Old] from [March-2021]
where [Final MRP Old] is null

delete from [March-2021]
where [Final MRP Old] is null

delete from [May-2022]
where [Final MRP Old] is null

select Weight,AVG(Weight)as"Average Weight",COUNT(Weight) from [March-2021]
group by Weight



update [March-2021]
set Weight=0.3
where Weight is null

update [May-2022]
set Weight=0.3
where Weight is null


--SOME RELATION--

select a.SKU,s.[SKU Code],i.SKU,a.Style,s.[Design No#],i.Style,a.Size,s.Size,i.Size,a.Category,s.Category
from [Amazon Sale Report] a join [Sale Report] s
on a.SKU=s.[SKU Code]
join [International Sale Report] i
on s.[SKU Code]=i.SKU


select a.Category,a.Status,i.CUSTOMER,s.Stock
from [Amazon Sale Report] a join [Sale Report] s
on a.SKU=s.[SKU Code]
join [International Sale Report] i
on s.[SKU Code]=i.SKU




select a.Qty,i.PCS,a.Amount,i.RATE,i.[GROSS AMT]
from [Amazon Sale Report] a
join [International Sale Report] i
on a.SKU=i.SKU


select a.Category,sum(a.Qty),sum(i.PCS),sum(a.Amount),SUM([GROSS AMT])
from [Amazon Sale Report] a
join [International Sale Report] i
on a.SKU=i.SKU
group by a.Category

select  * from [Amazon Sale Report]
select distinct SKU from [Amazon Sale Report]
--EXPLORING AMAZON AND THE RELATION WITH INTRENATIONAL AND SALE--

--Sum Of Amount In Each Month VS Number Of Orders--
select MONTH(Date) as "Month",Format(SUM(Amount),'N2') as "Sum Of Amount In Each Month",
COUNT([Order ID]) as "Number Of Orders In Each Month"
from [Amazon Sale Report]
group by MONTH(Date)
order by SUM(Amount) desc 


--Number Of Order In Each Day--
select Day(Date) as "Day",COUNT([Order ID]) as "Number Of Orders In Each Day"
from [Amazon Sale Report]
group by Day(Date)
order by "Number Of Orders In Each Day" desc 


--What Are The Number Of Different Status Of Our Orders And Total Amount In Each Status?--
select Status,COUNT([Order ID])  as "Number Of Orders",FORMAT(SUM(Amount),'N2') as "Price"
from [Amazon Sale Report]
group by Status 
order by "Number Of Orders" desc   


--Focusing In The Fulfilment And Sales Channel Operation And The Price Of Each Operation--
select Fulfilment,[Sales Channel],COUNT([Order ID]) as "Number Of Orders"
,FORMAT(SUM(Amount),'N2') as "Price"
from [Amazon Sale Report]
group by Fulfilment,[Sales Channel]
order by Fulfilment 


--Most Ship Service Found In Our Orders And Average Price For Each Service--
select [ship-service-level],COUNT([Order ID]) as "Number Of Orders",
FORMAT(SUM(Amount),'N2') as "Price"
from [Amazon Sale Report]
group by [ship-service-level]
order by "Number Of Orders" desc 
 

--Number Of Orders For Each Category And Price Of Them--
select Category,COUNT([Order ID]) as "Number Of Orders",
FORMAT(SUM(Amount),'N2') as "Price"
from [Amazon Sale Report]
group by Category
order by "Number Of Orders" desc 


--Most Size Make Money In Each Category-- 
with Size_cte as(
select Category,Size,FORMAT(SUM(Amount),'N2') as "Price"
, ROW_NUMBER() over(partition by category order by sum(amount) desc) as r
from [Amazon Sale Report]
group by Category,Size
)
select Category,Size,"Price"
from Size_cte
where r=1
order by Size 
 

--Top 10 City And State Make Orders And Spent Money--
select TOP 10 [ship-city],COUNT([Order ID]) as "Number Of Orders"
,FORMAT(SUM(Amount),'N2') as "Price"
from [Amazon Sale Report]
group by [ship-city]
order by "Number Of Orders" desc 

select TOP 10 [ship-state],COUNT([Order ID]) as "Number Of Orders"
,FORMAT(SUM(Amount),'N2') as "Price"
from [Amazon Sale Report]
group by [ship-state]
order by [Number Of Orders] desc 


--Top 10 SKU Make Profit And It Requested A Lot--
select TOP 10 SKU,COUNT([Order ID]) as "Number Of Orders"
,FORMAT(SUM(Amount),'N2') as "Price"
from [Amazon Sale Report]
group by SKU
order by [Number Of Orders] desc 


--Are Most Orders Were Made Are B2B Or Not--
select B2B,COUNT(B2B) "Number Of Order"
from [Amazon Sale Report] 
group by B2B 


--Number Of Stocks For Each Category--
select amazon.Category,FORMAT(SUM(sale.Stock),'N0') as "Number Of Stocks"
from [Amazon Sale Report] amazon
 join [Sale Report] sale
   on amazon.SKU=sale.[SKU Code]
group by amazon.Category
order by SUM(sale.Stock) desc



--Most Size Found In The Stocks In Each Category--
with Size_cte as(
select amazon.Category,amazon.Size,FORMAT(SUM(sale.Stock),'N0') as "Number Of Stocks"
, ROW_NUMBER() over(partition by amazon.category order by sum(sale.Stock) desc) as r
from [Amazon Sale Report] amazon
join [Sale Report] sale
    on amazon.SKU=sale.[SKU Code]
group by amazon.Category,amazon.Size
)
select Size_cte.Category,Size_cte.Size,"Number Of Stocks"
from Size_cte
where Size_cte.r=1
order by Size_cte.Size


--The Most Color Make Profit In Each Category--
with Size_cte as(
select amazon.Category,sale.Color,FORMAT(SUM(amazon.Amount),'N2') as "Price"
, ROW_NUMBER() over(partition by amazon.category order by sum(amazon.Amount) desc) as r
from [Amazon Sale Report] amazon
join [Sale Report] sale
    on amazon.SKU=sale.[SKU Code]
group by amazon.Category,sale.Color
)
select Size_cte.Category,Size_cte.Color,"Price"
from Size_cte
where Size_cte.r=1
order by Size_cte.Category


--Most Customers Spend Money In Purchasig Process--
select i.CUSTOMER,format(sum(a.Amount),'N2') as "Total"
from [Amazon Sale Report] a 
join [Sale Report]s
    on a.SKU=s.[SKU Code]
join [International Sale Report] i 
    on s.[SKU Code]=i.SKU
group by i.CUSTOMER
order by sum(a.Amount) desc 


--Number Of Pieces Sold In General In Each Category And Show Total Price--
select a.Category,format(sum(i.[PCS]),'N2') as "Number Of Pieces",
format(sum(a.Amount),'N2') "Total Price"
from [Amazon Sale Report] a 
join [Sale Report]s
    on a.SKU=s.[SKU Code]
join [International Sale Report] i 
    on s.[SKU Code]=i.SKU
group by a.Category
order by sum(a.Amount) desc 


--Top 20 City And State To Which Pieces Shipped--
select  top (20) a.[ship-city],a.[ship-state],format(sum(i.[PCS]),'N0') as "Number Of Pieces"
from [Amazon Sale Report] a 
join [Sale Report]s
    on a.SKU=s.[SKU Code]
join [International Sale Report] i 
    on s.[SKU Code]=i.SKU
group by a.[ship-city],a.[ship-state]
order by sum(i.[PCS]) desc 
--------------------------------------------------------------------------------------------------------------------------------
select * from [March-2021]
select * from [May-2022]

--EXPLORING MARCH-MAY--

--Total Price For Each Catalog In Each MRP With Focus On Final Price(March-May)--

select 
march.Catalog
,FORMAT(SUM(march.[Final MRP Old]),'N0') as"Final Price For Each Catalog 2021",FORMAT(SUM(may.[Final MRP Old]),'N0') as"Final Price For Each Catalog 2022"
,FORMAT(SUM(march.[Ajio MRP]),'N0') as"Total Price On AJIO 2021",FORMAT(SUM(may.[Ajio MRP]),'N0') as"Total Price On AJIO 2022"
,FORMAT(SUM(march.[Amazon MRP]),'N0') as"Total Price On AMAZON 2021",FORMAT(SUM(may.[Amazon MRP]),'N0') as"Total Price On AMAZON 2022"
,FORMAT(SUM(march.[Amazon FBA MRP]),'N0') as"Total Price On FBA 2021",FORMAT(SUM(may.[Amazon FBA MRP]),'N0') as"Total Price On FBA 2022"
,FORMAT(SUM(march.[Flipkart MRP]),'N0') as"Total Price On FLIPKART 2021",FORMAT(SUM(may.[Flipkart MRP]),'N0') as"Total Price On FLIPKART 2022"
,FORMAT(SUM(march.[Limeroad MRP]),'N0') as"Total Price On LIMEROAD 2021",FORMAT(SUM(may.[Limeroad MRP]),'N0') as"Total Price On LIMEROAD 2022"
,FORMAT(SUM(march.[Myntra MRP]),'N0') as"Total Price On MYNTRA 2021 ",FORMAT(SUM(may.[Myntra MRP]),'N0') as"Total Price On MYNTRA 2022"
,FORMAT(SUM(march.[Paytm MRP]),'N0') as"Total Price On PAYTM 2021",FORMAT(SUM(may.[Paytm MRP]),'N0') as"Total Price On PAYTM 2022"
,FORMAT(SUM(march.[Snapdeal MRP]),'N0') as"Total Price On SNAPDEAL 2021",FORMAT(SUM(may.[Snapdeal MRP]),'N0') as"Total Price On SNAPDEAL 2022"
from [March-2021] march
join [May-2022] may
    on march.Sku=may.Sku
group by march.Catalog





--Average Price For Each Category In Each MPR With Focus On Final Price(March-May)--

select 
march.Category
,AVG(march.[Final MRP Old]) as"AVG Price For Each Category 2021",AVG(may.[Final MRP Old]) as"AVG Price For Each Category 2022"
,AVG(march.[Ajio MRP]) as "AVG Price In AJIO 2021",AVG(may.[Ajio MRP]) as "AVG Price In AJIO 2022"
,AVG(march.[Amazon MRP]) as "AVG Price In AMAZON 2021",AVG(may.[Amazon MRP]) as "AVG Price In AMAZON 2022"
,AVG(march.[Amazon FBA MRP]) as "AVG Price In FBA 2021",AVG(may.[Amazon FBA MRP]) as "AVG Price In FBA 2022"
,AVG(march.[Flipkart MRP]) as "AVG Price In FLIPKART 2021",AVG(may.[Flipkart MRP]) as "AVG Price In FLIPKART 2022"
,AVG(march.[Limeroad MRP]) as "AVG Price In LIMEROAD 2021",AVG(may.[Limeroad MRP]) as "AVG Price In LIMEROAD 2022"
,AVG(march.[Myntra MRP]) as "AVG Price In MYNTRA 2021",AVG(may.[Myntra MRP]) as "AVG Price In MYNTRA 2022"
,AVG(march.[Paytm MRP]) as "AVG Price In PAYTM 2021",AVG(may.[Paytm MRP]) as "AVG Price In PAYTM 2022"
,AVG(march.[Snapdeal MRP]) as "AVG Price In SNAPDEAL 2021",AVG(may.[Snapdeal MRP]) as "AVG Price In SNAPDEAL 2022"
from [March-2021] march 
join[May-2022] may
    on march.Sku=may.Sku
group by march.Category












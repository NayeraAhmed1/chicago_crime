/*How many total crimes were reported in 2021?*/
select count(crime_date) as crimes ,YEAR(crime_date) as year
from crimes
group by year(crime_date)
/*What is the count of Homicides, Battery and Assaults reported?*/
select crime_type , count(*) AS counting_crimes
from crimes
where crime_type in('Homicide','Battery','Assault')
group by crime_type
/*Create a temp table that joins data from all three tables*/
select * from crimes
select * from [dbo].[areas]
select * from [dbo].[temps]

select * 
from crimes join areas 
on crimes.community_id = areas.community_area_id
join temps on crimes.crime_date = temps.date
/*What are the top ten communities that had the most crimes reported? We will also add the current population to see if area density is also a factor*/
select top 10 count(crime_date) as crimes_reported,areas.name
from crimes 
join areas on areas.community_area_id=crimes.community_id
group by name
order by COUNT(crime_date) desc

/*What are the top ten communities that had the least amount of crimes reported? We will also add the current population to see if area density is also a factor.*/
select top 10 count(crime_date) as crimes_reported , areas.name
from areas join crimes 
on areas.community_area_id=crimes.community_id
group by areas.name
order by count(crime_date) asc
/*What date had the most crimes reported?*/
select count(crime_date) as crimes , crime_date
from crimes 
group by crime_date
order by count(crime_date) 
/*What month had the most crimes reported?*/
select datename(month, crime_date) as "month",month(crime_date) as "month#" , count(crime_date) as "count" 
from crimes 
group by datename(month, crime_date),month(crime_date)
order by month 

/*What month had the most homicides and what was the average and median temperature?*/
select crimes.crime_type , count(crimes.crime_type) as "count" , sum(temps.[temp_high]+ temps.[temp_low])/2 as "temp" ,month(crimes.crime_date) as"month"
from crimes join temps 
on crimes.crime_date = temps.date
where crimes.crime_type like  '%hom%'
group by crimes.crime_type ,month(crimes.crime_date)

/*What weekday were most crimes committed?*/
select datename (weekday,crimes.crime_date) as week , count (crimes.crime_date) as count 
from crimes
group by datename(weekday, crime_date)
/*What are the top ten city streets that have had the most reported crimes?*/
select top 10 count(crime_date) as count , city_block
 from crimes
 group by city_block 
 order by count desc
/*What are the top ten city streets that have had the most homicides including ties?*/
select top 10 city_block , COUNT(crime_date) as count , crime_description
from crimes
where crime_description like ('%t%') and crime_type like ('homo%')
group by city_block ,crime_description 

/*What are the top ten city streets that have had the most burglaries?*/
select top 10 COUNT(crime_date) as count , city_block, crime_type
from crimes 
where crime_type like ('burg%') 
group by city_Block , crime_type
/*What was the number of reported crimes on the hottest day of the year vs the coldest?*/
select count (crime_date) as count , max(temp_high) as max_temp , min(temp_low) as min_temp ,datename(weekday,crime_date) 
from crimes join temps 
on temps .date= crimes.crime_date 
group by datename(weekday,crime_date)
/*What is the number and types of reported crimes on Michigan Ave (The Rodeo Drive of the Midwest)?*/
select count(crime_date) as count , city_block , crime_type
from crimes join areas
on crimes.community_id=areas.community_area_id
where city_block like ('%Mich%')
group by city_block , crime_type 
order by count desc

/*What are the top 5 least reported crime, how many arrests were made and the percentage of arrests made?*/
select count(crime_type) as count , crime_type, sum (arrest) as arrests, sum (arrest)/count(crime_type) as percantage
from crimes
group by crime_type

/*What is the percentage of domestic violence crimes?*/
select sum(domestic) as summ , count(domestic) as countt , sum (domestic)/COUNT(domestic ) as percentage
from crimes

/*What is the Month, day of the week and the number of homicides that occured in a babershop or beauty salon?*/
select datename(month,crime_date) as"month" , datename(weekday,crime_date) as "dayweel",count(crime_type) as"count", month(crime_date) as "month#"
from crimes
where crime_type ='homicide'
and crime_location like '%salon%'
or crime_location like '%barber%'
group by DATENAME(month,crime_date), datename(weekday,crime_date),month(crime_date)
order by  month(crime_date) asc

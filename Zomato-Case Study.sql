create database Zomato_db;
use Zomato_db;

CREATE TABLE zomato(RestaurantID INTEGER primary key,
Res_identify char(100),
CountryCode int,
City char(100),
Cuisines char(100),
Has_Table_booking char(3),
Has_Online_delivery char(3),
Is_delivering_now char(3),
Switch_to_order_menu char(3),
Price_range	int,
Votes int,
Average_Cost_for_two int,
Rating int
);

#1) Help Zomato in identifying the cities with poor Restaurant ratings.
 select City, avg(Rating) as rating
 from zomato
 group by City
 order by rating asc;
 
#2) Mr.roy is looking for a restaurant in kolkata which provides online delivery. Help him choose the best restaurant.
 select RestaurantID, Res_identify, City, Has_Online_delivery, Rating
 from zomato
 where City = "Kolkata" and Has_Online_delivery = "Yes"
 order by Rating desc;
 
#3) Help Peter in finding the best rated Restraunt for Pizza in New Delhi.
 select RestaurantID, Res_identify, City, Cuisines, Rating
 from zomato
 where City = "New Delhi"
 having Cuisines = "Italian"
 order by Rating desc;
 
#4)Enlist most affordable and highly rated restaurants city wise.
with s as
(select RestaurantID, Res_identify, City, Rating, Average_Cost_for_two,
rank() over (partition by City order by Average_Cost_for_two asc, Rating desc) as rnk
from zomato)

select * from s
where rnk = 1;


#5)Help zomato in identifying those cities which have atleast 3 restaurants with ratings >= 4.9
-- In case there are two cities with the same result, sort them in alphabetical order.
with s as
(select City, count(*) as Count
 from zomato
 where Rating >= 4.9
 group by City)
 
 select * from s
 where count >= 3
 order by City asc;
 
#6) What are the top 5 countries with most restaurants linked with Zomato?
select c.Country, count(z.RestaurantID) 'no of restaurants linked with Zomato'
 from countrytable c inner join zomato z on c.CountryCode = z.CountryCode
 group by c.Country
 order by 'no of restaurants linked with Zomato' desc
 limit 5;
 
 #7) What is the average cost for two across all Zomato listed restaurants? 
 select avg(Average_Cost_for_two) 'average cost for two across all Zomato listed restaurants'
 from zomato;
 
 #8) Group the restaurants basis the average cost for two into: 
-- Luxurious Expensive, Very Expensive, Expensive, High, Medium High, Average. 
-- Then, find the number of restaurants in each category. 

select
case
when Average_Cost_for_two between 0 and 100000 then "Average"
when Average_Cost_for_two between 100001 and 250000 then "Medium High"
when Average_Cost_for_two between 250001 and 400000 then "High"
when Average_Cost_for_two between 400001 and 600000 then "Expensive"
when Average_Cost_for_two between 600001 and 700000 then "Very Expensive"
else "Luxurious Expensive"
end as 'Resturant category', count(*)
from zomato
group by 1;

 
 #9)List the two top 5 restaurants with highest rating with maximum votes.
with s as
(select RestaurantID, Res_identify, Votes, Rating
from zomato
order by Votes desc)

select*
from s
order by Rating desc
limit 5;
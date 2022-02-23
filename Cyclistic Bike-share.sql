--start
--2021_data

--create temp table for 1 year bike-share data

drop table if exists #2021_ride_data
create table #2021_ride_data
(
ride_id nvarchar(255),
rideable_type nvarchar(255),
started_at datetime,
ended_at datetime,
start_station_name nvarchar(255),
end_station_name nvarchar(255),
member_casual nvarchar(255),
)
insert into #2021_ride_data
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual
from case_study..jan_bikedata
union
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual
from case_study..feb_bikedata
union
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual
from case_study..mar_bikedata
union
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual
from case_study..apr_bikedata
union
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual
from case_study..may_bikedata
union
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual
from case_study..jun_bikedata
union
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual
from case_study..jul_bikedata
union
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual
from case_study..aug_bikedata
union
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual
from case_study..sep_bikedata
union
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual
from case_study..oct_bikedata
union
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual
from case_study..nov_bikedata
union
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual
from case_study..dec_bikedata
order by started_at, ended_at


select *
from #2021_ride_data
order by started_at, ended_at

--create temp table for new column ride_length_minute and day_of_week

drop table if exists #2021_ride_calculation
create table #2021_ride_calculation
(
ride_id nvarchar(255),
rideable_type nvarchar(255),
started_at datetime,
ended_at datetime,
start_station_name nvarchar(255),
end_station_name nvarchar(255),
member_casual nvarchar(255),
ride_length_minute time(0),
day_of_week numeric,
)
insert into #2021_ride_calculation
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, 
	   LEFT(CAST((ended_at-started_at) as time(0)), 8) as ride_length_minute, 
	   datepart(weekday, started_at) as day_of_week
from #2021_ride_data
order by started_at, ended_at

--eliminate ride length under 3 minutes as user might do mistake while using bike-share

select *
from #2021_ride_calculation
where ride_length_minute > '00:03:00'
order by started_at, ended_at

--1 year data analysis

select max(ride_length_minute) as max_ride_length
from #2021_ride_calculation

select 
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #2021_ride_calculation
where ride_length_minute > '00:03:00'


select top 5(start_station_name) as top_station_name, member_casual,
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length,
  count(ride_id) as number_user
from #2021_ride_calculation
where ride_length_minute > '00:03:00'
group by start_station_name, member_casual
order by count(*) desc


SELECT member_casual, 
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #2021_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY member_casual

--
SELECT day_of_week, member_casual,
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #2021_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week, member_casual
order by day_of_week, member_casual

--
SELECT day_of_week, count(ride_id) as count_ride_id
FROM #2021_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week
order by day_of_week


select count(member_casual) as member_casual_number
from #2021_ride_calculation
group by member_casual

select count(member_casual) as total_member_casual_number
from #2021_ride_calculation

SELECT  member_casual, count(*) * 100.0 / (SELECT count(member_casual) from #2021_ride_calculation) as 'membership_Percentage',
		count(member_casual) as member_casual_number
FROM #2021_ride_calculation
group by member_casual

SELECT  rideable_type, member_casual, left(count(*) * 100.0 / (SELECT count(member_casual) from #2021_ride_calculation), 5) as 'membership_Percentage',
		count(member_casual) as member_casual_number
FROM #2021_ride_calculation
group by rideable_type, member_casual
order by rideable_type, member_casual
--

--end

--remove unnecessary data

--start
--january_data

select *
from case_study..jan_bikedata

alter table case_study..jan_bikedata
drop column start_station_id, end_station_id, start_lat, end_lat, start_lng, end_lng

delete from case_study..jan_bikedata
where start_station_name is null

delete from case_study..jan_bikedata
where end_station_name is null


select started_at, ended_at, datediff(minute, started_at, ended_at) as ride_length_minute,
	   datepart(weekday, started_at) as day_of_week
from case_study..jan_bikedata
order by started_at


drop table if exists #jan_ride_calculation
create table #jan_ride_calculation
(
ride_id nvarchar(255),
rideable_type nvarchar(255),
started_at datetime,
ended_at datetime,
start_station_name nvarchar(255),
end_station_name nvarchar(255),
member_casual nvarchar(255),
ride_length_minute time(0),
day_of_week numeric,
)
insert into #jan_ride_calculation
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, 
	   LEFT(CAST((ended_at-started_at) as time(0)), 8) as ride_length_minute, 
	   datepart(weekday, started_at) as day_of_week
from case_study..jan_bikedata
order by started_at, ended_at

--For excel analysis
select *
from #jan_ride_calculation
where ride_length_minute > '00:03:00'
order by started_at
--

select max(ride_length_minute) as max_ride_length
from #jan_ride_calculation


select 
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #jan_ride_calculation
where ride_length_minute > '00:03:00'


select top 1(day_of_week) as mode,
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time),8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #jan_ride_calculation
where ride_length_minute > '00:03:00'
group by day_of_week
order by count(*) desc


SELECT member_casual, 
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #jan_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY member_casual

SELECT day_of_week, member_casual,
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #jan_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week, member_casual
order by day_of_week, member_casual

SELECT day_of_week, count(ride_id) as count_ride_id
FROM #jan_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week
order by day_of_week

--end



--start

select *
from case_study..feb_bikedata

alter table case_study..feb_bikedata
drop column start_station_id, end_station_id, start_lat, end_lat, start_lng, end_lng

delete from case_study..feb_bikedata
where start_station_name is null

delete from case_study..feb_bikedata
where end_station_name is null

drop table if exists #feb_ride_calculation
create table #feb_ride_calculation
(
ride_id nvarchar(255),
rideable_type nvarchar(255),
started_at datetime,
ended_at datetime,
start_station_name nvarchar(255),
end_station_name nvarchar(255),
member_casual nvarchar(255),
ride_length_minute time(0),
day_of_week numeric,
)
insert into #feb_ride_calculation
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, 
	   LEFT(CAST((ended_at-started_at) as time(0)), 8) as ride_length_minute, 
	   datepart(weekday, started_at) as day_of_week
from case_study..feb_bikedata
order by started_at, ended_at

--For excel analysis
select *
from #feb_ride_calculation
where ride_length_minute > '00:03:00'
order by started_at
--

select max(ride_length_minute) as max_ride_length
from #feb_ride_calculation


select 
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #feb_ride_calculation
where ride_length_minute > '00:03:00'


select top 1(day_of_week) as mode,
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time),8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #feb_ride_calculation
where ride_length_minute > '00:03:00'
group by day_of_week
order by count(*) desc


SELECT member_casual, 
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #feb_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY member_casual

SELECT day_of_week, member_casual,
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #feb_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week, member_casual
order by day_of_week, member_casual

SELECT day_of_week, count(ride_id) as count_ride_id
FROM #feb_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week
order by day_of_week

--end

--start

select *
from case_study..mar_bikedata

alter table case_study..mar_bikedata
drop column start_station_id, end_station_id, start_lat, end_lat, start_lng, end_lng

delete from case_study..mar_bikedata
where start_station_name is null

delete from case_study..mar_bikedata
where end_station_name is null

drop table if exists #mar_ride_calculation
create table #mar_ride_calculation
(
ride_id nvarchar(255),
rideable_type nvarchar(255),
started_at datetime,
ended_at datetime,
start_station_name nvarchar(255),
end_station_name nvarchar(255),
member_casual nvarchar(255),
ride_length_minute time(0),
day_of_week numeric,
)
insert into #mar_ride_calculation
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, 
	   LEFT(CAST((ended_at-started_at) as time(0)), 8) as ride_length_minute, 
	   datepart(weekday, started_at) as day_of_week
from case_study..mar_bikedata
order by started_at, ended_at

--For excel analysis
select *
from #mar_ride_calculation
where ride_length_minute > '00:03:00'
order by started_at
--

select max(ride_length_minute) as max_ride_length
from #mar_ride_calculation


select 
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #mar_ride_calculation
where ride_length_minute > '00:03:00'


select top 1(day_of_week) as mode,
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time),8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #mar_ride_calculation
where ride_length_minute > '00:03:00'
group by day_of_week
order by count(*) desc


SELECT member_casual, 
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #mar_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY member_casual

SELECT day_of_week, member_casual,
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #mar_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week, member_casual
order by day_of_week, member_casual

SELECT day_of_week, count(ride_id) as count_ride_id
FROM #mar_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week
order by day_of_week

--end

--start

select *
from case_study..apr_bikedata

alter table case_study..apr_bikedata
drop column start_station_id, end_station_id, start_lat, end_lat, start_lng, end_lng

delete from case_study..apr_bikedata
where start_station_name is null

delete from case_study..apr_bikedata
where end_station_name is null

drop table if exists #apr_ride_calculation
create table #apr_ride_calculation
(
ride_id nvarchar(255),
rideable_type nvarchar(255),
started_at datetime,
ended_at datetime,
start_station_name nvarchar(255),
end_station_name nvarchar(255),
member_casual nvarchar(255),
ride_length_minute time(0),
day_of_week numeric,
)
insert into #apr_ride_calculation
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, 
	   LEFT(CAST((ended_at-started_at) as time(0)), 8) as ride_length_minute, 
	   datepart(weekday, started_at) as day_of_week
from case_study..apr_bikedata
order by started_at, ended_at

--For excel analysis
select *
from #apr_ride_calculation
where ride_length_minute > '00:03:00'
order by started_at
--

select max(ride_length_minute) as max_ride_length
from #apr_ride_calculation


select 
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #apr_ride_calculation
where ride_length_minute > '00:03:00'


select top 1(day_of_week) as mode,
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time),8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #apr_ride_calculation
where ride_length_minute > '00:03:00'
group by day_of_week
order by count(*) desc


SELECT member_casual, 
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #apr_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY member_casual

SELECT day_of_week, member_casual,
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #apr_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week, member_casual
order by day_of_week, member_casual

SELECT day_of_week, count(ride_id) as count_ride_id
FROM #apr_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week
order by day_of_week

--end

--start

select *
from case_study..may_bikedata

alter table case_study..may_bikedata
drop column start_station_id, end_station_id, start_lat, end_lat, start_lng, end_lng

delete from case_study..may_bikedata
where start_station_name is null

delete from case_study..may_bikedata
where end_station_name is null

drop table if exists #may_ride_calculation
create table #may_ride_calculation
(
ride_id nvarchar(255),
rideable_type nvarchar(255),
started_at datetime,
ended_at datetime,
start_station_name nvarchar(255),
end_station_name nvarchar(255),
member_casual nvarchar(255),
ride_length_minute time(0),
day_of_week numeric,
)
insert into #may_ride_calculation
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, 
	   LEFT(CAST((ended_at-started_at) as time(0)), 8) as ride_length_minute, 
	   datepart(weekday, started_at) as day_of_week
from case_study..may_bikedata
order by started_at, ended_at

--For excel analysis
select *
from #may_ride_calculation
where ride_length_minute > '00:03:00'
order by started_at
--

select max(ride_length_minute) as max_ride_length
from #may_ride_calculation


select 
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #may_ride_calculation
where ride_length_minute > '00:03:00'


select top 1(day_of_week) as mode,
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time),8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #may_ride_calculation
where ride_length_minute > '00:03:00'
group by day_of_week
order by count(*) desc


SELECT member_casual, 
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #may_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY member_casual

SELECT day_of_week, member_casual,
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #may_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week, member_casual
order by day_of_week, member_casual

SELECT day_of_week, count(ride_id) as count_ride_id
FROM #may_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week
order by day_of_week
--end

--start

select *
from case_study..jun_bikedata

alter table case_study..jun_bikedata
drop column start_station_id, end_station_id, start_lat, end_lat, start_lng, end_lng

delete from case_study..jun_bikedata
where start_station_name is null

delete from case_study..jun_bikedata
where end_station_name is null

drop table if exists #jun_ride_calculation
create table #jun_ride_calculation
(
ride_id nvarchar(255),
rideable_type nvarchar(255),
started_at datetime,
ended_at datetime,
start_station_name nvarchar(255),
end_station_name nvarchar(255),
member_casual nvarchar(255),
ride_length_minute time(0),
day_of_week numeric,
)
insert into #jun_ride_calculation
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, 
	   LEFT(CAST((ended_at-started_at) as time(0)), 8) as ride_length_minute, 
	   datepart(weekday, started_at) as day_of_week
from case_study..jun_bikedata
order by started_at, ended_at

--For excel analysis
select *
from #jun_ride_calculation
where ride_length_minute > '00:03:00'
order by started_at
--

select max(ride_length_minute) as max_ride_length
from #jun_ride_calculation


select 
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #jun_ride_calculation
where ride_length_minute > '00:03:00'


select top 1(day_of_week) as mode,
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time),8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #jun_ride_calculation
where ride_length_minute > '00:03:00'
group by day_of_week
order by count(*) desc


SELECT member_casual, 
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #jun_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY member_casual

SELECT day_of_week, member_casual,
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #jun_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week, member_casual
order by day_of_week, member_casual

SELECT day_of_week, count(ride_id) as count_ride_id
FROM #jun_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week
order by day_of_week

--end

--start

select *
from case_study..jul_bikedata

alter table case_study..jul_bikedata
drop column start_station_id, end_station_id, start_lat, end_lat, start_lng, end_lng

delete from case_study..jul_bikedata
where start_station_name is null

delete from case_study..jul_bikedata
where end_station_name is null

drop table if exists #jul_ride_calculation
create table #jul_ride_calculation
(
ride_id nvarchar(255),
rideable_type nvarchar(255),
started_at datetime,
ended_at datetime,
start_station_name nvarchar(255),
end_station_name nvarchar(255),
member_casual nvarchar(255),
ride_length_minute time(0),
day_of_week numeric,
)
insert into #jul_ride_calculation
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, 
	   LEFT(CAST((ended_at-started_at) as time(0)), 8) as ride_length_minute, 
	   datepart(weekday, started_at) as day_of_week
from case_study..jul_bikedata
order by started_at, ended_at

--For excel analysis
select *
from #jul_ride_calculation
where ride_length_minute > '00:03:00'
order by started_at
--

select max(ride_length_minute) as max_ride_length
from #jul_ride_calculation


select 
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #jul_ride_calculation
where ride_length_minute > '00:03:00'


select top 1(day_of_week) as mode,
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time),8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #jul_ride_calculation
where ride_length_minute > '00:03:00'
group by day_of_week
order by count(*) desc


SELECT member_casual, 
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #jul_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY member_casual

SELECT day_of_week, member_casual,
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #jul_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week, member_casual
order by day_of_week, member_casual

SELECT day_of_week, count(ride_id) as count_ride_id
FROM #jul_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week
order by day_of_week

--end

--start

select *
from case_study..aug_bikedata

alter table case_study..aug_bikedata
drop column start_station_id, end_station_id, start_lat, end_lat, start_lng, end_lng

delete from case_study..aug_bikedata
where start_station_name is null

delete from case_study..aug_bikedata
where end_station_name is null

drop table if exists #aug_ride_calculation
create table #aug_ride_calculation
(
ride_id nvarchar(255),
rideable_type nvarchar(255),
started_at datetime,
ended_at datetime,
start_station_name nvarchar(255),
end_station_name nvarchar(255),
member_casual nvarchar(255),
ride_length_minute time(0),
day_of_week numeric,
)
insert into #aug_ride_calculation
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, 
	   LEFT(CAST((ended_at-started_at) as time(0)), 8) as ride_length_minute, 
	   datepart(weekday, started_at) as day_of_week
from case_study..aug_bikedata
order by started_at, ended_at

--For excel analysis
select *
from #aug_ride_calculation
where ride_length_minute > '00:03:00'
order by started_at
--

select max(ride_length_minute) as max_ride_length
from #aug_ride_calculation


select 
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #aug_ride_calculation
where ride_length_minute > '00:03:00'


select top 1(day_of_week) as mode,
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time),8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #aug_ride_calculation
where ride_length_minute > '00:03:00'
group by day_of_week
order by count(*) desc


SELECT member_casual, 
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #aug_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY member_casual

SELECT day_of_week, member_casual,
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #aug_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week, member_casual
order by day_of_week, member_casual

SELECT day_of_week, count(ride_id) as count_ride_id
FROM #aug_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week
order by day_of_week

--end

--start

select *
from case_study..sep_bikedata

alter table case_study..sep_bikedata
drop column start_station_id, end_station_id, start_lat, end_lat, start_lng, end_lng

delete from case_study..sep_bikedata
where start_station_name is null

delete from case_study..sep_bikedata
where end_station_name is null

drop table if exists #sep_ride_calculation
create table #sep_ride_calculation
(
ride_id nvarchar(255),
rideable_type nvarchar(255),
started_at datetime,
ended_at datetime,
start_station_name nvarchar(255),
end_station_name nvarchar(255),
member_casual nvarchar(255),
ride_length_minute time(0),
day_of_week numeric,
)
insert into #sep_ride_calculation
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, 
	   LEFT(CAST((ended_at-started_at) as time(0)), 8) as ride_length_minute, 
	   datepart(weekday, started_at) as day_of_week
from case_study..sep_bikedata
order by started_at, ended_at

--For excel analysis
select *
from #sep_ride_calculation
where ride_length_minute > '00:03:00'
order by started_at
--

select max(ride_length_minute) as max_ride_length
from #sep_ride_calculation


select 
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #sep_ride_calculation
where ride_length_minute > '00:03:00'


select top 1(day_of_week) as mode,
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time),8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #sep_ride_calculation
where ride_length_minute > '00:03:00'
group by day_of_week
order by count(*) desc


SELECT member_casual, 
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #sep_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY member_casual

SELECT day_of_week, member_casual,
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #sep_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week, member_casual
order by day_of_week, member_casual

SELECT day_of_week, count(ride_id) as count_ride_id
FROM #sep_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week
order by day_of_week

--end

--start

select *
from case_study..oct_bikedata

alter table case_study..oct_bikedata
drop column start_station_id, end_station_id, start_lat, end_lat, start_lng, end_lng

delete from case_study..oct_bikedata
where start_station_name is null

delete from case_study..oct_bikedata
where end_station_name is null

drop table if exists #oct_ride_calculation
create table #oct_ride_calculation
(
ride_id nvarchar(255),
rideable_type nvarchar(255),
started_at datetime,
ended_at datetime,
start_station_name nvarchar(255),
end_station_name nvarchar(255),
member_casual nvarchar(255),
ride_length_minute time(0),
day_of_week numeric,
)
insert into #oct_ride_calculation
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, 
	   LEFT(CAST((ended_at-started_at) as time(0)), 8) as ride_length_minute, 
	   datepart(weekday, started_at) as day_of_week
from case_study..oct_bikedata
order by started_at, ended_at

--For excel analysis
select *
from #oct_ride_calculation
where ride_length_minute > '00:03:00'
order by started_at
--

select max(ride_length_minute) as max_ride_length
from #oct_ride_calculation


select 
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #oct_ride_calculation
where ride_length_minute > '00:03:00'


select top 1(day_of_week) as mode,
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time),8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #oct_ride_calculation
where ride_length_minute > '00:03:00'
group by day_of_week
order by count(*) desc


SELECT member_casual, 
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #oct_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY member_casual

SELECT day_of_week, member_casual,
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #oct_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week, member_casual
order by day_of_week, member_casual

SELECT day_of_week, count(ride_id) as count_ride_id
FROM #oct_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week
order by day_of_week

--end

--start

select *
from case_study..nov_bikedata

alter table case_study..nov_bikedata
drop column start_station_id, end_station_id, start_lat, end_lat, start_lng, end_lng

delete from case_study..nov_bikedata
where start_station_name is null

delete from case_study..nov_bikedata
where end_station_name is null

drop table if exists #nov_ride_calculation
create table #nov_ride_calculation
(
ride_id nvarchar(255),
rideable_type nvarchar(255),
started_at datetime,
ended_at datetime,
start_station_name nvarchar(255),
end_station_name nvarchar(255),
member_casual nvarchar(255),
ride_length_minute time(0),
day_of_week numeric,
)
insert into #nov_ride_calculation
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, 
	   LEFT(CAST((ended_at-started_at) as time(0)), 8) as ride_length_minute, 
	   datepart(weekday, started_at) as day_of_week
from case_study..nov_bikedata
order by started_at, ended_at

--For excel analysis
select *
from #nov_ride_calculation
where ride_length_minute > '00:03:00'
order by started_at
--

select max(ride_length_minute) as max_ride_length
from #nov_ride_calculation


select 
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #nov_ride_calculation
where ride_length_minute > '00:03:00'


select top 1(day_of_week) as mode,
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time),8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #nov_ride_calculation
where ride_length_minute > '00:03:00'
group by day_of_week
order by count(*) desc


SELECT member_casual, 
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #nov_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY member_casual

SELECT day_of_week, member_casual,
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #nov_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week, member_casual
order by day_of_week, member_casual

SELECT day_of_week, count(ride_id) as count_ride_id
FROM #nov_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week
order by day_of_week

--end

--start

select *
from case_study..dec_bikedata

alter table case_study..dec_bikedata
drop column start_station_id, end_station_id, start_lat, end_lat, start_lng, end_lng

delete from case_study..dec_bikedata
where start_station_name is null

delete from case_study..dec_bikedata
where end_station_name is null

drop table if exists #dec_ride_calculation
create table #dec_ride_calculation
(
ride_id nvarchar(255),
rideable_type nvarchar(255),
started_at datetime,
ended_at datetime,
start_station_name nvarchar(255),
end_station_name nvarchar(255),
member_casual nvarchar(255),
ride_length_minute time(0),
day_of_week numeric,
)
insert into #dec_ride_calculation
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, 
	   LEFT(CAST((ended_at-started_at) as time(0)), 8) as ride_length_minute, 
	   datepart(weekday, started_at) as day_of_week
from case_study..dec_bikedata
order by started_at, ended_at

--For excel analysis
select *
from #dec_ride_calculation
where ride_length_minute > '00:03:00'
order by started_at
--

select max(ride_length_minute) as max_ride_length
from #dec_ride_calculation


select 
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #dec_ride_calculation
where ride_length_minute > '00:03:00'


select top 1(day_of_week) as mode,
  left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time),8) avg_ride_length,
  max(ride_length_minute) as max_ride_length
from #dec_ride_calculation
where ride_length_minute > '00:03:00'
group by day_of_week
order by count(*) desc


SELECT member_casual, 
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #dec_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY member_casual

SELECT day_of_week, member_casual,
       left(cast(cast(avg(cast(CAST(ride_length_minute as datetime) as float)) as datetime) as time), 8) avg_ride_length
FROM #dec_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week, member_casual
order by day_of_week, member_casual

SELECT day_of_week, count(ride_id) as count_ride_id
FROM #dec_ride_calculation
where ride_length_minute > '00:03:00'
GROUP BY day_of_week
order by day_of_week

--end
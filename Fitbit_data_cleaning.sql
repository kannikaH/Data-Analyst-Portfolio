/****** Script for SelectTopNRows command from SSMS  ******/
/*SELECT*FROM [DataAnalyst].[dbo].[dailyActivity_merged]
select * from [dbo].[dailyIntensities_merged]
  select * from [dbo].[minuteSleep_merged]
*/
--	Check nulls / missing values.
--[dailyActivity_clean]
SELECT *
FROM [DataAnalyst].[dbo].[dailyActivity_merged]
where [Id] IS NULL OR [ActivityDate] IS NULL OR
[TotalSteps]IS NULL OR[TotalDistance] IS NULL OR
[VeryActiveMinutes]IS NULL OR[FairlyActiveMinutes]IS NULL OR
[LightlyActiveMinutes]IS NULL OR
[SedentaryMinutes]IS NULL OR
[Calories]IS NULL

--[minuteSleep_merged]
SELECT * 
FROM [DataAnalyst].[dbo].[minuteSleep_merged]
WHERE ID IS NULL OR[date] IS NULL OR
[value] IS NULL OR[logId] IS NULL

--hourlyIntensities_merged]
SELECT * 
FROM [DataAnalyst].[dbo].[hourlyIntensities_merged]
WHERE  [Id] IS NULL OR
[ActivityHour] IS NULL OR
[TotalIntensity] IS NULL OR
[AverageIntensity] IS NULL

-- Change Data Format table [dailyActivity_clean]
ALTER TABLE [DataAnalyst].[dbo].[dailyActivity_clean]
ALTER COLUMN ActivityDate Date
ALTER TABLE [DataAnalyst].[dbo].[dailyActivity_clean]
ALTER COLUMN [TotalSteps] int
ALTER TABLE [DataAnalyst].[dbo].[dailyActivity_clean]
ALTER COLUMN [TotalDistance] float 
ALTER TABLE [DataAnalyst].[dbo].[dailyActivity_clean]
ALTER COLUMN [Calories] int;
ALTER TABLE [DataAnalyst].[dbo].[dailyActivity_clean]
ALTER COLUMN [VeryActiveMinutes] int
ALTER TABLE [DataAnalyst].[dbo].[dailyActivity_clean]
ALTER COLUMN [FairlyActiveMinutes] int
ALTER TABLE [DataAnalyst].[dbo].[dailyActivity_clean]
ALTER COLUMN [LightlyActiveMinutes] int
ALTER TABLE [DataAnalyst].[dbo].[dailyActivity_clean]
ALTER COLUMN [SedentaryMinutes] int

update [DataAnalyst].[dbo].[dailyActivity_merged]
SET [ActivityDate] = CONVERT(Date,[ActivityDate])

update [DataAnalyst].[dbo].[dailyActivity_clean]
SET [TotalSteps] = CONVERT(int,[TotalSteps])

update [DataAnalyst].[dbo].[dailyActivity_clean]
SET [TotalDistance] = CONVERT(float,[TotalDistance])

update [DataAnalyst].[dbo].[dailyActivity_clean]
SET [VeryActiveMinutes] = CONVERT(int,[VeryActiveMinutes])

update [DataAnalyst].[dbo].[dailyActivity_clean]
SET [FairlyActiveMinutes] = CONVERT(int,[FairlyActiveMinutes])

update [DataAnalyst].[dbo].[dailyActivity_clean]
SET [LightlyActiveMinutes] = CONVERT(int,[LightlyActiveMinutes])

update [DataAnalyst].[dbo].[dailyActivity_clean]
SET [SedentaryMinutes] = CONVERT(int,[SedentaryMinutes])

update [DataAnalyst].[dbo].[dailyActivity_clean]
SET [Calories] = CONVERT(int,[Calories])

-- Change Data Format and insert to table [hourlyIntensities_clean]
SELECT
Id,DATEPART(weekday, ActivityHour) AS dow_number,
case DATEPART(weekday, ActivityHour)       
  When 1 Then 'Sunday'      
  When 2 Then 'Monday'       
  When 3 Then 'Tuesday'       
  When 4 Then 'Wednesday'      
  When 5 Then 'Thursday'       
  When 6 Then 'Friday'       
  When 7 Then 'Saturday'
End 
AS day_of_week,

CASE
WHEN (case DATEPART(weekday, ActivityHour)       
  When 1 Then 'Sunday'      
  When 2 Then 'Monday'       
  When 3 Then 'Tuesday'       
  When 4 Then 'Wednesday'      
  When 5 Then 'Thursday'       
  When 6 Then 'Friday'       
  When 7 Then 'Saturday'
End )

 IN ('Sunday', 'Saturday') THEN
'Weekend'
WHEN (case DATEPART(weekday, ActivityHour)       
  When 1 Then 'Sunday'      
  When 2 Then 'Monday'       
  When 3 Then 'Tuesday'       
  When 4 Then 'Wednesday'      
  When 5 Then 'Thursday'       
  When 6 Then 'Friday'       
  When 7 Then 'Saturday'
End ) NOT IN ('Sunday',
'Saturday') THEN 'Weekday'
ELSE
'ERROR'
END
AS part_of_week,
CASE
WHEN  DATEPART(hour, ActivityHour) BETWEEN 6 AND 11 THEN 'Morning'
WHEN DATEPART(hour, ActivityHour) BETWEEN 12 AND 17 THEN 'Afternoon'
WHEN DATEPART(hour, ActivityHour) BETWEEN 18 AND 21  THEN 'Evening'
WHEN DATEPART(hour, ActivityHour) BETWEEN 22 AND 5 THEN 'Night'
ELSE
'ERROR'
END

AS time_of_day,
SUM(cast(TotalIntensity as int)) AS total_intensity,
SUM(cast(AverageIntensity as float)) AS total_average_intensity,
AVG(cast(AverageIntensity as float)) AS average_intensity,
MAX(cast(AverageIntensity as float)) AS max_intensity,
MIN(cast(AverageIntensity as float)) AS min_intensity

INTO [DataAnalyst].[dbo].[hourlyIntensities_clean]
FROM [DataAnalyst].[dbo].[hourlyIntensities_merged]
GROUP BY Id,DATEPART(weekday, ActivityHour),
CASE
WHEN (case DATEPART(weekday, ActivityHour)       
	  When 1 Then 'Sunday'      
	  When 2 Then 'Monday'       
	  When 3 Then 'Tuesday'       
	  When 4 Then 'Wednesday'      
	  When 5 Then 'Thursday'       
	  When 6 Then 'Friday'       
	  When 7 Then 'Saturday'
	End ) IN ('Sunday', 'Saturday') THEN'Weekend'
WHEN (case DATEPART(weekday, ActivityHour)       
	  When 1 Then 'Sunday'      
	  When 2 Then 'Monday'       
	  When 3 Then 'Tuesday'       
	  When 4 Then 'Wednesday'      
	  When 5 Then 'Thursday'       
	  When 6 Then 'Friday'       
	  When 7 Then 'Saturday'
	End ) NOT IN ('Sunday',
	'Saturday') THEN 'Weekday'
	ELSE
'ERROR'
END
,
case DATEPART(weekday, ActivityHour)       
  When 1 Then 'Sunday'      
  When 2 Then 'Monday'       
  When 3 Then 'Tuesday'       
  When 4 Then 'Wednesday'      
  When 5 Then 'Thursday'       
  When 6 Then 'Friday'       
  When 7 Then 'Saturday'
End ,CASE
WHEN  DATEPART(hour, ActivityHour) BETWEEN 6 AND 11 THEN 'Morning'
WHEN DATEPART(hour, ActivityHour) BETWEEN 12 AND 17 THEN 'Afternoon'
WHEN DATEPART(hour, ActivityHour) BETWEEN 18 AND 21  THEN 'Evening'
WHEN DATEPART(hour, ActivityHour) BETWEEN 22 AND 5 THEN 'Night'
ELSE
'ERROR'
END

-- Change Data Format and insert to table [[minuteSleep_clean]
SELECT Id, sleep_start,sleep_end,
COUNT(logId) AS number_naps,
sum(cast(DATENAME(HOUR, time_sleeping) as int)) AS total_time_sleeping
into [DataAnalyst].[dbo].[[minuteSleep_clean]
FROM (
	SELECT Id, logId,
MIN(cast([date] as date)) AS sleep_start,
MAX(cast([date] as date)) AS sleep_end,
TIMEFROMPARTS(
dateDIFF(HOUR,MIN([date]),MAX([date])),
dateDIFF(MINUTE,MIN([date]),MAX([date]))%60,
(dateDIFF(SECOND,MIN([date]),MAX([date]))%3600)%60,0,0) AS time_sleeping
		FROM [DataAnalyst].[dbo].[minuteSleep_merged]
		GROUP BY
		Id,logId) as a
WHERE sleep_start=sleep_end
GROUP BY Id,sleep_start ,time_sleeping,sleep_end
ORDER BY Id, DATENAME(HOUR, time_sleeping)DESC  
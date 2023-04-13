/****** Script for SelectTopNRows command from SSMS  ******/

-- 1.Find trend between steps and calories
SELECT [Id]
      ,AVG([TotalSteps]) As steps
      ,AVG([Calories]) as calories
  FROM [DataAnalyst].[dbo].[dailyActivity_clean]
  group by [Id]

-- 2.Find the trend level of activity
 SELECT[ActivityDate],
    AVG(cast([SedentaryMinutes] as int))as time_min,
	'sedentary_min' as level_activity
FROM
    [DataAnalyst].[dbo].[dailyActivity_clean]
	group by [ActivityDate]
	
union all

SELECT[ActivityDate],
    AVG(cast(LightlyActiveMinutes as int))as time_min,
	'lightly_active_min' as level_activity
FROM
    [DataAnalyst].[dbo].[dailyActivity_clean]
	group by [ActivityDate]
union all
SELECT[ActivityDate],
    AVG(cast([FairlyActiveMinutes] as int))as time_min,
	'fairly_active_min' as level_activity
FROM
    [DataAnalyst].[dbo].[dailyActivity_clean]
	group by [ActivityDate]
	
union all

SELECT[ActivityDate],
    AVG(cast(VeryActiveMinutes as int))as time_min,
	'Very_active_min' as level_activity
FROM
    [DataAnalyst].[dbo].[dailyActivity_clean]
	group by [ActivityDate]

-- 3.Find data average hour sleep per user
  SELECT  [Id]
   ,avg(total_time_sleeping) as sleep
  FROM [DataAnalyst].[dbo].[minuteSleep_clean]
  group by [Id]
  order by ID
-- 4. minute activity level each day
SELECT  case DATEPART(weekday,[ActivityDate])       
  When 1 Then 'Sunday'      
  When 2 Then 'Monday'       
  When 3 Then 'Tuesday'       
  When 4 Then 'Wednesday'      
  When 5 Then 'Thursday'       
  When 6 Then 'Friday'       
  When 7 Then 'Saturday'
End 
AS part_of_weekm
      
      ,avg([FairlyActiveMinutes]) as [FairlyActiveMinutes]
      ,avg([LightlyActiveMinutes]) as[LightlyActiveMinutes]
      ,avg([SedentaryMinutes]) as[SedentaryMinutes]
	  ,avg([VeryActiveMinutes]) as[SedentaryMinutes]
    
  FROM [DataAnalyst].[dbo].[dailyActivity_clean]
  group by case DATEPART(weekday,[ActivityDate])       
  When 1 Then 'Sunday'      
  When 2 Then 'Monday'       
  When 3 Then 'Tuesday'       
  When 4 Then 'Wednesday'      
  When 5 Then 'Thursday'       
  When 6 Then 'Friday'       
  When 7 Then 'Saturday'
End
 -- 5.Average intensity by time of the day
SELECT [time_of_day]
      ,avg([total_intensity]) as Avg_intensity
FROM [DataAnalyst].[dbo].[hourlyIntensities_clean]
group by[time_of_day]
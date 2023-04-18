
/**   Data cleaning        **/
-- change data type for price column
ALTER TABLE [DataAnalyst].[dbo].[bestsellers with categories]
ALTER COLUMN [Price] int;


 --check Duplicates data
 WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY [Name]
      ,[Author]
      ,[User_Rating]
      ,[Reviews]
      ,[Price]
      ,[Year]
      ,[Genre]
	  ORDER BY [Name]) row_num
  FROM [DataAnalyst].[dbo].[bestsellers with categories]
  )
  Select *
From RowNumCTE
Where row_num > 1
Order by [Name]

-- check if any column have null value
select [Name]
      ,[Author]
      ,[User_Rating]
      ,[Reviews]
      ,[Price]
      ,[Year]
      ,[Genre]
	
  FROM [DataAnalyst].[dbo].[bestsellers with categories]
  where [Name] is null or
      [Author]is null or
      [User_Rating]is null or
      [Reviews]is null or
      [Price]is null or
      [Year]is null or
      [Genre]is null


/**  Data for visualization   **/
--Rating 
 select user_rating,[Year],
  count([Name]) as total
  FROM [DataAnalyst].[dbo].[bestsellers with categories]
  group by user_rating,[Year]

-- top 10 reviews each year by books name
select *
from( 
	SELECT RANK() OVER(PARTITION BY [Year] ORDER BY [Reviews] DESC) as Rank,[Name]
     ,[Reviews],[Year]
	FROM [DataAnalyst].[dbo].[bestsellers with categories]) R
	where Rank <11

-- best selling by [Genre]
SELECT count([Name]) total_books,[Year],[Genre]
FROM [DataAnalyst].[dbo].[bestsellers with categories]
group by [Year],[Genre]

-- top 10 reviews each year by Author name (no duplicate Author)
drop table [DataAnalyst].[dbo].[topAuthor]
	select * 
	into [DataAnalyst].[dbo].[topAuthor]
	from(
		SELECT  [Author]
		 ,[Reviews],[Year],RANK() OVER(PARTITION BY [Author],[Year] ORDER BY [Reviews] DESC) as r
		FROM [DataAnalyst].[dbo].[bestsellers with categories]
	 ) a
	where r=1

	select *
	from( 
		SELECT [Author]
		 ,[Reviews],[Year],RANK() OVER(PARTITION BY [Year] ORDER BY [Reviews] DESC) as Rank
		from [DataAnalyst].[dbo].[topAuthor]) R
	where Rank <11 


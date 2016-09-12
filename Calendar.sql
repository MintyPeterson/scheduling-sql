GO
--
-- DESCRIPTION
--   Creates a calendar table.
--
-- PARAMETERS
--   @Start
--     * The date the calendar table starts.
--   @End
--     * The date the calendar table ends.
--
GO

DECLARE @Start AS date = DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) - 15, 0);
DECLARE @End AS date = DATEADD(YEAR, 30, @Start);

CREATE TABLE [Calendar] (
  [CalendarID] bigint NOT NULL IDENTITY(1, 1) PRIMARY KEY
 ,[Date] date NOT NULL
 ,[Year] smallint NOT NULL
 ,[Month] smallint NOT NULL
 ,[Day] smallint NOT NULL
 ,[DayOfWeek] tinyint NOT NULL
 ,[DayFlag] tinyint NOT NULL
 ,[DayName] varchar(10) NOT NULL
 ,[MonthName] varchar(10) NOT NULL
 ,[OccurrenceOfDayInMonthFlag] tinyint NOT NULL
 ,[IsLastOccurrenceOfDayInMonth] bit NOT NULL
 ,[DayOfYear] smallint NOT NULL
 ,[Quarter] tinyint NOT NULL
 ,[FirstDayOfMonth] date NOT NULL
 ,[LastDayOfMonth] date NOT NULL
 ,[StartDateTime] datetime NOT NULL
 ,[EndDateTime] datetime NOT NULL
)
;

WHILE @Start < @End
BEGIN
  INSERT INTO [Calendar] (
    [Date]
   ,[Year]
   ,[Month]
   ,[Day]
   ,[DayOfWeek]
   ,[DayFlag]
   ,[DayName]
   ,[MonthName]
   ,[OccurrenceOfDayInMonthFlag]
   ,[IsLastOccurrenceOfDayInMonth]
   ,[DayOfYear]
   ,[Quarter]
   ,[FirstDayOfMonth]
   ,[LastDayOfMonth]
   ,[StartDateTime]
   ,[EndDateTime]
  )
  VALUES (
    @Start
   ,YEAR(@Start)
   ,MONTH(@Start)
   ,DAY(@Start)
   ,DATEPART(WEEKDAY, @Start)
   ,CASE WHEN DATEPART(WEEKDAY, @Start) <= 2 THEN
      DATEPART(WEEKDAY, @Start)
    ELSE
      POWER(2, DATEPART(WEEKDAY, @Start) - 1)
    END
   ,DATENAME(WEEKDAY, @Start)
   ,DATENAME(MONTH, @Start)
   ,CASE
      WHEN DAY(@Start) < 8 THEN
        1
      WHEN DAY(@Start) < 15 THEN
        2
      WHEN DAY(@Start) < 22 THEN
        4
      WHEN DAY(@Start) < 29 THEN
        8
      ELSE
        16
    END
   ,CASE
      WHEN
        DATEDIFF(
          DAY
         ,@Start
         ,DATEADD(
            DAY
           ,-(DAY(DATEADD(MONTH, 1, @Start)))
           ,DATEADD(MONTH, 1, @Start)
          )
        ) < 7
      THEN
        1
      ELSE
        0
    END
   ,DATEPART(DAYOFYEAR, @Start)
   ,DATEPART(QUARTER, @Start)
   ,DATEADD(DAY, -(DAY(@Start) - 1), @Start)
   ,DATEADD(DAY, -(DAY(DATEADD(MONTH, 1, @Start))),DATEADD(MONTH, 1, @Start))
   ,CAST(@Start AS datetime)
   ,DATEADD(SECOND, -1, CAST(DATEADD(DAY, 1, @Start) AS datetime))
  )
  SET @Start = DATEADD(DAY, 1, @Start)
END

GO

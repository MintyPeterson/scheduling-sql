GO
--
-- DESCRIPTION
--   Creates a view which calculates occurrences of an event given a table of
--   schedules (and a calendar table).
--
GO

CREATE VIEW [Occurrences]
AS
SELECT
  NEWID() AS [OccurrenceID]
 ,*
FROM (
  -- One-time.
  SELECT
    [Schedules].[ScheduleID]
   ,[Calendar].[Date]
  FROM
    [Calendar]
  INNER JOIN
    [Schedules]
      ON
        [Schedules].[IsEnabled] = 1
          AND
            [Schedules].[FrequencyType] = 1
          AND
            [Schedules].[StartDate] = [Calendar].[Date]
  -- Daily.
  UNION ALL
  SELECT
    [Schedules].[ScheduleID]
   ,[Calendar].[Date]
  FROM
    [Calendar]
  INNER JOIN
    [Schedules]
      ON
        [Schedules].[IsEnabled] = 1
          AND
            [Schedules].[FrequencyType] = 4
          AND
            [Calendar].[Date] >= [Schedules].[StartDate]
          AND (
            [Schedules].[EndDate] IS NULL
              OR
                [Calendar].[Date] <= [Schedules].[EndDate]
          )
          AND (
            [Schedules].[FrequencyInterval] = 0
              OR (
                DATEDIFF(DAY, [Schedules].[StartDate], [Calendar].[Date]) % [Schedules].[FrequencyInterval] = 0
              )
          )
  -- Weekly.
  UNION ALL
  SELECT
    [Ranked].[ScheduleID]
   ,[Ranked].[Date]
  FROM (
    SELECT
      [Schedules].[ScheduleID]
     ,[Calendar].[Date]
     ,RANK() OVER (
        PARTITION BY
          [Schedules].[ScheduleID]
         ,[Calendar].[DayFlag]
        ORDER BY
          [Calendar].[Date]
      ) - 1 [Rank]
     ,[Schedules].[FrequencyRecurrenceFactor]
    FROM
      [Calendar]
    INNER JOIN
      [Schedules]
        ON
          [Schedules].[IsEnabled] = 1
            AND
              [Schedules].[FrequencyType] = 8
            AND
              ([Calendar].[DayFlag] | [Schedules].[FrequencyInterval]) = [Schedules].[FrequencyInterval]
    WHERE
      [Calendar].[Date] >= [Schedules].[StartDate]
        AND (
          [Schedules].[EndDate] IS NULL
            OR
              [Calendar].[Date] <= [Schedules].[EndDate]
        )
  ) [Ranked]
  WHERE
    [Ranked].[FrequencyRecurrenceFactor] = 0
      OR (
        [Ranked].[Rank] % [Ranked].[FrequencyRecurrenceFactor] = 0
      )
  -- Monthly.
  UNION ALL
  SELECT
    [Ranked].[ScheduleID]
   ,[Ranked].[Date]
  FROM (
    SELECT
      [Schedules].[ScheduleID]
     ,[Calendar].[Date]
     ,RANK() OVER (
        PARTITION BY
          [Schedules].[ScheduleID]
        ORDER BY
          [Calendar].[Year]
         ,[Calendar].[Month]
      ) - 1 [Rank]
     ,[Schedules].[FrequencyRecurrenceFactor]
    FROM
      [Calendar]
    INNER JOIN
      [Schedules]
        ON
          [Schedules].[IsEnabled] = 1
            AND
              [Schedules].[FrequencyType] = 16
            AND
              [Calendar].[Date] >= [Schedules].[StartDate]
            AND (
              [Schedules].[EndDate] IS NULL
                OR
                  [Calendar].[Date] <= [Schedules].[EndDate]
            )
            AND
              [Schedules].[FrequencyInterval] = [Calendar].[Day]
  ) [Ranked]
  WHERE
    [Ranked].[FrequencyRecurrenceFactor] = 0
      OR (
        [Ranked].[Rank] % [Ranked].[FrequencyRecurrenceFactor] = 0
      )
  UNION ALL
  -- Monthly (relative).
  SELECT
    [Ranked].[ScheduleID]
   ,[Ranked].[Date]
  FROM (
    SELECT
      [Schedules].[ScheduleID]
     ,[Calendar].[Date]
     ,DENSE_RANK() OVER (
        PARTITION BY
          [Schedules].[ScheduleID]
        ORDER BY
          [Calendar].[Year]
         ,[Calendar].[Month]
      ) - 1 [Rank]
     ,[Schedules].[FrequencyRecurrenceFactor]
    FROM
      [Calendar]
    INNER JOIN
      [Schedules]
        ON
          [Schedules].[IsEnabled] = 1
            AND
              [Schedules].[FrequencyType] = 32
            AND
              [Calendar].[Date] >= [Schedules].[StartDate]
            AND (
              [Schedules].[EndDate] IS NULL
                OR
                  [Calendar].[Date] <= [Schedules].[EndDate]
            )
            AND
              ([Calendar].[DayFlag] | [Schedules].[FrequencyInterval]) = [Schedules].[FrequencyInterval]
            AND (
              ([Calendar].[OccurrenceOfDayInMonthFlag] | [Schedules].[FrequencyRelativeInterval]) = [Schedules].[FrequencyRelativeInterval]
                OR
                  ((16 | [Schedules].[FrequencyRelativeInterval]) = [Schedules].[FrequencyRelativeInterval]
                    AND
                      [Calendar].[IsLastOccurrenceOfDayInMonth] = 1)
            )
  ) [Ranked]
  WHERE
    [Ranked].[FrequencyRecurrenceFactor] = 0
      OR (
        [Ranked].[Rank] % [Ranked].[FrequencyRecurrenceFactor] = 0
      )
) [Occurrences]
;

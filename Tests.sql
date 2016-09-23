GO
--
-- DESCRIPTION
--   Inserts test data into the schedules table and checks the occurrence view
--   contains the expected data. This script assumes the calendar table covers
--   the test data.
--
GO

-- Don't run the tests if the schedules table isn't empty.
IF EXISTS (SELECT * FROM [Schedules])
  BEGIN
    RAISERROR('The schedules table is not empty.', 11, 1);
    RETURN;
  END

-- Set up the expected data.
CREATE TABLE [#Expected] (
  [ScheduleID] smallint
 ,[Date] date
)
;
INSERT INTO [#Expected] (
  [ScheduleID]
 ,[Date]
)
VALUES
  (06, '2016-10-01')
 ,(07, '2016-10-01')
 ,(07, '2016-10-02')
 ,(07, '2016-10-03')
 ,(07, '2016-10-04')
 ,(07, '2016-10-05')
 ,(08, '2016-10-01')
 ,(08, '2016-10-02')
 ,(08, '2016-10-03')
 ,(08, '2016-10-04')
 ,(08, '2016-10-05')
 ,(09, '2016-10-01')
 ,(09, '2016-10-03')
 ,(09, '2016-10-05')
 ,(09, '2016-10-07')
 ,(09, '2016-10-09')
 ,(10, '2016-10-01')
 ,(10, '2016-10-15')
 ,(10, '2016-10-29')
 ,(11, '2016-10-04')
 ,(11, '2016-10-11')
 ,(11, '2016-10-18')
 ,(11, '2016-10-25')
 ,(11, '2016-11-01')
 ,(12, '2016-10-04')
 ,(12, '2016-10-11')
 ,(12, '2016-10-18')
 ,(12, '2016-10-25')
 ,(12, '2016-11-01')
 ,(13, '2016-10-02')
 ,(13, '2016-10-03')
 ,(13, '2016-10-09')
 ,(13, '2016-10-10')
 ,(13, '2016-10-16')
 ,(14, '2016-10-02')
 ,(14, '2016-10-03')
 ,(14, '2016-10-09')
 ,(14, '2016-10-10')
 ,(14, '2016-10-16')
 ,(15, '2016-10-05')
 ,(15, '2016-10-19')
 ,(16, '2016-10-06')
 ,(16, '2016-12-01')
 ,(17, '2016-10-01')
 ,(17, '2016-10-02')
 ,(17, '2016-10-03')
 ,(17, '2016-10-04')
 ,(17, '2016-10-05')
 ,(18, '2016-10-02')
 ,(18, '2016-11-02')
 ,(18, '2016-12-02')
 ,(19, '2016-10-02')
 ,(19, '2016-11-02')
 ,(19, '2016-12-02')
 ,(20, '2016-10-10')
 ,(20, '2016-12-10')
 ,(20, '2017-02-10')
 ,(20, '2017-04-10')
 ,(21, '2016-10-04')
 ,(21, '2016-11-01')
 ,(21, '2016-12-06')
 ,(21, '2017-01-03')
 ,(21, '2017-02-07')
 ,(22, '2016-10-04')
 ,(22, '2016-11-01')
 ,(22, '2016-12-06')
 ,(22, '2017-01-03')
 ,(22, '2017-02-07')
 ,(23, '2016-10-12')
 ,(23, '2016-12-14')
 ,(23, '2017-02-08')
 ,(24, '2016-10-30')
 ,(24, '2016-11-27')
 ,(24, '2016-12-25')
 ,(24, '2017-01-29')
 ,(24, '2017-02-26')
 ,(25, '2016-10-17')
 ,(25, '2016-10-19')
 ,(25, '2016-10-21')
 ,(25, '2016-10-26')
 ,(25, '2016-10-28')
 ,(25, '2016-10-31')
 ,(25, '2016-12-16')
 ,(25, '2016-12-19')
 ,(25, '2016-12-21')
 ,(25, '2016-12-26')
 ,(25, '2016-12-28')
 ,(25, '2016-12-30')
 ,(25, '2017-02-15')
 ,(25, '2017-02-17')
 ,(25, '2017-02-20')
 ,(25, '2017-02-22')
 ,(25, '2017-02-24')
 ,(25, '2017-02-27')
 ,(26, '2016-10-01')
 ,(26, '2016-10-02')
 ,(26, '2016-10-03')
 ,(26, '2016-10-04')
 ,(26, '2016-10-05')
;

-- Start.
SET IDENTITY_INSERT [Schedules] ON;

INSERT INTO [Schedules] (
   [ScheduleID]
  ,[IsEnabled]
  ,[StartDate]
  ,[EndDate]
  ,[FrequencyType]
  ,[FrequencyInterval]
  ,[FrequencyRelativeInterval]
  ,[FrequencyRecurrenceFactor]
)
VALUES
  -- Disabled.
  (01, 0, '2016-10-01', NULL, 01, 0, 0, 0)
 ,(02, 0, '2016-10-01', NULL, 04, 0, 0, 0)
 ,(03, 0, '2016-10-01', NULL, 08, 0, 0, 0)
 ,(04, 0, '2016-10-01', NULL, 16, 0, 0, 0)
 ,(05, 0, '2016-10-01', NULL, 32, 0, 0, 0)
 -- Enabled.
 ,(06, 1, '2016-10-01', NULL, 1, 0, 0, 0)             -- One-time.
 ,(07, 1, '2016-10-01', '2016-10-05', 04, 000, 00, 0) -- Every day (implicit).
 ,(08, 1, '2016-10-01', '2016-10-05', 04, 001, 00, 0) -- Every day (explicit).
 ,(09, 1, '2016-10-01', '2016-10-10', 04, 002, 00, 0) -- Every 2 days.
 ,(10, 1, '2016-10-01', '2016-11-01', 04, 014, 00, 0) -- Every 14 days.
 ,(11, 1, '2016-10-01', '2016-11-01', 08, 004, 00, 0) -- Every Tuesday every week (implicit).
 ,(12, 1, '2016-10-01', '2016-11-01', 08, 004, 00, 1) -- Every Tuesday every week (explicit).
 ,(13, 1, '2016-10-01', '2016-10-16', 08, 003, 00, 0) -- Every Sunday and Monday every week (implicit).
 ,(14, 1, '2016-10-01', '2016-10-16', 08, 003, 00, 1) -- Every Sunday and Monday every week (explicit).
 ,(15, 1, '2016-10-01', '2016-11-01', 08, 008, 00, 2) -- Every Wednesday every 2 weeks.
 ,(16, 1, '2016-10-01', '2017-01-01', 08, 016, 00, 8) -- Every Thursday every 8 weeks.
 ,(17, 1, '2016-10-01', '2016-10-05', 08, 127, 00, 1) -- Every day every week.
 ,(18, 1, '2016-10-01', '2017-01-01', 16, 002, 00, 0) -- Every 2nd day of every month (implicit).
 ,(19, 1, '2016-10-01', '2017-01-01', 16, 002, 00, 1) -- Every 2nd day of every month (explicit).
 ,(20, 1, '2016-10-01', '2017-06-01', 16, 010, 00, 2) -- Every 10th day every 2 momnths.
 ,(21, 1, '2016-10-01', '2017-03-01', 32, 004, 01, 0) -- Every first Tuesday every month (implicit).
 ,(22, 1, '2016-10-01', '2017-03-01', 32, 004, 01, 1) -- Every first Tuesday every month (explicit).
 ,(23, 1, '2016-10-01', '2017-03-01', 32, 008, 02, 2) -- Every second Wednesday every 2 months.
 ,(24, 1, '2016-10-01', '2017-03-01', 32, 001, 16, 1) -- Every last Sunday every month.
 ,(25, 1, '2016-10-01', '2017-03-01', 32, 042, 20, 2) -- Every third and last Monday, Wednesday, and Friday every 2 months.
 ,(26, 1, '2016-10-01', '2016-10-05', 32, 127, 31, 1) -- Every day every week every month.
;

SET IDENTITY_INSERT [Schedules] OFF;

-- The results.
SELECT
  [Schedules].[ScheduleID]
 ,CASE WHEN [Failures].[ScheduleID] IS NULL THEN
    'Passed'
  ELSE
    'Failed ('
      + CAST([Failures].[NumberOfFailures] AS nvarchar(MAX))
      + ' incorrect/missing dates)'
  END [Status]
FROM
  [Schedules]
LEFT OUTER JOIN (
  SELECT
    [Failures].[ScheduleID]
   ,COUNT(1) [NumberOfFailures]
  FROM (
    SELECT
      ISNULL([#Expected].[ScheduleID], [Occurrences].[ScheduleID])
        [ScheduleID]
    FROM
      [#Expected]
    FULL OUTER JOIN
      [Occurrences]
        ON
          [#Expected].[ScheduleID] = [Occurrences].[ScheduleID]
            AND
              [#Expected].[Date] = [Occurrences].[Date]
    WHERE
       [Occurrences].[ScheduleID] IS NULL
         OR
           [#Expected].[ScheduleID] IS NULL
  ) [Failures]
  GROUP BY
    [Failures].[ScheduleID]
) [Failures]
  ON
    [Failures].[ScheduleID] = [Schedules].[ScheduleID]
;

-- Clean-up.
DROP TABLE
  [#Expected]
;
DELETE FROM
  [Schedules]
;

GO
--
-- DESCRIPTION
--   Creates a schedule table.
--   It follows a similar format to msdb.dbo.sysschedules.
--
GO

CREATE TABLE [Schedules] (
	[ScheduleID] bigint NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	[IsEnabled] bit NOT NULL,
	[StartDate] date NOT NULL,
	[EndDate] date,
	[FrequencyType] smallint NOT NULL,
	[FrequencyInterval] smallint NOT NULL,
	[FrequencyRelativeInterval] smallint NOT NULL,
	[FrequencyRecurrenceFactor] smallint NOT NULL
)
;

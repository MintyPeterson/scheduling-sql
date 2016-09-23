##Scheduling SQL
A set of T-SQL scripts for event date scheduling.
###Contents
* **Calendar.sql** - Creates a calendar table for simplifying complex date calculations.
* **Schedules.sql** - Creates a schedule table (similar to msdb.dbo.sysschedules) for storing schedule information.
* **Occurrences.sql** - Create a view which lists dates on which a schedule occurs.
* **Tests.sql** - Tests that the occurrences view contains expected data given a set of test schedules.

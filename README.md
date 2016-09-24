##Scheduling SQL
A set of T-SQL scripts for event date scheduling.

###Usage
1. Create a calendar table using *Calendar.sql*.
2. Create a schedules table using *Schedules.sql*.
3. Create an occurrences view using *Occurrences.sql*.
4. Test that the occurrences view contains expected data using *Tests.sql*.

####Schedules table layout
The schedules table follows a similar format to [msdb.dbo.sysschedules](https://msdn.microsoft.com/en-us/library/ms178644.aspx):

| Column name               | Description                                             |
|---------------------------|---------------------------------------------------------|
| `ScheduleID`                | The identification number (and primary key).          |
| `IsEnabled`                 | A value indicating if the schedule is enabled or not. |
| `StartDate`                 | The start date.                                       |
| `EndDate`                   | The end date (optional†).                             |
| `FrequencyType`             | Determines how frequently the schedule runs.          |
| `FrequencyInterval`         | The days or day of month the schedule runs on.        |
| `FrequencyRelativeInterval` | The week of the month the schedule runs on.           |
| `FrequencyRecurrenceFactor` | The number of weeks or months between recurrences.    |

† If the end date is `NULL`, the occurrence view will display data as far as the end of the calendar table.

####Supported frequency types

| Name               | Type | 
|--------------------|------|
| One-time           | 1    |
| Daily              | 4    |
| Weekly             | 8    |
| Monthly            | 16   | 
| Monthly (relative) | 32   |

#####One-time
The `FrequencyInterval`, `FrequencyRelativeInterval`, and `FrequencyRecurrenceFactor` columns are not used.

#####Daily
The `FrequencyInterval` column specifies the number of days between each occurrence. The `FrequencyRelativeInterval` and `FrequencyRecurrenceFactor` columns are not used.

#####Weekly
The `FrequencyInterval` column is a bitfield specifying the days of the week on which the schedule occurs.

* 1 = Sunday
* 2 = Monday
* 4 = Tuesday
* 8 = Wednesday
* 16 = Thursday
* 32 = Friday
* 64 = Saturday

The `FrequencyRelativeInterval` column is not used. The `FrequencyRecurrenceFactor` specifies the number of weeks between each occurrence.

#####Monthly
The `FrequencyInterval` column specifies the day of the month on which the schedule occurs. The `FrequencyRelativeInterval` column is not used. The `FrequencyRecurrenceFactor` specifies the number of months between each occurrence.

#####Monthly (relative)
The `FrequencyInterval` column is a bitfield specifying the days of the week on which the schedule occurs.

* 1 = Sunday
* 2 = Monday
* 4 = Tuesday
* 8 = Wednesday
* 16 = Thursday
* 32 = Friday
* 64 = Saturday

The `FrequencyRelativeInterval` column is a bitfield specifying the weeks of the month on which the schedule occurs.

* 1 = First week
* 2 = Second week
* 4 = Third week
* 8 = Fourth week
* 16 = Last week

The `FrequencyRecurrenceFactor` specifies the number of months between each occurrence.

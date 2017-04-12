# Alert_logfile_Table_Detail
A simple tool written in Unix for getting the backend impacted tables names from the db by getting the details from Hibernate queries in Apache Tomcat log files.It will send a email alert with the table name details affected for particular operation performed in front end application UI where the tomcat servers points.


Requirement
--------------------------------
Unix server

Apache tomcat log file server

### Run

Run the unix script in the unix server where the actual Apache tomcat log files are placed.
```
sh Alert_logfile_Table_detail.sh

```
Configure
---------------------------------

There are some configurations that you can modify at the top of `Alert_logfile_Table_detail.sh`like from and to mail ids to whom we need to send the mail and actual file and path name for log files.

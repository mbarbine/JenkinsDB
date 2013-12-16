SUMMARY: 

FIRST GO INTO THE SQL FOLDER AND RUN THE QUERIES AGAINST YOUR SQL SERVER. 

INSTALL STEPS: 

Execute the table queries first (order of execution is indicated by a prefixed numer (1), (2), etc.) 
THEN execute the view queries 
THEN execute the stored procedure queries
THEN create the agent jobs 




THEN GO INTO THE Scripts/Files and Tasks folder: 





Create the directory structure for the working directory. You'll want to put everything in E:\XML\Builds\*. If you change this path you'll
have to change a number of other scripts. 

Import the scheduled task into windows. This task is called from a SQL Agent job. 



NOTES: 




it is absolutely critical that you line up the SQL service account with the account that is executing the task scheduler and that 
the account has the appopriate privileges. 

I've listed instructions in each folder of what to change to get this to work in your environment. 

If you have any questions or comments please email Barbine.Michael@Gmail.com 


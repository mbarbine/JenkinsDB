Execute the table queries first (order of execution is indicated by a prefixed numer (1), (2), etc.) 
THEN execute the view queries 
THEN execute the stored procedure queries
THEN create the agent jobs 

it is absolutely critical that you line up the SQL service accoun with the account that is executing the task scheduler and that 
the account has the appopriate privileges. 

I've listed instructions in each folder of what to change to get this to work in your environment. 


If you have any questions or comments please email Barbine.Michael@Gmail.com 


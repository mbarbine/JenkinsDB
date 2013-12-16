SUMMARY: 

Create the stored procedures under a database called "Jenkins"
You may get some errors here if the tables/queries are not created yet. 


CONFIGURATION CHANGES: 


USP_CREATE_JOB_DATA: 

LINE 25: Replace <Servername> with the full qualified servername of the Jenkins server (Jenkins.xyz.com) 
LINE 27 (OPTIONAL): If you changed the path to the .XML files then you must update this line 
LINE 172 - 208 (OPTIONAL): This is where you can Add/Remove fields and customize what is pulled in 


USP_CREATEPROJECTS:

No Changes Required 

USP_CREATEWORKLOAD

LINE 16: If you changed the path of the XML/Scripts then you must update this line 

USP_JENKINS_XML_REVIEW: 

LINE 28: Replace <Servername> with the FQDN of your Jenkins server 

USP_WORKLOAD: 

No Changes Required 


DEFINE XPath org.apache.pig.piggybank.evaluation.xml.XPath();

--Full dataset
XML = LOAD 'hdfs://cm:9000/uhadoop2020/g19/Users.xml' using org.apache.pig.piggybank.storage.XMLLoader('row') as (x:chararray);

--sample
--XML = LOAD '/data/2020/uhadoop/g19/Users100.xml' using org.apache.pig.piggybank.storage.XMLLoader('row') AS (x:chararray);

--extract each attribute from xml
UsersCharArray = FOREACH XML GENERATE XPath(x, '/row/@Id') AS Id, XPath(x, '/row/@CreationDate') AS CreationDate, XPath(x, '/row/@LastAccessDate') as LastAccessDate;
--extract year from creation date and last acces date as a substring
Users = FOREACH UsersCharArray GENERATE Id,  SUBSTRING(CreationDate, 0, 4) AS CreationYear, SUBSTRING(LastAccessDate, 0 ,4) AS LastAccessYear;

--We will consider "inactive" users who haven't logged into their account in the current year(2020)
InactiveUsers = FILTER Users BY LastAccessYear < '2020';

--Group inactive users and all users by creation year
InactiveUsers_grouped_by_year =  GROUP InactiveUsers BY CreationYear;
Users_grouped_by_year = GROUP Users BY CreationYear;

--Count users and inactive users by creation year
UsersByYear = FOREACH Users_grouped_by_year GENERATE group, COUNT(Users.Id);
InactiveUsersByYear = FOREACH InactiveUsers_grouped_by_year GENERATE group, COUNT(InactiveUsers.Id);

--Store the results
STORE UsersByYear INTO '/uhadoop2020/g19/results/UsersByYear/';
STORE InactiveUsersByYear INTO '/uhadoop2020/g19/results/InactiveUsersByYear/';
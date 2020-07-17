DEFINE XPath org.apache.pig.piggybank.evaluation.xml.XPath();
--Full dataset
XML = LOAD 'hdfs://cm:9000/uhadoop2020/g19/Users.xml' using org.apache.pig.piggybank.storage.XMLLoader('row') as (x:chararray);

--We Define The Columns
UsersCharArray = FOREACH XML GENERATE XPath(x, '/row/@Reputation') AS Reputation:long,XPath(x, '/row/@DisplayName') AS DisplayName,XPath(x, '/row/@Location') AS Location , XPath(x, '/row/@AccountId') AS AccountId;

--Group Users Per Location
UsersGrouped= GROUP UsersCharArray BY Location;
--We Count Users Per Location 
UsersPerCountry = FOREACH UsersGrouped GENERATE COUNT($1) as Count, group AS Location;

--And We Order Users by Cout DESC 
Ordered_Top_Location = ORDER UsersPerCountry BY Count DESC;
--Store The Results
STORE Ordered_Top_Location INTO '/uhadoop2020/g19/results/OrderedTopLocationFinal/';
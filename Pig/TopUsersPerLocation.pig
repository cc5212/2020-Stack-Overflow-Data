--Top Users Per Location

DEFINE XPath org.apache.pig.piggybank.evaluation.xml.XPath();
--Full dataset
XML = LOAD 'hdfs://cm:9000/uhadoop2020/g19/Users.xml' using org.apache.pig.piggybank.storage.XMLLoader('row') as (x:chararray);

--sample
--XML = LOAD 'hdfs://cm:9000/uhadoop2020/g19/Users100.xml' using org.apache.pig.piggybank.storage.XMLLoader('row') AS (x:chararray);


UsersCharArray = FOREACH XML GENERATE XPath(x, '/row/@Reputation') AS Reputation,XPath(x, '/row/@DisplayName') AS DisplayName,XPath(x, '/row/@Location') AS Location , XPath(x, '/row/@AccountId') AS AccountId;

UperLocation = FILTER UsersCharArray BY Location=='United States';

LocationUsers = FOREACH UperLocation GENERATE Reputation, DisplayName, Location;

TopUsers= ORDER LocationUsers BY Reputation DESC;


--Store the results
STORE TopUsers INTO '/uhadoop2020/g19/results/TopUsersFinal/';
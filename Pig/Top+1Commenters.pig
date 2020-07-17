-- Filter the top 20 users with more +1 comments on StackOverflow, with their respective counter.

-- Load XML
DEFINE XPath org.apache.pig.piggybank.evaluation.xml.XPath();
comments_xml = LOAD 'hdfs://cm:9000/uhadoop2020/g19/Comments.xml' USING org.apache.pig.piggybank.storage.XMLLoader('row') AS (x:chararray);
users_xml = LOAD 'hdfs://cm:9000/uhadoop2020/g19/Users.xml' USING org.apache.pig.piggybank.storage.XMLLoader('row') AS (x:chararray);

-- Generate comments with columns id, text, user_id
comments = FOREACH comments_xml GENERATE XPath(x, '/row/@Id') AS id, XPath(x, '/row/@Text') AS text, XPath(x, '/row/@UserId') AS user_id;

-- Generate users with columns uid, display_name
users = FOREACH users_xml GENERATE XPath(x, '/row/@Id') AS uid, XPath(x, '/row/@DisplayName') AS display_name;

-- Filter comments that starts with +1
comments_filtered = FILTER comments BY STARTSWITH(text, '+1');

-- Group comments_filtered by user_id
comments_grouped_by_user = GROUP comments_filtered BY user_id;

-- Count comments for each user_id
comments_count = FOREACH comments_grouped_by_user GENERATE COUNT($1) AS counter, group AS user_id;

-- Join users and comments_count
comments_per_user = JOIN comments_count BY user_id, users BY uid;

-- Order 
ordered_comments_per_user = ORDER comments_per_user BY counter DESC;

-- Top 20
top_commenters = LIMIT ordered_comments_per_user 20;

-- Generate results with user_name and counter
results = FOREACH top_commenters GENERATE users::display_name AS user_name, comments_count::counter AS counter;

-- Store results
STORE results INTO '/uhadoop2020/g19/Top+1Commenters/';

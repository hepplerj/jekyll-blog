--- 
wordpress_id: 180
layout: post
title: "Snippet: Basic Database Connection and Query"
excerpt: A snipped of code for a basic connection and display of a MySQL database using PHP.
date: 2010-07-14 21:53:16 -05:00
wordpress_url: http://www.jasonheppler.org/?p=180
tags: Database
---
Basic setup for database connection, querying, and returning results.
<pre lang="php"><!--?php
define ('HOSTNAME', 'localhost');
define ('USERNAME', 'username');
define ('PASSWORD', 'password');
define ('DATABASE_NAME', 'database');

$db = mysql_connect(HOSTNAME, USERNAME, PASSWORD) or die ('I cannot connect to MySQL.');

mysql_select_db(DATABASE_NAME);

$query = "SELECT * FROM author ORDER by `last_name`";
$result = mysql_query($query);
while ($row = mysql_fetch_array($result)) {
echo "

" , ($row['first_name']) , ($row['last_name']) , "

";
}

mysql_free_result($result);
mysql_close();
?--></pre>

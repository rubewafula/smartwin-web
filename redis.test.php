<?php 
   //Connecting to Redis server on localhost 
   $redis = new Redis(); 
   $redis->connect('cache0', 6379); 
   echo "Connection to server sucessfully"; 
   //check whether server is running or not 
   $redis->auth('iFz91Cwqk5D8');
   echo "Server is running: ".$redis->ping(); 
?>

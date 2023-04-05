<?php

defined('APP_PATH') || define('APP_PATH', realpath('.'));

$host = gethostname();
$baseUri = '/';

//$connection = array(
//    'adapter' => 'Mysql',
//    'host' => 'bn-db-1',
//    'username' => 'muoki',
//    'password' => 'muoki123',
//    'dbname' => 'smartwin',
//    'charset' => 'utf8'
//);

return new \Phalcon\Config(array(
//    'database' => $connection,
    'application' => array(
        'controllersDir' => APP_PATH . '/app/controllers/',
        'modelsDir'      => APP_PATH . '/app/models/',
        'migrationsDir'  => APP_PATH . '/app/migrations/',
        'viewsDir'       => APP_PATH . '/app/views/',
        'layoutsDir'       => APP_PATH . '/app/views/layouts',
        'pluginsDir'     => APP_PATH . '/app/plugins/',
        'libraryDir'     => APP_PATH . '/app/library/',
        'vendorDir'       => APP_PATH . '/vendor/',
        'cacheDir'       => APP_PATH . '/app/cache/',
        'baseUri'        => $baseUri,
    ),
    'redis' => [
        'prefix' => 'smartwin_',
        'host'   => 'lb',
        'port'   =>  6379,
        'auth'   => 'ef570bd1-3296-4994-8f35-a6c1081a5faa',
        'persistent' => 1,
    ]
));


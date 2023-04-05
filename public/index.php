<?php

$host = gethostname();
if ($host == "pr-web-12") {
    ini_set('session.save_handler', 'file');
    ini_set('session.save_path', '');
}

#error_reporting(E_ALL);
define('APP_PATH', realpath('..'));
try {
    /**
     * Read the configuration
     */
    $config = include __DIR__ . "/../app/config/config.php";

    /**
     * Read auto-loader
     */
    include __DIR__ . "/../app/config/loader.php";

    /**
     * Read services
     */
    include __DIR__ . "/../app/config/services.php";

    // Include 3rd party libraries

    include APP_PATH . "/vendor/autoload.php";

    /**
     * Handle the request
     */
    $di = \Phalcon\DI::getDefault(); 
    $application = new \Phalcon\Mvc\Application($di);
    $request = new Phalcon\Http\Request();
    $response = $application->handle($request->getURI());
    $response->send();



    #$application->setDI($di);
    #echo $application->handle()->getContent();
} catch (Exception $e) {
  #    echo $e->getMessage() . '<br>';
      echo '<pre>' . $e->getTraceAsString() . '</pre>';
 echo print_r($e, 1) . PHP_EOL;
    echo "<head><title>Page Not Found - smartwin.ke</title></head><body style='background-color: #030928;background:url(img/error-cover.jpg)'><link href='https://fonts.googleapis.com/css?family=Montserrat:400,700' rel='stylesheet' type='text/css'><div style='
    max-width: 600px;
    display: block;
    margin: 100px auto;
    text-align: center;
    color: #e0e0e0;
    font-size: 20px;
    font-family: Montserrat, sans-serif;
'>
<a href='https://smartwin.co.ke'><img style='max-width: 180px;' src='img/logo.png' /></a>
<p><b style='font-size: 50px;
    line-height: 60px;
    display: block;'>Sorry</b> <br/>Looks like something went wrong on our end.<br/> Please head back to the Homepage
</p>
    <a href='https://smartwin.co.ke' class='error-404' style='background: #6e2f44; color: #ffffff; border-radius: 10px; padding:5px 15px;'>Home</a>
</div>
</body>";
}

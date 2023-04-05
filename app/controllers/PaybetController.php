<?php

//use Phalcon\Logger\Adapter\File as FileLogger;

class PaybetController extends ControllerBase{
    public function indexAction(){

       // $logger = new FileLogger('/var/www/nginx/smartwin-web/app/storage/log/main.log');
       // $logger->info("Logging OK");

        $betID = $this->request->get('ref', 'int');
        $invoice_amount = (int)$this->request->get('amount');
        $phone_number = $this->request->get('msisdn');

        $payment_method = $this->ssj_get_number_network($phone_number);
        //$logger->info("Logging Payment method ". $payment_method);
        if(is_numeric($betID)){
            $redirectURL = urlencode('http://smartwin.ke/mybets?a=1&id='.$betID);
            $payload = [
                'msisdn'=> $phone_number,
                'amount'=> $invoice_amount,
                'reference'=> $betID,
                'betId'=>$betID,
                'redirectUri'=> $redirectURL,
            ];
            $response = $this->payBet($payload);
            //die(print_r($response, 1));
           // $logger->info("API response " . var_export($response, 1));
            $data = json_decode($response['message'], 1);

           echo "<p> Tafadhali tumia simu yako kukamilisha malipo. Kisha bofya hapa <a href='https://Smartwin.com/mybets?a=1&id=$betID'>Bofya kuendelea </a></p>";
        }
        //	$this->view->disable();
    }
}

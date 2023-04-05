<?php

class VerifyController extends ControllerBase
{

    public function indexAction()
    {
        $title = "Verify account";

        $this->tag->setTitle($title);
    }

    public function checkAction()
    {
    	$mobile = $this->request->get('mobile','int');
    	$verification_code = $this->request->get('verification_code','string');

    	if (!$mobile || !$verification_code) {
            	$this->flashSession->error($this->flashError('All fields are required'));
                $this->response->redirect('verify');

		        // Disable the view to avoid rendering
		        $this->view->disable();
        }else{
                $mobile = $this->formatMobileNumber($mobile);



            $payload =  array("mobile" => $mobile,"code"=>$verification_code);
            list($status,$response) = $this->verifyUser($payload);

//            die(json_encode($response));

            if (array_key_exists('success', $response)){
                $this->flashSession->error($this->flashError($response['success']['message']));
                $this->response->redirect('login');
            }elseif (array_key_exists('error', $response)){
                $this->flashSession->error($this->flashError($response['error']['message']));
                $this->response->redirect('verify');
                $this->view->disable();
            }else{
                $this->flashSession->error($this->flashError('Fatal Error occurred. '.json_encode($response)));
                $this->response->redirect('verify');
                $this->view->disable();
            }
    	}
    }

}


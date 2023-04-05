<?php

class DepositController extends ControllerBase
{
    public function IndexAction() {
      
        $user = $this->session->get('auth');
		if(empty($user['token'])){
            $this->flashSession->error($this->flashError('Kindly login to deposit'));
        	$this->response->redirect('login');
            $this->view->disable();
		}
    }

    public function topupAction()
    {
        $amount = $this->request->getPost('amount', 'int');
        $mobile = $this->request->getPost('msisdn', 'int');

        if ($amount<1) {
            $this->flashSession->error($this->flashError('Sorry, minimum top up amount is Ksh. 1'));
            return $this->response->redirect('deposit');
            $this->view->disable();
        }elseif ($amount>150000) {
            $this->flashSession->error($this->flashError('Sorry, maximum top up amount is KES. 150,000'));
            return $this->response->redirect('deposit');
            $this->view->disable();
        } elseif ($mobile < 1) {
            $this->flashSession->error($this->flashError('Invalid phone number'));
            return $this->response->redirect('deposit');
            $this->view->disable();
        }else{
    
            $push = "msisdn=$mobile&amount=$amount";
        
            $result = $this->topup($push);
            if($result['status_code'] == 200 ) {
                $this->flashSession->success(
                  $this->flashSuccess(preg_replace('/"/', '', $result['message']))
                );
            } else {

                $this->flashSession->error($this->flashSuccess($result['message']));
            }
        
            $this->response->redirect('deposit');
            // Disable the view to avoid rendering
            $this->view->disable();
        }
    }
    
}

?>

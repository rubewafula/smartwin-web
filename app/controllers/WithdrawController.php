<?php

class WithdrawController extends ControllerBase
{
    public function IndexAction() {
    }

    public function withdrawalAction()
    {
        $amount = $this->request->getPost('amount', 'int');

        if ($amount<100) {
           $this->flashSession->error($this->flashError('Sorry, minimum withdraw amount is KSH. 100.'));
            return $this->response->redirect('withdraw');
            $this->view->disable();
        }elseif ($amount>70000) {
            $this->flashSession->error($this->flashError('Sorry, maximum withdraw amount is KSH. 70,000.'));
            return $this->response->redirect('deposit');
            $this->view->disable();
        }else{
                $mobile = $this->session->get('auth')['mobile'];
        
                $data = ['amount'=>$amount,'msisdn'=>$mobile];
        
                $exp=time()+3600;
        
                $token = $this->generateToken($data, $exp);
        
                $transaction = "token=$token";
        
                $withdraw = $this->withdraw($transaction);
                if($withdraw['status_code'] == 200){
                    $this->flashSession->error(
                        $this->flashSuccess($withdraw['response']));
                } else {
                    $this->flashSession->error($this->flashError($withdraw['response']));

                }
                $this->response->redirect('/withdraw');
        
                $this->view->disable();}
    }
    
}

?>

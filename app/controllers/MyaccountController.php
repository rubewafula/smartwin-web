<?php

/**
 * Class MyaccountController
 */
class MyaccountController extends ControllerBase
{
    /**
     *
     */
    public function IndexAction()
    {

        $user = $this->session->get('auth');
		if(empty($user['token'])){
        	$this->response->redirect('index');
			return;
		}


        list($status,$balance) = $this->getBalance();

//		die('Authorization: Bearer '.json_encode($this->session->get('auth')));
//		die(json_encode($balance));


        if ($status == 200){
            $user['balance'] = $balance['user']['balance'];
            $user['bonus'] = $balance['user']['bonus'];
        }

        $this->session->set('auth', $user);

        $this->view->setVars([
            'user' => $user,
        ]);
    }

}

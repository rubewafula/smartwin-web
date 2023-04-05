<?php

class LogoutController extends ControllerBase
{

    public function indexAction()
    {
    	$this->session->destroy();
    	$this->cookies->get('auth')->delete();
        $this->response->redirect('');
        $this->view->disable();
    }

   

}


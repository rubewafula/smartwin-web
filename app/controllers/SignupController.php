<?php

class SignupController extends ControllerBase
{
	public function initialize()
	{
		$this->tag->setTitle('Sign up');
	}

	public function indexAction()
	{

	}

    public function verifyAction()
    {

    }

	public function joinAction(){

		if ($this->request->isPost()) {

			$mobile = $this->request->getPost('mobile', 'int');
			$age = $this->request->getPost('age', 'int');
			$terms = $this->request->getPost('terms', 'int');
			$password = $this->request->getPost('password');
			$repeatPassword = $this->request->getPost('repeatPassword');

            if (!$mobile || !$password || !$repeatPassword || !$age || !$terms ) {
				$this->flashSession->error($this->flashError('All fields are required'));
				$this->response->redirect('signup');

				// Disable the view to avoid rendering
				$this->view->disable();
			}else{

				if ($password != $repeatPassword) {
					$this->flashSession->error($this->flashError('Passwords do not match'));
					$this->response->redirect('signup');

					// Disable the view to avoid rendering
					$this->view->disable();
					return;
				}

				$mobile = $this->formatMobileNumber($mobile);
//				$password = $this->security->hash($password);

				if (!$mobile) {
					$this->flashSession->error($this->flashError('Invalid mobile number'));
					$this->response->redirect('signup');

					// Disable the view to avoid rendering
					$this->view->disable();
				}else{

                    $payload =  array("mobile" => $mobile,"password"=>$password);
                    list($status,$response) = $this->registerNew($payload);

                    //                    die(json_encode($response));
                   $success = $response['success']['status'];

                    if ($success == 201 || $success == 200){
                        $this->flashSession->error($this->flashError($response['success']['message']));
                        $this->response->redirect('login');
                    }elseif ($success == 400){
                        $this->flashSession->error($this->flashError($response['error']['message']));
                        $this->response->redirect("signup");
                        $this->view->disable();
                    }else{
                        $this->flashSession->error($this->flashError('Fatal Error occurred. '.json_encode($response)));
                        $this->response->redirect('signup');
                        $this->view->disable();
                    }


				}
			}
		}
	}

}


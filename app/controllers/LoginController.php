<?php

/**
 * Class LoginController
 */
class LoginController extends ControllerBase
{
    /**
     *
     */
    public function IndexAction()
    {
        $ref = $this->request->get('ref') ?: '';
        $this->view->setVars(['ref' => $ref]);
    }

    /**
     * @return \Phalcon\Http\Response|\Phalcon\Http\ResponseInterface
     */
    public function authenticateAction()
    {
        if ($this->request->isPost()) {
            $mobile = $this->request->getPost('mobile', 'int');
            $remember = $this->request->getPost('remember', 'int') ?: 0;
            $password = $this->request->getPost('password');
            $refURL = $this->request->getPost('ref') ?: '';
            $refU = "login?ref=" . $refURL;

            if (!$mobile || !$password || !preg_match('/^(?:\+?(?:[1-9]{3})|0)?([7,1]([0-9]{8}))$/', $mobile)) {
                $this->flashSession->error($this->flashError('All fields are required'));

                return $this->response->redirect($refU);
                $this->view->disable();
            }


            $mobile = $this->formatMobileNumber($mobile);

            list($stat,$data) = $this->postLogin($mobile, $password);
            if ($stat != 200){

                $this->flashSession->error($data['message'] ?: "");
                $this->response->redirect($refU);
                // Disable the view to avoid rendering
                $this->view->disable();

            }else{

                $device = $this->getDevice();
                $sessionData = [
                    'id' => $data['user']['profile_id'],
                    'remember' => $remember,
                    'mobile'   => $data['user']['msisdn'],
                    'device'   => $device,
                    'token'   => $data['user']['token'],
                    'balance'   => $data['user']['balance'],
                    'bonus' => $data['user']['bonus'],
                ];
                $this->registerAuth($sessionData);
                $this->response->redirect($refURL);

            }


        }
    }

}

?>

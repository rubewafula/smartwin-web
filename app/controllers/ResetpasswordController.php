<?php

class ResetpasswordController extends ControllerBase
{
    public function indexAction()
    {
        $mobile = $this->request->get('mobile', 'string');

        if ($mobile) {
            $this->view->setVars(["msisdn" => $mobile]);
        }

        $this->view->setVars([
            'redirect' => $this->request->get('redirect') ?? 'resetpassword'
        ]);
    }

    public function codeAction()
    {

        $redirectUrl = $this->request->get('redirect') ?? 'resetpassword';

        $mobile = $this->request->getPost('mobile', 'int');

        if (!$mobile) {
            $this->flashSession->error($this->flashError('Please enter your mobile number'));
            $this->response->redirect($redirectUrl);

            $this->view->disable();
        } else {

            $mobile = $this->formatMobileNumber($mobile);


            if ($mobile == false) {
                $this->flashSession->error($this->flashError('Invalid mobile number'));
                $this->response->redirect('resetpassword');

                // Disable the view to avoid rendering
                $this->view->disable();
            } else {

                $payload = array("mobile" => $mobile);
                list($status, $response) = $this->sendCode($payload);
                if (array_key_exists('success', $response)) {
                    $this->flashSession->error($this->flashSuccess($response['success']['message']));
                    $this->response->redirect("$redirectUrl?mobile=$mobile");
                } elseif (array_key_exists('error', $response)) {
                    $this->flashSession->error($this->flashError($response['error']['message']));
                    $this->response->redirect('resetpassword');
                    $this->view->disable();
                } else {
                    $this->flashSession->error($this->flashError(($response['error']['message'] ?? 'Something went wrong')));
                    $this->response->redirect('resetpassword');
                    $this->view->disable();
                }
            }
        }
    }

    public function passwordAction()
    {
        $password = $this->request->getPost('password');
        $repeatPassword = $this->request->getPost('repeatPassword');
        $reset_code = $this->request->getPost('reset_code', 'string');
        $mobile = $this->request->getPost('mobile');


        if (!$password || !$reset_code || !$repeatPassword || !$mobile) {
            $this->flashSession->error($this->flashError('All fields are required'));
            $this->response->redirect("resetpassword?mobile=$mobile");

            // Disable the view to avoid rendering
            $this->view->disable();
        } else {
            if ($password != $repeatPassword) {
                $this->flashSession->error($this->flashError('Passwords do not match'));
                $this->response->redirect("resetpassword?mobile=$mobile");

                // Disable the view to avoid rendering
                $this->view->disable();
            } else {


                $payload = array("mobile" => $mobile, "code" => $reset_code, "password" => $password);
                list($status, $response) = $this->resetPassword($payload);


                if (array_key_exists('success', $response)) {
                    $this->flashSession->error($this->flashSuccess($response['success']['message']));
                    $this->response->redirect('login');
                    // Disable the view to avoid rendering
                    $this->view->disable();
                } elseif (array_key_exists('error', $response)) {
                    $this->flashSession->error($this->flashError($response['error']['message']));
                    $this->response->redirect("resetpassword");
                    $this->view->disable();
                } else {
                    $this->flashSession->error($this->flashError(($response['error']['message'] ?? 'Something went wrong')));
                    $this->response->redirect('resetpassword');
                    $this->view->disable();
                }
            }
        }
    }

}

?>

<?php
/**
 * Copyright (c) Murwa 2018.
 *
 * All rights reserved.
 */

class MybetsController extends ControllerBase
{

	public function indexAction()
	{
		$betID = $this->request->get('id','int');
		$a = $this->request->get('a','int');

		$id = $this->session->get('auth')['id'];
        $title = "My Transactions";
        list($status,$myBets) = $this->getMyBets();
        $this->tag->setTitle($title);
        $this->view->setVars(["myBets"=>$myBets]);
	}

}


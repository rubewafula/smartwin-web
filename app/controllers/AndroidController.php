<?php

/**
 * Copyright (c) Murwa 2018.
 *
 * All rights reserved.
 */
class AndroidController extends ControllerBase
{

    /**
     * Index
     */
    public function indexAction()
    {
        $this->tag->setTitle('Download App');
        $this->view->pick("android/index");

        $this->view->setVars([
            'data' => []
        ]);
    }

    public function downloadAction()
    {
        $path = __DIR__ . "/../../public/smartwin.apk";
        $filesize = filesize($path);
        header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
        header('Content-Description: File Download');
        header('Content-type: application/vnd.android.package-archive or application/octet-stream');
        header('Content-length: ' . $filesize);
        header('Content-Disposition: attachment; filename="' . 'smartwin.apk' . '"');
        readfile($path);
        die();
    }
}


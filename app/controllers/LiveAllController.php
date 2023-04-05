<?php
/**
 * Copyright (c) Anto 2018.
 *
 * All rights reserved.
 */

use Phalcon\Http\Response;

/**
 * Class MatchController
 */
class LiveallController extends ControllerBase
{

    /**
     * Index
     */
    public function indexAction()
    {
        
	$sport_id= $this->request->get('id', 'int')?: 79;




        list($status_code, $liveMatches) = $this->getLiveGames();
        $this->tag->setTitle("Live Games");


        $theBetslip = $this->session->get("betslip");
        $newslip = [];
        $totalOdd = 1;
        foreach($theBetslip as $match_id => $slip){

            if(!empty($liveMatches) &&
                $liveMatches[0]['odd_active'] == 1 && $liveMatches[0]['market_active'] == 'Active'
                && $liveMatches[0]['eactive'] == 1 && $liveMatches[0]['m_active'] == 1){
                $new_odd = $liveMatches[0]['odd_value'];
                $slip['odd_value'] = $new_odd;
                $newslip[$match_id] = $slip;
            }else{
                $slip['odd_value'] = 1;
                $newslip[$match_id] = $slip; 
            }
            $totalOdd *=  $slip['odd_value'];
        }

        $totalOdd = round($totalOdd,2);
        //die(print_r($newslip, 1));
        $theBetslip = $newslip;
        $this->session->set('betslip', $theBetslip);



        $this->view->setVars([
            'liveMatches' => $liveMatches,
            'betslip' => $theBetslip,
            'totalOdd'=>$totalOdd,
        ]);

        $this->view->pick("live/all_live_matches");

    }

}

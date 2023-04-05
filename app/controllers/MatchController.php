<?php

class MatchController extends ControllerBase
{
    public function IndexAction()
    {
        $id = $this->request->get('id', 'int');

        $sports = $this->get_sports_via_cache();

        list($status_code, $results) = $this->getMarkets($id);

		$marketWithOdds = $results['data']['data']['odds'];

        $matchInfo = $results['data']['data']['match'];


        $current_sport = [];
        foreach($sports as  $sp){
            if($sp['sport_name'] == $matchInfo['sport_name']){
                $current_sport = $sp ;
                break;
            }
        }

        $theBetslip = $this->session->get("betslip");
        $title = $matchInfo['home_team'] . " vs " . $matchInfo['away_team'];

        $this->tag->setTitle($title);

        $this->tag->setTitle("Title");

       $this->view->setVars([
            'marketWithOdds'   => $marketWithOdds,
            'matchId'   => $id,
            'matchInfo'  => $matchInfo,
            'theBetslip' => $theBetslip,
            'sports' => $sports,
			'current_sport' => $current_sport,
        ]);

    }

}

?>

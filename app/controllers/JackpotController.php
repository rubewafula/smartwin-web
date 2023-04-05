<?php
/**
 * Copyright (c) Murwa 2018.
 *
 * All rights reserved.
 */

use Phalcon\Mvc\Model\Query;
use Phalcon\Mvc\View;

/**
 * Class JackpotController
 */
class JackpotController extends ControllerBase
{

    /**
     *
     */
    public function indexAction()
    {

//        $jackpotID = $this->rawQueries("SELECT jackpot_event_id FROM jackpot_event WHERE status = 'ACTIVE' ORDER BY 1 DESC LIMIT 1");
//        $jackpotID = $jackpotID['0']['jackpot_event_id'];
//        $games = $this->rawQueries("select j.game_order as pos, jackpot_match_id,e.sub_type_id, group_concat(concat(odd_value)) as threeway, m.game_id, m.match_id, m.start_time, m.parent_match_id, m.away_team, m.home_team, c.competition_name, c.category from jackpot_match j inner join `match` m on m.parent_match_id = j.parent_match_id INNER JOIN competition c ON m.competition_id = c.competition_id inner join event_odd e on e.parent_match_id = m.parent_match_id where j.jackpot_event_id='$jackpotID' and j.status='ACTIVE'  and e.sub_type_id=1 group by j.parent_match_id order by game_order");

//        $this->session->set('jackpot_betslip',[]);
        $games = $this->get_jackpot_games();

        $theBetslip[] = '';
        $jackpotID = $games[0]['jackpot_event_id'] ?? 1;


        $betslip = $this->session->get("jackpot_betslip");

        unset($theBetslip);

        foreach ($betslip as $slip) {
            if ($slip['bet_type'] == 'jackpot') {
                $theBetslip[$slip['match_id']] = $slip;
            }
        }

        $slipCountJ = sizeof($theBetslip);

        $this->tag->setTitle($this->view->t->_('Sunday Jackpot'));

        $jackpotMeta = $this->session->get('jackpot_meta');

        if($jackpotMeta){
            $jackpotMeta['jackpot_amount'] = number_format($jackpotMeta['jackpot_amount'],2);
        }

        $this->view->setVars([
            "games" => $games,
            'slipCount' => $slipCountJ,
            'theBetslip' => $theBetslip,
            'jackpotID' => $jackpotID,
            'amount' => $jackpotMeta['bet_amount'],
            'jackpotMeta' => $jackpotMeta,
            'current_sport' => 'jackpot',
            'page_description' => $this->view->t->_('Sunday Jackpot')
        ]);

    }

}

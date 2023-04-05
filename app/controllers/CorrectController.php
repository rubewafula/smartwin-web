<?php

class CorrectController extends ControllerBase
{
    public function IndexAction()
    {
        $jackpot = $this->rawQueries("SELECT jackpot_event_id FROM jackpot_event WHERE jackpot_type = 2 AND status = 'ACTIVE'  ORDER BY 1 DESC LIMIT 1");
        $jackpotId = null;
        if (count($jackpot)) {
            $jackpotId = $jackpot[0]['jackpot_event_id'];
        }
        $games = $this->rawQueries("select j.game_order as pos, e.sub_type_id, concat(group_concat(concat(odd_key)), ',other') as correctscore, m.game_id, m.match_id, m.start_time, m.parent_match_id, m.away_team, m.home_team from jackpot_match j inner join `match` m on m.parent_match_id = j.parent_match_id inner join event_odd e on e.parent_match_id = m.parent_match_id where j.jackpot_event_id='$jackpotId' and j.status='ACTIVE' and e.sub_type_id=45 group by j.parent_match_id order by pos;");

        $theBetslip = [];

        $betslip = $this->session->get("betslip");

        foreach ((array)$betslip as $slip) {
            if ($slip['bet_type'] == 'bingwafour') {
                $theBetslip[$slip['match_id']] = $slip;
            }
        }
        $startTime = date('d/m H:i');
        foreach ($games as $game) {
            if ($game['pos'] == 1) {
                $startTime = date('d/m H:i', strtotime($game['start_time']));
            }
        }

        $this->tag->setTitle('Correct Score Jackpot - Smartwin.com');

        $this->view->setVars([
            "games"      => $games,
            'theBetslip' => $theBetslip,
            'slipCountJ' => sizeof($theBetslip),
            'jackpot_id' => $jackpotId,
            'startTime'  => $startTime,
            'men'        => 'correct',
        ]);
        $this->view->pick('correct/index');

    }

}

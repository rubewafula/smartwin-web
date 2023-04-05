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
class LivematchController extends ControllerBase
{

    /**
     * Index
     */
    public function indexAction()
    {
        $id = $this->request->get('id', 'int');

        $theBetslip = $this->session->get("betslip");

        if (empty($theBetslip))
            $theBetslip = [];

        list($status_code, $results) = $this->getLiveMarkets($id, $theBetslip);

        $this->view->setVars([
            'marketWithOdds'   => $results['data']['data']['odds'],
            'matchInfo'  => $results['data']['data']['match'],
            'theBetslip' => $theBetslip,
//            'totalOdd'=>$totalOdd,
            'matchId'=>$results['data']['data']['match']['match_id'],
            'id'=>$id
        ]);

        $this->view->pick("live/live_match");

    }

    public function fetchgameAction()
    {
        
        $id = $this->request->get('id', 'int');
        $max_delay_time = strtotime("+10 seconds");

        $last_upadated =  $this->session->get("last_update_datetime");
        
        while(!empty($last_upadated)){
             $updateQuery = "select c.modified from live_odds_change c inner join live_match using(parent_match_id) where  match_id = '$id' order by 1 desc limit 1";
            $lastUpdateDateResult = $this->rawQueries($updateQuery);

            if(!empty($lastUpdateDateResult)){
                $lastUpdateDateResult = $lastUpdateDateResult[0]['modified'];
                if($lastUpdateDateResult != $last_upadated){
                    $this->session->set('last_update_datetime', $lastUpdateDateResult);
                    break;
                }
            }
            if(time() > $max_delay_time){
                //Alow update on UI after max delay time
                break;
            }
            sleep(1);
            
        }
        if(empty($last_upadated)){
            $updateQuery = "select now() as modified ";
           
            $lastUpdateDateResult = $this->rawQueries($updateQuery);
            if(!empty($lastUpdateDateResult)){
                $lastUpdateDateResult = $lastUpdateDateResult[0]['modified'];
                $this->session->set('last_update_datetime', $lastUpdateDateResult); 
            }

        }

        
        if(empty($id)) $id=0;
        #where m.start_time > now() and and o.live_bet = 0
        $subTypesQuery = "select  m.match_id, e.odd_key as display, e.market_name as name, 
            e.odd_key, e.odd_value, e.sub_type_id, e.special_bet_value, e.odd_active, 
            e.active as eactive, e.market_active
            from live_odds_change e  inner join `live_match` m on 
            m.parent_match_id = e.parent_match_id 
			where  match_id = '$id' 
			and  m.betradar_timestamp > now() -interval 30 second
			and m.active=1 
			and e.odd_key <> '-1' 
			and e.sub_type_id != 6 
			and m.event_status = 'Live' 
			and e.odd_value > 1 
			and e.active = 1 
            and e.market_active = 'Active'
            and CASE WHEN e.sub_type_id = 18 THEN e.odd_key REGEXP '[.]5$' 
                WHEN e.sub_type_id = 68 THEN e.odd_key REGEXP '[.]5$' 
                WHEN e.sub_type_id = 90 THEN e.odd_key REGEXP '[.]5$' 
                ELSE 1=1 
			END 
			group by e.sub_type_id, e.odd_key 
			order by sub_type_id, 
                FIELD(e.odd_key,m.home_team,'draw',m.away_team, 
			    concat(m.home_team, ' or ', m.away_team), 
				concat(m.home_team, ' or draw'), 
				concat('draw or ', m.away_team)), 
			e.odd_key, special_bet_value asc ";

        $subTypes = $this->rawQueries($subTypesQuery);

        $liveMatches = $this->rawQueries("SELECT m.match_id, m.parent_match_id, m.home_team, m.away_team, c.competition_name, c.category, s.sport_name, ct.country_code, m.match_time, m.match_status, m.score FROM `live_match` m INNER JOIN competition c using(competition_id) inner join category ct on ct.category_id =c.category_id INNER JOIN sport s on s.sport_id=c.sport_id WHERE m.betradar_timestamp > now() -interval 30 second and m.active=1 and m.match_status not in ('Ended', 'Suspended') and m.event_status not in ('Ended', 'Finished', 'Deactivated', 'Fixture Change') GROUP BY m.parent_match_id ORDER BY m.priority DESC, c.priority DESC, m.start_time");

        $updatedLive = [];
        foreach($liveMatches as $row=>$data){
            $updatedLive[ $row] = $data;
            $updatedLive[ $row]['flag_url'] = $this->categoryLogo->getFlag($data['country_code']) ;
        }
        $liveMatches = $updatedLive;

        #where and m.start_time > now()
        $matchInfo = $this->rawQueries("select m.home_team, m.game_id, m.event_status, m.away_team,m.start_time,c.competition_name,c.category,m.parent_match_id, cc.country_code, m.score, m.match_status, m.match_time, m.active, m.bet_status, m.home_red_card, m.away_red_card, m.home_yellow_card, m.away_yellow_card, m.home_corner, m.away_corner from `live_match` m inner join competition c on m.competition_id=c.competition_id inner join category cc on cc.category_id = c.category_id where match_id=$id   limit 1");


        //die(print_r($matchInfo,1));
        $matchInfo = array_shift($matchInfo);

        $theBetslip = $this->session->get("betslip");
        $newslip = [];
        $totalOdd = 1;
        foreach($theBetslip as $match_id => $slip){
            $sub_type_id = $slip['sub_type_id'];
            $parent_match_id = $slip['parent_match_id'];
            $special_bet_value = $slip['special_bet_value'];
            $bet_pick = $slip['bet_pick'];
            $bet_type =  $slip['bet_type'];
            $query = "select e.odd_value, e.odd_active, e.market_active, "
                . " e.active as eactive from live_odds_change e inner join `live_match` "
                . " m using(parent_match_id) where m.betradar_timestamp > now() -interval 30 second and m.active =1 " 
                . " and e.market_active = 'Active' and "
                . " e.parent_match_id='$parent_match_id' and e.sub_type_id='$sub_type_id' "
                . " and e.special_bet_value='$special_bet_value' and e.odd_key='$bet_pick' "
                . " and e.active = 1 order by e.betradar_timestamp desc limit 1 ";
        

            //die($query);
            $data = $this->rawQueries($query);
            if(!empty($data) && 
                $data[0]['odd_active'] == 1 && $data[0]['market_active'] == 'Active' 
                && $data[0]['eactive'] == 1){
                $new_odd = $data[0]['odd_value'];
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

    
        $results = [
            'subTypes' => $subTypes,
            'liveMatches' => $liveMatches,
            'matchInfo'  => $matchInfo, 
            'id'=>$id,
            'totalOdd'=>$totalOdd,
            'theBetslip'=>$theBetslip,
        ];
        //die(print_r($results,1));

        $response = new Response();
        $response->setStatusCode(201, "OK");
        $response->setHeader("Content-Type", "application/json");

        $results = json_encode($results);
        //die(print_r($results));

        $response->setContent($results);

        return $response;
    }
}

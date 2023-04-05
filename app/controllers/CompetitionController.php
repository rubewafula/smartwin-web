<?php

/**
 * Created by PhpStorm.
 * User: mxgel
 * Date: 03/02/2018
 * Time: 15:32
 */
class CompetitionController extends ControllerBase
{

    /**
     *
     */
    public function indexAction()
    {
        $id = $this->request->get('id', 'int');
         
        $cache_key = 'competiton'.$id;
        list($matches, $current_sport) = $this->redisCache->get($cache_key);

        $sports = $this->get_sports_via_cache();




        if(empty($matches)){

            list($status_code, $matches) = $this->getCompetitionMatches($id);

			$max_cache_time = time()+600;
            $match_time = strtotime($matches['0']['start_time']);
            $lifetime = ($match_time > $max_cache_time ? $max_cache_time : $match_time) - time();

            $current_sport = [];
            foreach($sports as  $sp){
                if($sp['sport_name'] == $matches[0]['sport_name']){
                    $current_sport = $sp ;
                    break;
                }
            }

            $this->redisCache->set($cache_key, [$matches, $current_sport], $lifetime);

        }


        $current_sport = [];
        foreach($sports as  $sp){
            if($sp['sport_name'] == $matches[0]['sport_name']){
                $current_sport = $sp ;
                break;
            }
        }

        $title = $matches['0']['sport_name']. " - " . $matches['0']['competition_name'] . ", " . $matches['0']['category'];


        $this->tag->setTitle($title);

        $this->view->setVars([
            'matches'        => $matches,
            'title'          => $title,
            'current_sport' =>  $current_sport,
        ]);
        $this->view->pick("sports/threeway");
    }
}

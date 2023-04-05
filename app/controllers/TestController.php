<?php

use Phalcon\Mvc\Model\Query;
use Phalcon\Http\Response;

class TestController extends ControllerBase
{
    public function initialize()
    {
        $this->tag->setTitle('About us');
    }

    public function indexAction()
    {

        $page = $this->request->get('page', 'int') ?: 0;
        if ($page < 0) {
            $page = 0;
        }
        $limit = $this->request->get('limit', 'int') ?: 100;
        $sport_id = $this->request->get('id', 'int') ?: 79;

        $skip = $page * $limit;
        $keyword = $this->request->getPost('keyword');
        
        $cache_key = "upcoming.controller" . $sport_id . preg_replace("/\s+/","-", $keyword) .$skip . $limit;
            
	    $cached_games = $this->redisCache->get($cache_key);
        if(!empty($cached_games)){
            $today = $cached_games[0];
            $total = $cached_games[1];
            $current_sport = $cached_games[2]; 
        } else{

            list($today, $total) = $this->getGames(
                $keyword, $skip, $limit, $sport_id, 
                ' and date(start_time) = curdate() ', ' priority desc, start_time asc, m_priority desc');

            $c_sport = $this->rawSelect(
                    "select sport_id, sport_name from sport where sport_id = :sport_id", ['sport_id' => $sport_id]
                 );
            $current_sport = $c_sport[0]; 
            $min_time = $this->getMinTime($keyword, $skip, $limit, $sport_id, "");
            $lifetime = $min_time - time();
            $this->redisCache->set($cache_key, [$today, $total, $current_sport], $lifetime);

        }
        $total = $total['0']['total'];

        $pages = ceil($total / $limit);

        if ($pages > 12) {
            $pages = 12;
        }

        $theBetslip = $this->session->get("betslip");

        $tab = 'today';

        $this->view->setVars([
            'matches'    => $today,
            'tab'        => $tab,
            'betslip' => $theBetslip,
            'total'      => $total,
            'pages'      => $pages,
            'page'       => $page,
            'current_sport' => $current_sport,
        ]);

        $this->tag->setTitle('Smartwin');

        $this->view->pick('index/test');
    }

}


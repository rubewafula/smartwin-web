<?php

use Phalcon\Mvc\Model\Query;
use Phalcon\Http\Response;

class TomorrowController extends ControllerBase
{
	public function initialize()
    {
        $this->tag->setTitle('About us');
    }

    public function indexAction()
    {
        $page = $this->request->get('page','int') ?: 0;
        if ($page<0) {
            $page=0;
        }
        $sport_id = $this->request->get('id','int') ?: 79;
        $limit = $this->request->get('limit','int') ?: 100;
        $skip = $page*$limit;

        $keyword = 'tomorrow';// $this->request->getPost('keyword');
        $cache_key = "tomorrow.controller" . $sport_id . preg_replace("/\s+/","-", $keyword) .$skip . $limit;
            
	    //$cached_games = $this->redisCache->get($cache_key);
        if(!empty($cached_games)){
            $matches = $cached_games[0];
            $current_sport = $cached_games[1];
        } else{
			$current_sport = [];
			foreach($this->sports as $key => $sp){
				if($sp['sport_id'] == $sport_id){
					$current_sport = $sp;
					break;
				}
			}
//			$default_sub_type_id = $current_sport['default_market'];

            list($status_code, $results) = $this->getGames(
                $keyword, $skip, $limit, $sport_id, 
				'and date(start_time) = curdate() + INTERVAL 1 DAY', 
				' m_priority desc, priority desc, start_time asc',
				1
			);

//            $min_time = $this->getMinTime($keyword, $skip, $limit, $sport_id, "",
//				" m_priority desc, priority desc,  start_time asc ",
//			    $default_sub_type_id
//			);

            $matches = $results['data'];

            $lifetime = 600;
            //$this->redisCache->set($cache_key, [$matches, $current_sport], $lifetime);

        }


        $tab = 'tomorrow';

        $this->view->setVars(
            [
                'matches'=>$matches,
                'tab'=>$tab,
                'current_sport' => $current_sport,
            ]
        );

        $this->tag->setTitle('Smartwin');

        $this->view->pick('index/index');
    }

}


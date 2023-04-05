<?php
use Phalcon\Tag;


/**
 * Class IndexController
 */
class HighlightsController extends ControllerBase
{


	public function testAction(){
		$k=""; $s=0; $l=50; $si=79;
		$t = $this->getMinTime($k, $s, $l, $si, "");
		die("\n\nThis is the famed \$T: " . print_r($t, 1));
		/* select start_time from ux_todays_highlights where sport_id = :sport_id and start_time > now() order by start_time asc limit 0,50  */
	}
	/**
	 * @return \Phalcon\Http\Response|\Phalcon\Http\ResponseInterface
	 * https://stash.aumix.net/projects/PAN/repos/cphalcon/browse/CHANGELOG-4.0.md?at=44af1b05812a8cfe7e0ba77ad1797ba57829aff3
	 * https://docs.phalcon.io/4.0/en/cache
	 */
	public function indexAction()
	{
		$hour = date('H');

		if ($hour == 23) {
			return $this->response->redirect('tomorrow');
			$this->view->disable();
		} else {
			$this->tag->setDoctype(Tag::HTML5);

			$sport_id = $this->request->get('id', 'int') ?: 79;
			$page = $this->request->get('page', 'int') ?: 0;
			if ($page < 0) {
				$page = 0;
			}
			$limit = $this->request->get('limit', 'int') ?: 50;
			$skip = $page * $limit;

			$keyword = 'highlights';// $this->request->getPost('keyword');
			$cache_key = "index.controller" . $sport_id . preg_replace("/\s+/","-", $keyword) .$skip . $limit;

			$cached_games = $this->redisCache->get($cache_key);
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
				$default_sub_type_id = $current_sport['default_market'];

				list($status_code, $results) = $this->getGames(
						$keyword, 
						$skip, 
						$limit, 
						$sport_id,
						"", 
						'm_priority desc, priority desc, start_time asc',
						$default_sub_type_id
						);
				//				$min_time = $this->getMinTime($keyword, $skip, $limit, $sport_id, "",
				//					" m_priority desc, priority desc,  start_time asc ",
				//			    	$default_sub_type_id
				//				);

				$matches = $results['data'];

				$lifetime = 600;
				$this->redisCache->set($cache_key, [$matches, $current_sport], $lifetime);
			}



			$tab = 'highlights';
			$men = 'home';
			$this->view->setVars([
					'matches'    => $matches,
					'tab'        => $tab,
					'men'        => $men,
					'current_sport' => $current_sport,
			]);

			$this->tag->setTitle('Smartwin');

			$this->view->pick('index/index');
		}
	}

}

?>

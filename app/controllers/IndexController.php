<?php

use Phalcon\Mvc\Model\Query;
use Phalcon\Http\Response;

class IndexController extends ControllerBase
{
    public function initialize()
    {
        $this->tag->setTitle('About us');
    }

    public function indexAction()
    {

        $params = array();
        $type  = $this->request->get('game-type', 'string') ?? 'slots';
        $section = $this->request->get('section-id', 'string') ?? '';

        if(!empty($type)) {
	       $params['game-type'] = $type;
        }

        if(!empty($section)) {
	       $params['section-id'] = $section;
        }
        list($status, $results) = $this->getGames($params);

        $this->view->setVars([
            'games' => $results,
            // 'sectionId' => $params['section-id'],
            'gametype' => $type
        ]);

        $this->tag->setTitle('Smart Win');

    }

    public function launchAction($gameId)
    {
        $live = $this->request->get('live', 'int') ;
            
        if ($this->session->get('auth') == null) {
            $this->response->redirect('login');
        }
        if ($this->create_player()) {

            list($gamedata, $types) = $this->get_game_url($gameId, $live);
            $this->view->pick("virtualgames/launchgame");

            $this->view->setVars([
                'game' => $gamedata,
                'games' => ['types' => $types],
            ]);
        }
    }

}


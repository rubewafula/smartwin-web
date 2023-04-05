<?php

class VirtualsController extends ControllerBase
{
    public function initialize()
    {
        $this->tag->setTitle('Virtual Games');
    }

    public function indexAction($category = 'rgs-vsb')
    {

        $type = $category == 'casino' ? 'vs' : $category;

        $this->redisCache->set('virtual_games_' . str_replace('-', '', $type), []);

        list($types, $games) = $this->get_casino_games($type);

        $games = array_chunk($games, 3);

        $this->view->pick("virtualgames/index");

        $this->view->setVars([
            'games' => $games,
            'current_sport' => 'virtuals',
            'game_types' => $types,
            'type' => $type
        ]);
    }

    public function liveCasinoAction($category = 'casino')
    {

        $type = $category == 'casino' ? 'vs' : $category;

        $this->redisCache->set('virtual_games_' . str_replace('-', '', $type), []);


        list($types, $games) = $this->get_casino_games($type);

        $games = array_chunk($games, 3);

        $this->view->pick("virtualgames/live-casino");

        $this->view->setVars([
            'games' => $games,
            'current_sport' => 'live-casino',
            'game_types' => $types,
            'type' => $type
        ]);
    }

    public function spacemanAction()
    {


        if ($this->session->get('auth') == null) {
            $this->response->redirect('login');
        }
        if ($this->createPlayer()) {

            $gameUrl = $this->get_game_url("1301", 1);
            

            $this->view->pick("virtualgames/launchgame");

            $this->view->setVars([
                'game_url' => $gameUrl,
                'current_sport' => 'spaceman',
                'type' => 'vs'
            ]);
        }

    }

    public function casinoAction($category = 'casino')
    {

        $type = $category == 'casino' ? 'vs' : $category;

        $this->redisCache->set('virtual_games_' . str_replace('-', '', $type), []);


        list($types, $games) = $this->get_casino_games($type);

        $games = array_chunk($games, 3);

        $this->view->pick("virtualgames/index");

        $this->view->setVars([
            'games' => $games,
            'current_sport' => 'casino',
            'game_types' => $types,
            'type' => $type
        ]);
    }

    public function launchAction($gameId)
    {
        $live = $this->request->get('live', 'int') ;
            
        if ($this->session->get('auth') == null) {
            $this->response->redirect('login');
        }
        if ($this->createPlayer()) {

            $gameUrl = $this->get_game_url($gameId, $live);
            

            $this->view->pick("virtualgames/launchgame");

            $this->view->setVars([
                'game_url' => $gameUrl,
                'type' => 'vs'
            ]);
        }
    }

    public function createPlayer()
    {
        return $this->create_player();

    }
}

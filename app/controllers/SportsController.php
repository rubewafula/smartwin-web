<?php

/**
 * Class SportsController
 */
class SportsController extends ControllerBase
{
    /**
     *
     */
    public function IndexAction()
    {
		$sports = $this->redisCache->get('sports');
        if(empty($sports)){
            $sports =  $this->rawSelect("SELECT * FROM sport;");
            $this->redisCache->set('sports', $sports, 7200);
        }

        $this->view->setVars([
            'sports'    => $sports,
            'men'       => 'sports',
        ]);
    }

    /**
     *
     */
    public function threewayAction()
    {
        $id = $this->request->get('id', 'int');

        $matches = $this->rawSelect("select c.priority, (select count(distinct e.sub_type_id) from event_odd e inner join odd_type o on o.sub_type_id = e.sub_type_id where parent_match_id = m.parent_match_id and o.active = 1) as side_bets, o.sub_type_id, MAX(CASE WHEN o.odd_key = '1' THEN odd_value END) AS home_odd, MAX(CASE WHEN o.odd_key = 'x' THEN odd_value END) AS neutral_odd, MAX(CASE WHEN o.odd_key = '2' THEN odd_value END) AS away_odd, m.game_id, m.match_id, m.start_time, m.away_team, m.home_team, m.parent_match_id,c.competition_name,c.category from `match` m inner join event_odd o on m.parent_match_id = o.parent_match_id inner join competition c on c.competition_id = m.competition_id inner join sport s on s.sport_id = c.sport_id where c.competition_id='$id' and m.start_time > now() and o.sub_type_id = 10 and m.status <> 3 group by m.parent_match_id order by m.priority desc, c.priority desc , m.start_time limit 60");

        $theCompetition = $this->rawSelect("select competition_name,competition_id,category,sport_id from competition where competition_id='$id' limit 1");

        $sport_id = $theCompetition['0']['sport_id'];

        $sport = $this->rawSelect("select sport_name from sport where sport_id='$sport_id' limit 1");
        $sport = $sport['0']['sport_name'];

        $theBetslip = $this->session->get("betslip");

        $title = $sport . ' > ' . $theCompetition['0']['competition_name'] . ", " . $theCompetition['0']['category'];

        $theCompetition = $theCompetition['0'];

        $pages = 0;

        $this->tag->setTitle($title);

        $this->view->setVars([
            'matches' => $matches,
            'title'   => $title,
            'pages'   => $pages,
        ]);

        $this->view->pick("sports/threeway");
    }

    /**
     *
     */
    public function twowayAction()
    {
        $id = $this->request->get('id', 'int');
        $matches = $this->rawSelect("select c.priority, (select count(distinct e.sub_type_id) from event_odd e inner join odd_type o on o.sub_type_id = e.sub_type_id where parent_match_id = m.parent_match_id and o.active = 1) as side_bets, o.sub_type_id, MAX(CASE WHEN o.odd_key = '1' THEN odd_value END) AS home_odd, MAX(CASE WHEN o.odd_key = 'x' THEN odd_value END) AS neutral_odd, MAX(CASE WHEN o.odd_key = '2' THEN odd_value END) AS away_odd, m.game_id, m.match_id, m.start_time, m.away_team, m.home_team, m.parent_match_id,c.competition_name,c.category from `match` m inner join event_odd o on m.parent_match_id = o.parent_match_id inner join competition c on c.competition_id = m.competition_id inner join sport s on s.sport_id = c.sport_id where c.competition_id='$id' and m.start_time > now() and o.sub_type_id = 20 and m.status <> 3 group by m.parent_match_id order by m.priority desc, c.priority desc , m.start_time limit 60");

        $theCompetition = $this->rawSelect("select competition_name,competition_id,category,sport_id from competition where competition_id='$id' limit 1");

        $sport_id = $theCompetition['0']['sport_id'];

        $sport = $this->rawSelect("select sport_name from sport where sport_id='$sport_id' limit 1");
        $sport = $sport['0']['sport_name'];

        $theBetslip = $this->session->get("betslip");

        $title = $sport . ' > ' . $theCompetition['0']['competition_name'] . ", " . $theCompetition['0']['category'];

        $this->tag->setTitle($title);

        $this->view->setVars([
            'matches' => $matches,
            'title'   => $title,
        ]);

        $this->view->pick("sports/twoway");
    }

    /**
     *
     */
    public function upcomingAction()
    {
        $page = $this->request->get('page', 'int') ?: 0;
        if ($page < 0) {
            $page = 0;
        }
        $limit = $this->request->get('limit', 'int') ?: 60;
        $skip = $page * $limit;

        $keyword = $this->request->getPost('keyword');

        list($today, $total, $sCompetitions) = $this->getGames($keyword, $skip, $limit);


        $total = $total['0']['total'];

        $pages = ceil($total / $limit);

        $theBetslip = $this->session->get("betslip");

//        var_dump($pages);
//        die;

        $this->view->setVars([
            'matches'       => $today,
            'theBetslip'    => $theBetslip,
            'sCompetitions' => $sCompetitions,
            'total'         => $total,
            'pages'         => $pages > 14 ? 14 : $pages,
            'page'          => $page,
        ]);

        $this->tag->setTitle('Smartwin');


    }
}

?>

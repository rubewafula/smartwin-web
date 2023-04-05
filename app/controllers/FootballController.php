<?php

/**
 * Class FootballController
 */
class FootballController extends ControllerBase
{
    /**
     *
     */
    public function IndexAction()
    {
        $football = $this->rawSelect("SELECT * FROM ux_categories WHERE sport_id=79;");
        $competitions = $this->rawSelect("SELECT competition.competition_id, competition.competition_name, category.country_code, count(*) AS games_count FROM competition INNER JOIN category ON category.category_id = competition.category_id INNER JOIN `match` ON `match`.competition_id = competition.competition_id WHERE competition.sport_id > 0 AND `match`.start_time > now() GROUP BY competition.competition_id ORDER BY competition.priority DESC LIMIT 7;");
        $this->view->setVars([
            'football'     => $football,
            'men'          => 'football',
            'competitions' => $competitions,
        ]);
    }

    /**
     *
     */
    public function competitionAction()
    {
        $id = $this->request->get('id', 'int');

        $matches = $this->rawSelect("select c.category,c.priority, (select count(distinct sub_type_id) from event_odd where parent_match_id = m.parent_match_id) as side_bets, o.sub_type_id, MAX(CASE WHEN o.odd_key = '1' THEN odd_value END) AS home_odd, MAX(CASE WHEN o.odd_key = 'x' THEN odd_value END) AS neutral_odd, MAX(CASE WHEN o.odd_key = '2' THEN odd_value END) AS away_odd, m.game_id, m.match_id, m.start_time, m.away_team, m.home_team, m.parent_match_id from `match` m inner join event_odd o on m.parent_match_id = o.parent_match_id inner join competition c on c.competition_id = m.competition_id inner join sport s on s.sport_id = c.sport_id where c.competition_id='$id' and m.start_time > now() and o.sub_type_id = 10  group by m.parent_match_id order by c.category,m.priority desc, c.priority desc , m.start_time limit 20");

        $theCompetition = $this->rawSelect("select competition_name,competition_id,category from competition where competition_id='$id' limit 1");

        $title = $theCompetition['0']['competition_name'] . ", " . $theCompetition['0']['category'];

        $this->tag->setTitle($title);
        $men = 'football';

        $this->view->setVars([
            'matches'        => $matches,
            'theCompetition' => $theCompetition,
            'men'            => $men,
        ]);

        $this->view->pick("sports/index");
    }

    /**
     *
     */
    public function outrightsAction()
    {
        $id = $this->request->get('id', 'int');
        $pid = $this->request->get('pid', 'int');

        if ($id || $pid) {

            $outright = "select outright_id,o.parent_outright_id,event_name,event_date, c.betradar_competitor_id ,competitor_name,odd_type,odd_value from outright o inner join outright_competitor c on c.parent_outright_id=o.parent_outright_id inner join outright_odd od on od.betradar_competitor_id=c.betradar_competitor_id and od.parent_outright_id = c.parent_outright_id where o.parent_outright_id='$pid' group by c.betradar_competitor_id, o.parent_outright_id order by competitor_name";

            if ($id) {
                $outright = "select outright_id,o.parent_outright_id,event_name,event_date, c.betradar_competitor_id ,competitor_name,odd_type,odd_value from outright o inner join outright_competitor c on c.parent_outright_id=o.parent_outright_id inner join outright_odd od on od.betradar_competitor_id=c.betradar_competitor_id and od.parent_outright_id = c.parent_outright_id where o.competition_id='$id' group by c.betradar_competitor_id, o.parent_outright_id order by outright_id";
            }

            $outright = $this->rawSelect($outright);
            $matchInfo = $this->rawSelect("select competition_name,category from competition where betradar_competition_id='$id' limit 1");
            $matchInfo = $matchInfo['0'];
            $this->view->setVars([
                'outright'  => $outright,
                'matchInfo' => $matchInfo,
            ]);
            $this->view->pick('football/outright');
        } else {
            $outrights = $this->rawSelect("SELECT c.sport_id,count(*)events, c.competition_name,c.betradar_competition_id,c.category FROM outright o INNER JOIN competition c ON o.competition_id=c.betradar_competition_id WHERE c.betradar_competition_id > 0 AND c.sport_id=79 GROUP BY c.competition_id");
            $this->view->setVars(['outrights' => $outrights]);
        }
    }

    /**
     *
     */
    public function outrightAction()
    {
        # code...
    }

}

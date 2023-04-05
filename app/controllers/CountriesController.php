<?php
     
 /** 
  * Class FootballController
  */     
class CountriesController extends ControllerBase
{   
     /**
      *
      */
     public function IndexAction()
     {
         $id = $this->request->get('id', 'int');
         $id = $id ?: 79;
 
         list($top_countries, $countries) = $this->redisCache->get('sport-countries-'.$id);
         if(empty($top_countries)){
			 $top_countries = $this->rawSelect(
                 "SELECT category.category_id, category.category_name as country, "
                 . " count(*) AS games_count, s.sport_name FROM competition "
                 . " INNER JOIN category ON category.category_id = competition.category_id "
                 . " INNER JOIN `match` ON `match`.competition_id = competition.competition_id "
                 . " INNER JOIN sport s on s.sport_id = competition.sport_id "
                 . " WHERE competition.sport_id = :id AND `match`.start_time > now() "
                 . " GROUP BY category.category_id having games_count > 0 "
                 . " ORDER BY category.priority desc  limit 10",
                 ['id' => $id]);

             $countries = $this->rawSelect(
                 "SELECT category.category_id, category.category_name as country, "
                 . " count(*) AS games_count FROM competition "
                 . " INNER JOIN category ON category.category_id = competition.category_id "
                 . " INNER JOIN `match` ON `match`.competition_id = competition.competition_id "
                 . " WHERE competition.sport_id = :id AND `match`.start_time > now() "
                 . " GROUP BY category.category_id having games_count > 0 "
                 . " ORDER BY category_name  ASC;",
                 ['id' => $id]);
             
             $this->redisCache->set('sport-countries-'.$id, [$top_countries, $countries], 7200);
             
         }
             
       
         $this->view->setVars([
             'men'          => 'countries',
             'sport_name' => $top_countries[0]['sport_name'],
             'top_countries' => $top_countries,
             'countries' => $countries,
         ]); 
     }       
             
} 

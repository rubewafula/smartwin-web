<?php
     
 /** 
  * Class FootballController
  */     
class TopLeaguesController extends ControllerBase
{   
     /**
      *
      */
     public function IndexAction()
     {
         $id = $this->request->get('id', 'int');
         $c = $this->request->get('c', 'int') ?: 0;
         $id = $id ?: 79;
         
 
         list($status_code, $competitions) = $this->getAllCategories($id);

         $top_competitions = $competitions['top_soccer'];
         $allSports = $competitions['all_sports'];

        
         $this->view->setVars([
             'men'          => 'top-leagues',
             'sport_name' => $allSports[0]['sport_name'] ,
             'category' => $c != 0 ? $top_competitions[0]['country'] : "Top",
             'allSports' => $allSports,
             'top_competitions' => $top_competitions,
         ]);
     }       
             
} 

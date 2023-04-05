<?php

/**
 * Class FootballController
 */
class SportCompetitionController extends ControllerBase
{
    /**
     *
     */
    public function IndexAction()
    {
        $id = $this->request->get('id', 'int');
        $id = $id ?: 79;



        list($top_competitions,$competitions,$categories) = $this->redisCache->get('sport-competitions-'.$id);
        if(empty($competitions)){

            list($status_code, $competitions) = $this->getCategories($id);
//
            $top_competitions = $competitions['top_soccer'];
            $competitions = $competitions['all_sports'];
            $categories = $competitions[0]['categories'];
    //        die(json_encode($top_competitions));

             $this->redisCache->set('sport-competitions-'.$id, [$top_competitions,$competitions,$categories], 7200);
        }
       
      
        $this->view->setVars([
            'categories'     => $categories,
            'men'          => 'sport-competition',
            'sport_name' => $competitions[0]['sport_name'],
            'top_competitions' => $top_competitions,
        ]);
    }


}

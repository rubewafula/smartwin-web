<table class="betdetail">
  <tr class="title" style="background-color:#781c5d; color:#bebebe">
    <th class="text-left id"> BET ID : <?= $myBet['bet_id'] ?></th>
    <th class="text-right status pending "><?php
       if($myBet['status']==1){
          echo 'Pending results';
       }elseif($myBet['status']==5){
           echo '<span class="won">Won</span>';
       }elseif($myBet['status']==3){
           echo 'Lost';
       }elseif($myBet['status']==4){
          echo 'Cancelled';
       }elseif($myBet['status']==9){
          echo 'Pending Jackpot';
       }elseif($myBet['status']==24){
          echo 'Cancelled';
       }elseif($myBet['status']==200){
          echo 'Not Paid';
       }else{
          echo 'View';
       }
       ?></th>
  </tr>
  <tr>
    <td colspan="10">
      <table class="summary" style="background-color:#ffffff; color:#000">
        <th>Date</th>
        <th>Type</th>
        <th>Bet Amount</th>
        <th>Possible Win</th>
        <tr>
          <td style="background-color:#f0f0f0; color:#000"><?= date('d/m H:i', strtotime($myBet['created'])) ?></td>
          <td style="background-color:#f0f0f0; color:#000">
          <?php 
            if($myBet['total_matches']>1){
            echo "Multi Bet";
            }else{
              echo "Single Bet";
            }
          ?>
          </td>
          <td style="background-color:#f0f0f0; color:#000"><?= $myBet['bet_amount'] ?></td>
          <td style="background-color:#f0f0f0; color:#000"><?= $myBet['possible_win'] ?></td>
        </tr>
      </table>
      <span class="pull-left padding-up-down" style="color:#000"> Events </span>
      <?php foreach($betDetails as $bet): ?>
      <table class="event" style="background-color:#ffffff; color:#000">
        <th colspan="10" class="text-left"><span >#<?= $bet['game_id'] ?></span> : <?= $bet['home_team']." v ".$bet['away_team'] ?></th>
        
        <tr class="detail" style="background-color:#f0f0f0; color:#000">
          <td class="border-right border-bottom">
            <table>
              <tr>
                <td class="text-left">
                  <span>Date</span>
                </td>
                <td class="text-right">
                  <span><?= date('d/m H:i', strtotime($bet['start_time'])) ?></span>
                </td>
              </tr>
            </table>
          </td>
          <td class="border-left border-bottom">
            <table>
              <tr>
                <td class="text-left">
                  <span>Pick</span>
                </td>
                <td class="text-right">
                  <span><?= $bet['bet_pick'] ?></span>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="detail" style="background-color:#f0f0f0; color:#000">
          <td class="border-right border-top">
            <table>
              <tr>
                <td class="text-left">
                  <span>Odds</span>
                </td>
                <td class="text-right">
                  <span><?= $bet['odd_value'] ?></span>
                </td>
              </tr>
            </table>
          </td>
          <td class="border-left border-top">
              <table>
              <tr>
                <td class="text-left">
                  <span>Outcome</span>
                </td>
                <td class="text-right">
                  <span><?php
        if(empty($bet['winning_outcome']))
          echo "Pending Result";
        else
          echo $bet['winning_outcome'];

     ?></span>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="detail" style="background-color:#f0f0f0; color:#000">
          
          <td class="border-right border-top">
            <table>
              <tr>
                <td class="text-left">
                  <span>Type</span>
                </td>
                <td class="text-right">
                  <span><?= $bet['bet_type'] ?></span>
                </td>
              </tr>
            </table>
          </td>
          <td class="border-left border-top">
              <table>
              <tr>
                <td class="text-left">
                  <span>Results</span>
                </td>
                <td class="text-right">
                  <span><?= $bet['results'] ?></span>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>

      <?php endforeach; ?>

    </td>
  </tr>
</table>

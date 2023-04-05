<?php 
$sub_type_id=''; 
  function clean($string) {
     $string = str_replace(' ', '-', $string); // Replaces all spaces with hyphens.
     $string = preg_replace('/[^A-Za-z0-9\-]/', '', $string); // Removes special chars.

     return preg_replace('/-+/', '-', $string); // Replaces multiple hyphens with single one.
  }
?>
<table class="feature">
  <th class="title">
    <table width="100%">
      <tr class="game">
        <td colspan="3"><?php echo $matchInfo['home_team']." vs ".$matchInfo['away_team']; ?></td>
      </tr>
      <tr class="spacer"></tr>
      <tr class="details">
        <td class="text-left"><?= $matchInfo['competition'].", ".$matchInfo['category'];
?></td>
        <td class="text-center">Game ID : <?= $matchInfo['game_id']; ?></td>
        <td><span class="text-left"><?= date('d/m', strtotime($matchInfo['start_time'])); ?></span> <span><?= date('g:i a', strtotime($matchInfo['start_time'])); ?></span> </td>
      </tr>
    </table>
  </th>
  
</table>
<div class="sidebets">



<?php foreach($marketWithOdds as $marketName => $oddsArray): ?>
<?php
	$theMatch = @$theBetslip[$matchId];
?>

		<div class="sidebet-card">
			   <div class="sidebet-header">{{ marketName }}</div>



	<?php foreach($oddsArray as $odds): ?>


	    <button class="sidebet-odd <?php echo $odds['match_id']; ?> <?php echo clean($odds['match_id'].$odds['sub_type_id'].$odds['odd_key'].$odds['special_bet_value']);
                            if($theMatch && $theMatch['bet_pick']==$odds['odd_key'] && $theMatch['sub_type_id']==$odds['sub_type_id'] && $theMatch['special_bet_value']==$odds['special_bet_value']){
                                echo ' picked';
                             }
                          ?>"
        				  oddtype="<?= $marketName ?>"
        				  parentmatchid="<?php echo $matchInfo['parent_match_id']; ?>"
        				  bettype='prematch' hometeam="<?php echo $matchInfo['home_team']; ?>"
        				  awayteam="<?php echo $matchInfo['away_team']; ?>"
        				  oddvalue="<?php echo $odds['odd_value']; ?>"
        				  custom="<?php echo clean($odds['match_id'].$odds['sub_type_id'].$odds['odd_key'].$odds['special_bet_value']); ?>"
        				  target="javascript:;" id="<?php echo $odds['match_id']; ?>"
        				  odd-key="<?php echo $odds['odd_key']; ?>"
        				  value="<?php echo $odds['sub_type_id']; ?>"
        				  special-value-value="<?php echo $odds['special_bet_value']; ?>"
        				  onClick="addBet(this.id,this.value,this.getAttribute('odd-key'),
        				      this.getAttribute('custom'),this.getAttribute('special-value-value'),
        					  this.getAttribute('bettype'),this.getAttribute('hometeam'),
        					  this.getAttribute('awayteam'),this.getAttribute('oddvalue'),
        					  this.getAttribute('oddtype'),this.getAttribute('parentmatchid'))">
							<span class="side-label"> <?php echo $odds['display']; ?></span>
							<span class="odd-value"> <?php echo $odds['odd_value']; ?></span>
        			</button>
	<?php endforeach; ?>

		</div>  <!-- end sidebet card -->


<?php endforeach; ?>
</div>

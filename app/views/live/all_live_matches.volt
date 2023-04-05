
<?php 
      function clean($string) {
         $string = str_replace(' ', '-', $string); // Replaces all spaces with hyphens.
         $string = preg_replace('/[^A-Za-z0-9\-]/', '', $string); // Removes special chars.

         return preg_replace('/-+/', '-', $string); // Replaces multiple hyphens with single one.
      }
?>

<table id="main" class="highlights" width="100%">
	<tr>
	  <td style="padding: 0;">
		   <table width="100%" cellpadding="0" cellspacing="0" class="mkt-headers">
				   <tbody><tr><td width="50%" style="float:left; text-align:left; color:red;">{{current_sport['sport_name']}} Live </td>
				   <td width="50%">
					   <table width="100%" cellpadding="0" cellspacing="0" style="text-align:center;">
					   <tr>
						 <td width="28%">1</td>
						 <td width="28%">X</td>
						 <td width="28%">2</td>
						 <td width="16%">mkts</td>
					   </tr>
					   </table>
				   </td>
				   </tr>
			   </tbody>
		   </table>
	  </td>
	</tr>
	<tr>
	    <td style="padding:0;" >
		<!-- list of live matches -->
  <?php $a = 0; ?>
  <?php if(count($liveMatches) > 0):  ?>
  <?php $id=0; ?>
  <?php foreach($liveMatches as $match): ?>
      <?php
         $theMatch = null;
         if(isset($betslip[$match['match_id']])) {
             $theMatch = $betslip[$match['match_id']];
         }
       ?>
      <!-- let us update the odds on the game -->
      <?php
	  $empty_row_text = '<table cellspacing="0" cellpadding="0"> <tr> <td class=""><button  class="odds-btn"><span class="odd" style="opacity:0.3"><img height="15" width="15" src="/img/padlock.svg" alt="-" /></span></button></td> </tr> </table>';
	  ?> 
	  <!-- end odds update  -->
      <!-- list one match -->
            <table class="highlights--item" width="100%" cellspacing="0" cellpadding="0">
              <tbody>
			    <tr><td colspan="10">
                <table class="league">
                  <tbody>
                   <tr >
                      <td style="text-align: left; vertical-align:top;" class="meta" width="50%">
                          <table  >
                              <tbody>
                              <tr>
                                 <td>
                                    <?php echo $match['competition_name'].", ".$match['category']; ?>
                                 </td>
                              </tr>
                              <tr>
                                 <td class="team-names">
                                     <?php echo strtoupper($match['home_team']); ?>
                                 </td>
                              </tr>
                              <tr>
                                 <td class="team-names">
                                     <?php echo strtoupper($match['away_team']); ?>
                                 </td>
                              </tr>

                              </tbody>
                          </table>
                       </td>
                       <!-- the buttons here -->
					   <td  width="50%" style="text-align: right;">
                          <table width="100%">
                              <tbody>
                              <tr>
                                 <td>
                                    <?php echo "<span style='color:red;'>" . $match['match_status'] .' ' . ($match['match_time'] ?: "") . ' ('. ($match['score'] ?:"") .')</span>'?>
                                 </td>
                              </tr>
                              <tr>
                              <td width="28%">
                                 <table class="real-odds" width="100%">
                                     <tr class="odds">
                                        <td class="clubone <?php echo $match['match_id']; ?> <?php
                                          echo clean($match['match_id'].$match['sub_type_id'].$match['home_team']);
                                             if($theMatch && $theMatch['bet_pick']==$match['home_team'] && $theMatch['sub_type_id']=='1'){
                                                echo ' picked';
                                             }
                                          ?>">
			                 <?php if($match['odds']['home_odd'] && $match['odds']['home_odd_active']  == 1) { ?>
                                          <table cellspacing="0" cellpadding="0">
                                            <tr>

                                              <td class=""><button href="javascript:;" class="odds-btn" hometeam="<?php echo $match['home_team']; ?>" oddtype="3 Way" bettype='live' awayteam="<?php echo $match['away_team']; ?>" oddvalue="<?php echo $match['odds']['home_odd']; ?>" target="." odd-key="<?php echo $match['home_team']; ?>" parentmatchid="<?php echo $match['parent_match_id']; ?>" id="<?php echo $match['match_id']; ?>" custom="<?php echo clean($match['match_id'].$match['sub_type_id'].$match['home_team']); ?>" sub-type-id="1" special-value-value="0" onClick="addBet(this.id,this.getAttribute('sub-type-id'),this.getAttribute('odd-key'),this.getAttribute('custom'),this.getAttribute('special-value-value'),this.getAttribute('bettype'),this.getAttribute('hometeam'),this.getAttribute('awayteam'),this.getAttribute('oddvalue'),this.getAttribute('oddtype'),this.getAttribute('parentmatchid'))"><span class="odd"><?php echo $match['odds']['home_odd']; ?></span></button></td>

                                            </tr>
                                		  </table>
										  <?php } else { ?>

                                               <?php echo $empty_row_text; ?>
										  <?php } ?>
                             </td>
                             <td width="28%" class="<?php echo $match['match_id']; ?> <?php
                                          echo clean($match['match_id'].$match['sub_type_id'].'draw');
                                             if($theMatch && $theMatch['bet_pick']=='draw' && $theMatch['sub_type_id']=='1'){
                                                echo ' picked';
                                             }
                                          ?>">
										  <?php if($match['odds']['neutral_odd'] && $match['odds']['neutral_odd_active'] ==  1) { ?>
                                            <table>
                                             <tr>
                                                    <td class=""><button href="javascript:;" class="odds-btn" hometeam="<?php echo $match['home_team']; ?>" oddtype="3 Way" bettype='live' awayteam="<?php echo $match['away_team']; ?>" oddvalue="<?php echo $match['odds']['neutral_odd']; ?>" target="javascript:;" odd-key="draw" parentmatchid="<?php echo $match['parent_match_id']; ?>" id="<?php echo $match['match_id']; ?>" custom="<?php echo clean($match['match_id'].$match['sub_type_id'].'draw'); ?>" sub-type-id="1" special-value-value="0" onClick="addBet(this.id,this.getAttribute('sub-type-id'),this.getAttribute('odd-key'),this.getAttribute('custom'),this.getAttribute('special-value-value'),this.getAttribute('bettype'),this.getAttribute('hometeam'),this.getAttribute('awayteam'),this.getAttribute('oddvalue'),this.getAttribute('oddtype'),this.getAttribute('parentmatchid'))"><span class="odd"><?php echo $match['odds']['neutral_odd']; ?></span></button></td>

                                              </tr>
                                   			</table>
										  <?php } else { ?>

                                               <?php echo $empty_row_text; ?>
										  <?php } ?>

                              </td>
                              <td class="clubtwo <?php echo $match['match_id']; ?> <?php
                                          echo clean($match['match_id'].$match['sub_type_id'].$match['away_team']);
                                             if($theMatch && $theMatch['bet_pick']==$match['away_team'] && $theMatch['sub_type_id']=='1'){
                                                echo ' picked';
                                             }
                                          ?>" width="28%">
										  
										 <?php if($match['odds']['away_odd'] && $match['odds']['away_odd_active'] ==1) { ?>
										  <table>
										   <tr>
                                              <td class=""><button href="javascript:;" class="odds-btn" hometeam="<?php echo $match['home_team']; ?>" oddtype="3 Way" bettype='live' awayteam="<?php echo $match['away_team']; ?>" oddvalue="<?php echo $match['odds']['away_odd']; ?>" target="javascript:;" odd-key="<?php echo $match['away_team']; ?>" parentmatchid="<?php echo $match['parent_match_id']; ?>" id="<?php echo $match['match_id']; ?>" custom="<?php echo clean($match['match_id'].$match['sub_type_id'].$match['away_team']); ?>" sub-type-id="1" special-value-value="0" onClick="addBet(this.id,this.getAttribute('sub-type-id'),this.getAttribute('odd-key'),this.getAttribute('custom'),this.getAttribute('special-value-value'),this.getAttribute('bettype'),this.getAttribute('hometeam'),this.getAttribute('awayteam'),this.getAttribute('oddvalue'),this.getAttribute('oddtype'),this.getAttribute('parentmatchid'))"><span class="odd"><?php echo $match['odds']['away_odd']; ?></span></button></td>
                                              
										 </tr>
									  </table>
									  <?php } else { ?>

                                               <?php echo $empty_row_text; ?>
										  <?php } ?>

                           </td>
                           <td class="sidebet" width="16%">
						     <?php if($match['side_bets']) { ?>
                             <a class="<?php if($theMatch && $theMatch['sub_type_id']!=1){echo ' picked';}
                 ?>" href="{{ url('livematch?id=') }}{{match['parent_match_id']}}"><img src="/img/markets.svg" style="width: 9px !important; padding-bottom: 4px;"> <?php echo $match['side_bets']; ?></a>
				             <?php } ?>
                           </td>

                       </tr>
                 </table> <!-- end table real-odds -->
                 </td>
				  </tr>

				  </tbody>
			  </table>

		  </td>
		</tr>
	  </table>
	</td>
  </tr>
</table>
<!-- end foreach here -->
 <?php endforeach; ?>
   <?php else: ?>
    <tr>
       <td style="color:#ffffff">
          No Live Games Available Now. Please check at the top of the hour
       </td>
    </tr>
    <?php endif ?>

        
    </td>
  </tr>
</table>


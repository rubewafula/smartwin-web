
<?php 
      function clean($string) {
         $string = str_replace(' ', '-', $string); // Replaces all spaces with hyphens.
         $string = preg_replace('/[^A-Za-z0-9\-]/', '', $string); // Removes special chars.

         return preg_replace('/-+/', '-', $string); // Replaces multiple hyphens with single one.
      }
      $empty_row_text = '<table cellspacing="0" cellpadding="0"> <tr> <td class=""><button  class="odds-btn"><span class="odd" style="opacity:0.3"><img height="15" width="15" src="/img/padlock.svg" alt="-" /></span></button></td> </tr> </table>';

?>
<table class="highlights" width="100%">
        <tr>
          <td style="padding: 0;">
               <table width="100%" cellpadding="0" cellspacing="0" class="mkt-headers">
                       <tbody><tr><td width="50%" style="float:left; text-align:left;">{{current_sport['sport_name']}}</td>
                       <td width="50%">
                           <table width="100%" cellpadding="0" cellspacing="0">
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
          <td style="padding: 0;">

         <!-- List matches -->






          <?php foreach($matches as $day): ?>

            <?php $theMatch = @$betslip[$day['match_id']]; 
            ?>

            <table class="highlights--item" width="100%" cellpadding="0" cellspacing="0">
              
              <tr>
                <td >
                  <table class="league">
                    <tr >
                      <td style="text-align: left; vertical-align:top;" class="meta" width="50%">
                          <table>
                              <tbody>
                              <tr>
                                 <td style="opacity: .75;">
                                    <?php echo $day['competition_name'].", ".$day['category']; ?>
                                 </td>
                              </tr>
                              <tr>
                                 <?php if(strpos(strtolower($_SERVER['HTTP_USER_AGENT']),'opera') !== false || strpos(strtolower($_SERVER['HTTP_USER_AGENT']),'opr') !== false ){ ?>

                                 <td class="team-names" style="font-size: 9px!important;">
                                     <?php echo strtoupper($day['home_team']); ?>
                                 </td>

                                 <?php }else{ ?>
                                    <td class="team-names">
                                       <?php echo strtoupper($day['home_team']); ?>
                                   </td>
                                 <?php } ?>

                              </tr>
                              <tr>
                                 <?php if(strpos(strtolower($_SERVER['HTTP_USER_AGENT']),'opera') !== false || strpos(strtolower($_SERVER['HTTP_USER_AGENT']),'opr') !== false ){ ?>

                                 <td class="team-names" style="font-size: 9px;">
                                     <?php echo strtoupper($day['away_team']); ?>
                                 </td>
                                 <?php }else{ ?>
                                    <td class="team-names">
                                       <?php echo strtoupper($day['away_team']); ?>
                                   </td>
                                   <?php } ?>  
                              </tr>

                              </tbody>
                          </table>
                       </td>
                       <td  width="50%" style="text-align: right;">
                          <table width="100%">
                              <tbody>
                              <tr>
                                 <td>
                                    <?php echo date('d/m H:i', strtotime($day['start_time'])); ?> - <?php echo 'ID'; ?>: <?php echo $day['game_id']; ?>
                                 </td>
                              </tr>
                              <tr>
                              <td width="28%">
                                 <table class="real-odds" width="100%">
                                     <tr class="odds">
                                        <td class="clubone <?php echo $day['match_id']; ?> <?php
                                          echo clean($day['match_id'].$day['sub_type_id'].$day['home_team']);
                                             if($theMatch && $theMatch['bet_pick']==$day['home_team'] && $theMatch['sub_type_id']==$day['sub_type_id']){
                                                echo ' picked';
                                             }
                                          ?>">
                                          <?php if($day['odds']['home_odd']) { ?>
                                          <table cellspacing="0" cellpadding="0">
                                            <tr>

                                              <td class=""><button href="javascript:;" class="odds-btn" hometeam="<?php echo $day['home_team']; ?>" oddtype="3 Way" bettype='prematch' awayteam="<?php echo $day['away_team']; ?>" oddvalue="<?php echo $day['odds']['home_odd']; ?>" target="." odd-key="<?php echo $day['home_team']; ?>" parentmatchid="<?php echo $day['parent_match_id']; ?>" id="<?php echo $day['match_id']; ?>" custom="<?php echo clean($day['match_id'].$day['sub_type_id'].$day['home_team']); ?>" sub-type-id="<?= $day['sub_type_id'];?>" special-value-value="0" onClick="addBet(this.id,this.getAttribute('sub-type-id'),this.getAttribute('odd-key'),this.getAttribute('custom'),this.getAttribute('special-value-value'),this.getAttribute('bettype'),this.getAttribute('hometeam'),this.getAttribute('awayteam'),this.getAttribute('oddvalue'),this.getAttribute('oddtype'),this.getAttribute('parentmatchid'))"><span class="odd"><?php echo $day['odds']['home_odd']; ?></span></button></td>

                                            </tr>
                                         </table>
								      <?php } else { ?>
                                               <?php echo $empty_row_text; ?>
									  <?php } ?>
                             </td>
                             <td width="28%" class="<?php echo $day['match_id']; ?> <?php
                                          echo clean($day['match_id'].$day['sub_type_id'].'draw');
                                             if($theMatch && $theMatch['bet_pick']=='draw' && $theMatch['sub_type_id']==$day['sub_type_id']){
                                                echo ' picked';
                                             }
                                          ?>">
                                          <?php if($day['odds']['neutral_odd']) { ?>
                                            <table>
                                             <tr>
                                                    <td class=""><button href="javascript:;" class="odds-btn" hometeam="<?php echo $day['home_team']; ?>" oddtype="3 Way" bettype='prematch' awayteam="<?php echo $day['away_team']; ?>" oddvalue="<?php echo $day['odds']['neutral_odd']; ?>" target="javascript:;" odd-key="draw" parentmatchid="<?php echo $day['parent_match_id']; ?>" id="<?php echo $day['match_id']; ?>" custom="<?php echo clean($day['match_id'].$day['sub_type_id']."draw"); ?>" sub-type-id="<?= $day['sub_type_id']; ?>" special-value-value="0" onClick="addBet(this.id,this.getAttribute('sub-type-id'),this.getAttribute('odd-key'),this.getAttribute('custom'),this.getAttribute('special-value-value'),this.getAttribute('bettype'),this.getAttribute('hometeam'),this.getAttribute('awayteam'),this.getAttribute('oddvalue'),this.getAttribute('oddtype'),this.getAttribute('parentmatchid'))"><span class="odd"><?php echo $day['odds']['neutral_odd']; ?></span></button></td>
                                                    
                                              </tr>
                                           </table>
								      <?php } else { ?>
                                               <?php echo $empty_row_text; ?>
									  <?php } ?>

                              </td>
                              <td class="clubtwo <?php echo $day['match_id']; ?> <?php
                                          echo clean($day['match_id'].$day['sub_type_id'].$day['away_team']);
                                             if($theMatch && $theMatch['bet_pick']==$day['away_team'] && $theMatch['sub_type_id']==$day['sub_type_id']){
                                                echo ' picked';
                                             }
                                          ?>" width="28%">
										  
                                          <?php if($day['odds']['away_odd']) { ?>
                                <table>
                                   <tr>
                                              <td class=""><button href="javascript:;" class="odds-btn" hometeam="<?php echo $day['home_team']; ?>" oddtype="3 Way" bettype='prematch' awayteam="<?php echo $day['away_team']; ?>" oddvalue="<?php echo $day['odds']['away_odd']; ?>" target="javascript:;" odd-key="<?php echo $day['away_team']; ?>" parentmatchid="<?php echo $day['parent_match_id']; ?>" id="<?php echo $day['match_id']; ?>" custom="<?php echo clean($day['match_id'].$day['sub_type_id'].$day['away_team']); ?>" sub-type-id="<?= $day['sub_type_id']; ?>" special-value-value="0" onClick="addBet(this.id,this.getAttribute('sub-type-id'),this.getAttribute('odd-key'),this.getAttribute('custom'),this.getAttribute('special-value-value'),this.getAttribute('bettype'),this.getAttribute('hometeam'),this.getAttribute('awayteam'),this.getAttribute('oddvalue'),this.getAttribute('oddtype'),this.getAttribute('parentmatchid'))"><span class="odd"><?php echo $day['odds']['away_odd']; ?></span></button></td>
                                              
                                 </tr>
                              </table>
									<?php } else { ?>
                                           <?php echo $empty_row_text; ?>
									 <?php } ?>

                           </td>
                           <td class="sidebet" width="16%">
                                            <a class="<?php if($theMatch && $theMatch['sub_type_id']!= $day['sub_type_id']){echo ' picked';}
                 ?>" href="{{ url('match?id=') }}{{day['match_id']}}"><img src="/img/markets.svg" style="width: 9px !important; padding-bottom: 4px;"> <?php echo $day['side_bets']; ?></a>
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

            <?php endforeach; ?>

        <!-- List matches end -->

          </td>
        </tr>
<!--         <?php if($pages > 1): ?> -->
<!--              <tr class="pagination"> -->
<!--               <td style="text-align:left"> -->
<!--                 <table style="float:left"> -->
<!--                   <tr> -->
<!--                   <?php if($page > 1): ?> -->
<!--                   <td class=""><a href="?page=<?= $page-1; ?>">< </a></td> -->
<!--                   <?php endif; ?> -->
<!--                   <?php for ($x = 0; $x <= $pages-1; $x++): ?>  -->
<!--                     <td class="<?php if($x==$page){ echo 'selected';} ?>"><a href="?page=<?= $x; ?>" ><?= $x+1; ?></a></td> -->
<!--                     <?php endfor; ?> -->
<!--                     <?php if($page == $pages): ?> -->
<!--                     <td class=""><a href="?page=<?= $page+1; ?>">> </a></td> -->
<!--                     <?php endif; ?> -->
<!--                   </tr> -->
<!--                 </table> -->
<!--               </td> -->
<!--         </tr> -->
<!-- <?php endif; ?>      -->
      </table>

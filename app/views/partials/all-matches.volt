<table class="football">
  <th class="title" colspan="2"><?php echo $title; ?></th>
</table>

<!-- List matches -->


<?php 
      function clean($string) {
         $string = str_replace(' ', '-', $string); // Replaces all spaces with hyphens.
         $string = preg_replace('/[^A-Za-z0-9\-]/', '', $string); // Removes special chars.

         return preg_replace('/-+/', '-', $string); // Replaces multiple hyphens with single one.
      }
?>
<table class="highlights" width="100%">
        <tr>
          <td style="padding: 0;">

<!-- List matches -->

          <?php foreach($matches as $day): ?>

            <?php $theMatch = @$betslip[$day->match_id]; 
            ?>

            <table class="highlights--item" width="100%" cellpadding="0" cellspacing="0">
              
              <tr>
                <td colspan="10">
                  <table class="league">
                    <tr >
                      <td style="text-align: left;" class="meta"><span class="uppercase"><?= $day->sport_name ?> </span>- <?php echo $day->competition_name.", ".$day->category; ?></td>
                      <td style="text-align: right;"> <?php echo date('d/m H:i', strtotime($day->start_time)); ?> - Game ID: <?php echo $day->game_id; ?></td>
                    </tr>
                  </table>
                </td>
              </tr>
              
              <tr class="game">
                <td colspan="10">
                  <table width="100%">
                    <tr>
                      <td class="clubs" colspan="2"><?php echo $day->home_team; ?> v. <?php echo $day->away_team; ?></td>
                      <td class="sidebet"><a class="<?php if($theMatch && $theMatch['sub_type_id'] != $day->sub_type_id){echo ' picked';}
             ?>" href="{{ url('match?id=') }}<?= $day->match_id ?>"><img src="/img/markets.svg" style="width: 9px !important; padding-bottom: 4px;"> <?= $day->side_bets; ?></a></td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr class="odds">
                <td class="clubone <?php echo $day->match_id; ?> <?php
                  echo clean($day->match_id.$day->sub_type_id.'1'); 
                     if($theMatch['bet_pick']==$day['home_team'] && $theMatch['sub_type_id']== $day->sub_type_id){
                        echo ' picked';
                     }
                  ?>">
                  <table cellspacing="0" cellpadding="0">
                    <tr>

                      <td class=""><button href="javascript:;" class="" hometeam="<?php echo $day->home_team; ?>" oddtype="3 Way" bettype='prematch' awayteam="<?php echo $day->away_team; ?>" oddvalue="<?php echo $day->home_odd; ?>" target="." odd-key="<?php echo $day['home_team']; ?>" parentmatchid="<?php echo $day->parent_match_id; ?>" id="<?php echo $day->match_id; ?>" custom="<?php echo clean($day->match_id.$day->sub_type_id.$day['home_team']); ?>" sub-type-id="<?= $day->sub_type_id; ?>" special-value-value="0" onClick="addBet(this.id,this.getAttribute('sub-type-id'),this.getAttribute('odd-key'),this.getAttribute('custom'),this.getAttribute('special-value-value'),this.getAttribute('bettype'),this.getAttribute('hometeam'),this.getAttribute('awayteam'),this.getAttribute('oddvalue'),this.getAttribute('oddtype'),this.getAttribute('parentmatchid'))"><span class="pick">1 </span><span class="odd"><?php echo $day->home_odd; ?></span></button></td>

                    </tr>
                  </table>
                </td>

                <?php if($day->sub_type_id == 10): ?>
                <td class="border-td"></td>
                <td class="<?php echo $day->match_id; ?> <?php
                  echo clean($day->match_id.$day->sub_type_id.'X'); 
                     if($theMatch['bet_pick']=='draw' && $theMatch['sub_type_id']==$day->sub_type_id){
                        echo ' picked';
                     }
                  ?>">
                  <table>
                    <tr>
                      <td>
                        <table>
                          <tr>
                            <td class=""><button href="javascript:;" class="" hometeam="<?php echo $day->home_team; ?>" oddtype="3 Way" bettype='prematch' awayteam="<?php echo $day->away_team; ?>" oddvalue="<?php echo $day->neutral_odd; ?>" target="javascript:;" odd-key="draw" parentmatchid="<?php echo $day->parent_match_id; ?>" id="<?php echo $day->match_id; ?>" custom="<?php echo clean($day->match_id.$day->sub_type_id."draw"); ?>" sub-type-id="<?= $day->sub_type_id ?>" special-value-value="0" onClick="addBet(this.id,this.getAttribute('sub-type-id'),this.getAttribute('odd-key'),this.getAttribute('custom'),this.getAttribute('special-value-value'),this.getAttribute('bettype'),this.getAttribute('hometeam'),this.getAttribute('awayteam'),this.getAttribute('oddvalue'),this.getAttribute('oddtype'),this.getAttribute('parentmatchid'))"><span class="pick">x </span><span class="odd"><?php echo $day->neutral_odd; ?></span></button></td>
                            
                          </tr>
                        </table>
                      </td>
                    </tr>
                  </table>
                </td>
            	<?php endif; ?>
                <td class="border-td"></td>
                <td class="clubtwo <?php echo $day->match_id; ?> <?php
                  echo clean($day->match_id.$day->sub_type_id.'2'); 
                     if($theMatch['bet_pick']==$day['away_team'] && $theMatch['sub_type_id']==$day->sub_type_id){
                        echo ' picked';
                     }
                  ?>">
                  <table>
                    <tr>
                      <td class=""><button href="javascript:;" class="" hometeam="<?php echo $day->home_team; ?>" oddtype="3 Way" bettype='prematch' awayteam="<?php echo $day->away_team; ?>" oddvalue="<?php echo $day->away_odd; ?>" target="javascript:;" odd-key="<?php echo $day['away_team']; ?>" parentmatchid="<?php echo $day->parent_match_id; ?>" id="<?php echo $day->match_id; ?>" custom="<?php echo clean($day->match_id.$day->sub_type_id."2"); ?>" sub-type-id="<?= $day->sub_type_id ?>" special-value-value="0" onClick="addBet(this.id,this.getAttribute('sub-type-id'),this.getAttribute('odd-key'),this.getAttribute('custom'),this.getAttribute('special-value-value'),this.getAttribute('bettype'),this.getAttribute('hometeam'),this.getAttribute('awayteam'),this.getAttribute('oddvalue'),this.getAttribute('oddtype'),this.getAttribute('parentmatchid'))"><span class="pick">2 </span><span class="odd"><?php echo $day->away_odd; ?></span></button></td>
                      
                    </tr>
                  </table>
                </td>
              </tr>
            </table>

            <?php endforeach; ?>

<!-- List matches end -->

          </td>
        </tr>
<?php if($pages > 1): ?>
        <tr class="spacer"></tr>
        <tr class="pagination">
          <td>
            <table>
              <tr>
              <?php if($page > 1): ?>
              <td class=""><a href="?page=<?= $page-1; ?>">< </a></td>
              <?php endif; ?>
              <?php for ($x = 0; $x <= $pages-1; $x++): ?> 
                <td class="<?php if($x==$page){ echo 'selected';}?>
    "><a href="?page=<?= $x; ?>" ><?= $x+1; ?></a></td>
                <?php endfor; ?>
                <?php if($page == $pages): ?>
                <td class=""><a href="?page=<?= $page+1; ?>">> </a></td>
                <?php endif; ?>
              </tr>
            </table>
          </td>
        </tr>
<?php endif; ?>     
      </table>

<!-- List matches end -->
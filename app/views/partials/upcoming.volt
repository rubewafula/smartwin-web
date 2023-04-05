<?php 
      function clean($string) {
         $string = str_replace(' ', '-', $string); // Replaces all spaces with hyphens.
         $string = preg_replace('/[^A-Za-z0-9\-]/', '', $string); // Removes special chars.

         return preg_replace('/-+/', '-', $string); // Replaces multiple hyphens with single one.
      }
    ?>

<table class="landing">
  <tr>
    <td>
      <table class="top">
        <tr class="top--image">
          <td>
            <a href="./bingwa4"><img src="./img/featured-image.jpg" width="100%" alt=""></a>
          </td>
        </tr>
        <tr>
          <td>
            {{ partial("partials/hometabs") }}
          </td>
        </tr>

      </table>

      <table class="highlights" width="100%">
        <tr>
          <td style="padding: 0;">

<!-- List matches -->

          <?php foreach($today as $day): ?>

            <?php $theMatch = @$theBetslip[$day['match_id']]; 
            ?>

            <table class="highlights--item" width="100%" cellpadding="0" cellspacing="0">
              
              <tr>
                <td colspan="10">
                  <table class="league">
                    <tr >
                      <td style="text-align: left;" class="meta">UEFA Champions League, Group G, International Clubs</td>
                      <td style="text-align: right;"> <?php echo date('d/m H:i', strtotime($day['start_time'])); ?> - Game ID: <?php echo $day['game_id']; ?></td>
                    </tr>
                  </table>
                </td>
              </tr>
              
              <tr class="game">
                <td colspan="10">
                  <table width="100%">
                    <tr>
                      <td class="clubs" colspan="2"><?php echo $day['home_team']; ?> V. <?php echo $day['away_team']; ?></td>
                      <td class="sidebet"><a href="{{ url('feature') }}">+<?php echo $day['side_bets']; ?></a></td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr class="odds">
                <td class="clubone <?php echo $day['match_id']; ?> <?php
                  echo clean($day['match_id'].$day['sub_type_id'].$day['home_team']);
                     if($theMatch['bet_pick']==$day['home_team'] && $theMatch['sub_type_id']=='1'){
                        echo ' picked';
                     }
                  ?>">
                  <table cellspacing="0" cellpadding="0">
                    <tr>

                      <td class="title"><a href="javascript:;" class="" hometeam="<?php echo $day['home_team']; ?>" oddtype="3 Way" bettype='prematch' awayteam="<?php echo $day['away_team']; ?>" oddvalue="<?php echo $day['home_odd']; ?>" target="javascript:;" odd-key="<?php echo $day['home_team']; ?>" parentmatchid="<?php echo $day['parent_match_id']; ?>" id="<?php echo $day['match_id']; ?>" custom="<?php echo clean($day['match_id'].$day['sub_type_id'].$day['home_team']); ?>" sub-type-id="1" special-value-value="0" onClick="addBet(this.id,this.getAttribute('sub-type-id'),this.getAttribute('odd-key'),this.getAttribute('custom'),this.getAttribute('special-value-value'),this.getAttribute('bettype'),this.getAttribute('hometeam'),this.getAttribute('awayteam'),this.getAttribute('oddvalue'),this.getAttribute('oddtype'),this.getAttribute('parentmatchid'))">1</a></td>
                      <td class="odd"><a href="javascript:;" class="" hometeam="<?php echo $day['home_team']; ?>" oddtype="3 Way" bettype='prematch' awayteam="<?php echo $day['away_team']; ?>" oddvalue="<?php echo $day['home_odd']; ?>" target="javascript:;" odd-key="<?php echo $day['home_team']; ?>" parentmatchid="<?php echo $day['parent_match_id']; ?>" id="<?php echo $day['match_id']; ?>" custom="<?php echo clean($day['match_id'].$day['sub_type_id'].$day['home_team']); ?>" sub-type-id="1" special-value-value="0" onClick="addBet(this.id,this.getAttribute('sub-type-id'),this.getAttribute('odd-key'),this.getAttribute('custom'),this.getAttribute('special-value-value'),this.getAttribute('bettype'),this.getAttribute('hometeam'),this.getAttribute('awayteam'),this.getAttribute('oddvalue'),this.getAttribute('oddtype'),this.getAttribute('parentmatchid'))"><?php echo $day['home_odd']; ?></a></td>

                    </tr>
                  </table>
                </td>
                <td class="border-td"></td>
                <td class="draw <?php echo $day['match_id']; ?> <?php
                  echo clean($day['match_id'].$day['sub_type_id'].'draw');
                     if($theMatch['bet_pick']=='draw' && $theMatch['sub_type_id']=='1'){
                        echo ' picked';
                     }
                  ?>">
                  <table>
                    <tr>
                      <td>
                        <table>
                          <tr>
                            <td class=""><a href="javascript:;" class="" hometeam="<?php echo $day['home_team']; ?>" oddtype="3 Way" bettype='prematch' awayteam="<?php echo $day['away_team']; ?>" oddvalue="<?php echo $day['home_odd']; ?>" target="javascript:;" odd-key="draw" parentmatchid="<?php echo $day['parent_match_id']; ?>" id="<?php echo $day['match_id']; ?>" custom="<?php echo clean($day['match_id'].$day['sub_type_id']."draw"); ?>" sub-type-id="1" special-value-value="0" onClick="addBet(this.id,this.getAttribute('sub-type-id'),this.getAttribute('odd-key'),this.getAttribute('custom'),this.getAttribute('special-value-value'),this.getAttribute('bettype'),this.getAttribute('hometeam'),this.getAttribute('awayteam'),this.getAttribute('oddvalue'),this.getAttribute('oddtype'),this.getAttribute('parentmatchid'))">x</a></td>
                            <td class="odd"><a href="javascript:;" class="" hometeam="<?php echo $day['home_team']; ?>" oddtype="3 Way" bettype='prematch' awayteam="<?php echo $day['away_team']; ?>" oddvalue="<?php echo $day['home_odd']; ?>" target="javascript:;" odd-key="draw" parentmatchid="<?php echo $day['parent_match_id']; ?>" id="<?php echo $day['match_id']; ?>" custom="<?php echo clean($day['match_id'].$day['sub_type_id']."draw"); ?>" sub-type-id="1" special-value-value="0" onClick="addBet(this.id,this.getAttribute('sub-type-id'),this.getAttribute('odd-key'),this.getAttribute('custom'),this.getAttribute('special-value-value'),this.getAttribute('bettype'),this.getAttribute('hometeam'),this.getAttribute('awayteam'),this.getAttribute('oddvalue'),this.getAttribute('oddtype'),this.getAttribute('parentmatchid'))"><?php echo $day['neutral_odd']; ?></a></td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                  </table>
                </td>
                <td class="border-td"></td>
                <td class="clubtwo <?php echo $day['match_id']; ?> <?php
                  echo clean($day['match_id'].$day['sub_type_id'].$day['away_team']);
                     if($theMatch['bet_pick']==$day['away_team'] && $theMatch['sub_type_id']=='1'){
                        echo ' picked';
                     }
                  ?>">
                  <table>
                    <tr>
                      <td class="title"><a href="javascript:;" class="" hometeam="<?php echo $day['home_team']; ?>" oddtype="3 Way" bettype='prematch' awayteam="<?php echo $day['away_team']; ?>" oddvalue="<?php echo $day['home_odd']; ?>" target="javascript:;" odd-key="<?php echo $day['away_team']; ?>" parentmatchid="<?php echo $day['parent_match_id']; ?>" id="<?php echo $day['match_id']; ?>" custom="<?php echo clean($day['match_id'].$day['sub_type_id'].$day['away_team']); ?>" sub-type-id="1" special-value-value="0" onClick="addBet(this.id,this.getAttribute('sub-type-id'),this.getAttribute('odd-key'),this.getAttribute('custom'),this.getAttribute('special-value-value'),this.getAttribute('bettype'),this.getAttribute('hometeam'),this.getAttribute('awayteam'),this.getAttribute('oddvalue'),this.getAttribute('oddtype'),this.getAttribute('parentmatchid'))">2</a></td>
                      <td class="odd"><a href="javascript:;" class="" hometeam="<?php echo $day['home_team']; ?>" oddtype="3 Way" bettype='prematch' awayteam="<?php echo $day['away_team']; ?>" oddvalue="<?php echo $day['home_odd']; ?>" target="javascript:;" odd-key="<?php echo $day['away_team']; ?>" parentmatchid="<?php echo $day['parent_match_id']; ?>" id="<?php echo $day['match_id']; ?>" custom="<?php echo clean($day['match_id'].$day['sub_type_id'].$day['away_team']); ?>" sub-type-id="1" special-value-value="0" onClick="addBet(this.id,this.getAttribute('sub-type-id'),this.getAttribute('odd-key'),this.getAttribute('custom'),this.getAttribute('special-value-value'),this.getAttribute('bettype'),this.getAttribute('hometeam'),this.getAttribute('awayteam'),this.getAttribute('oddvalue'),this.getAttribute('oddtype'),this.getAttribute('parentmatchid'))"><?php echo $day['away_odd']; ?></a></td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>

            <?php endforeach; ?>

<!-- List matches end -->

          </td>
        </tr>
        <tr class="spacer"></tr>
        <tr class="pagination">
          <td>
            <table>
              <tr>
              <td class=""><a href="?page=<?= $page-1; ?>">< </a></td>
              <?php for ($x = 0; $x <= $pages; $x++): ?> 
                <td class="<?php if($x==$page){ echo 'selected';}?>
    "><a href="?page=<?= $x; ?>" ><?= $x+1; ?></a></td>
                <?php endfor; ?>
                <td class=""><a href="?page=<?= $page+1; ?>">> </a></td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
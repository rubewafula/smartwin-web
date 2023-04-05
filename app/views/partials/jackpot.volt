<?php 
  function clean($string) {
     $string = str_replace(' ', '-', $string); // Replaces all spaces with hyphens.
     $string = preg_replace('/[^A-Za-z0-9\-]/', '', $string); // Removes special chars.

     return preg_replace('/-+/', '-', $string); // Replaces multiple hyphens with single one.
  }
?>
<?php

   if(!empty($jackpotMeta)){
      ?>
        <table class="jp">
          <tr class="title jackpot-header" style="background-color: #16202C; color: white; text-transform:uppercase;">
            <td>
            <?php echo $jackpotMeta['type'];?> JACKPOT - <?php echo $jackpotMeta['name'];?>
            </td>
          </tr>
          <tr class="title jackpot-header" style="background-color: #16202C; color: white; text-transform:uppercase;"> 
            <td>
             <span class="meta" style="color: white;"><?php echo $jackpotMeta['total_games'];?> Games </span>
            </td>
          </tr>
          <tr class="title jackpot-header" style="background-color: #16202C; color: white; text-transform:uppercase;"> 
            <td>
              <span class="meta jackpot-amount"><?php echo $jackpotMeta['jackpot_amount'];?>/=</span>
            </td>
          </tr>
          <tr>
            <td>
              <table class="highlights" width="100%">
                <tr>
                  <td style="padding: 0;">
                    <table width="100%" cellpadding="0" cellspacing="0" class="mkt-headers" style="background: darkslategrey !important; color:#fff;">
                      <tbody>
                        <tr>
                            <td width="50%" style="float:left; text-align:left;">JACKPOT</td>
                        <td width="50%">
                          {% if jackpotMeta['status'] == 'INACTIVE' %}
                          <table width="99%" cellpadding="0" cellspacing="0">
                            <tr>
                              <td width="100%">RESULTS</td>
                            </tr>
                          </table>
                          {% else %}
                          <table width="99%" cellpadding="0" cellspacing="0">
                            <tr>
                              <td width="27%">1</td>
                              <td width="27%">X</td>
                              <td width="27%">2</td>
                              <td width="15%"></td>
                            </tr>
                          </table>
                          {% endif %}
                        </td>
                      </tr>
                      </tbody>
                    </table>
                  </td>
                </tr>
                <tr>
                  <td style="padding: 0;">
                    {{ this.flashSession.output() }}
                    <!-- List matches -->

                    <?php foreach($games as $day): ?>

                    <?php
                       $theMatch = @$theBetslip[$day['match_id']];
                       $odds = $day['odds'];
                       $home_odd = $odds['home_odd'];
                       $neutral_odd = $odds['neutral_odd'];
                       $away_odd = $odds['away_odd'];
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
                                      <?php echo $day['game_id']; ?>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td style="text-transform: uppercase">
                                      <?php echo $day['home_team']; ?>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td style="text-transform: uppercase">
                                      <?php echo $day['away_team']; ?>
                                    </td>
                                  </tr>
                                  </tbody>
                                </table>
                              </td>
                              <td style="text-align: left; vertical-align:top;" class="meta" width="50%">
                                <table {% if jackpotMeta['status'] == 'INACTIVE' %} style="width:100%; text-align:center"{%endif%} >
                                  <tbody>
                                  <tr>
                                    <td {% if jackpotMeta['status'] == 'INACTIVE' %} style="width:33%;"{%else%} style="opacity:0.75;"{%endif%}>
                                      <?php echo $day['start_time']; ?>
                                    </td>
                                     {% if jackpotMeta['status'] == 'INACTIVE' %}
                                        <td style="width:33%;" ><?= $day['outcome']; ?></td>
                                        <td style="width:33%;"><?= $day['winning_outcome']; ?></td>
                                     </tr>
                                     {% endif %}
                                 {% if jackpotMeta['status'] == 'ACTIVE' %}
                                  </tr>
                                  <tr class="odds">
                                    <td width="33%" class="clubone <?php echo $day['match_id']; ?> <?php
                              echo clean($day['match_id'].$day['sub_type_id'].$day['home_team']);
                                 if($theMatch['bet_pick']==$day['home_team'] && $theMatch['sub_type_id']=='1'){
                                    echo ' picked';
                                 }
                              ?>">
                                      <table cellspacing="0" cellpadding="0">
                                        <tr>

                                          <td class="">
                                            <button href="javascript:;" class="" pos="<?= $day['pos']; ?>" hometeam="<?= $day['home_team']; ?>" oddtype="3 Way" bettype='jackpot' awayteam="<?php echo $day['away_team']; ?>" oddvalue="<?php echo $home_odd; ?>" target="javascript:;" odd-key="<?php echo $day['home_team']; ?>" parentmatchid="<?php echo $day['parent_match_id']; ?>" id="<?php echo $day['match_id']; ?>" custom="<?php echo clean($day['match_id'].$day['sub_type_id'].$day['home_team']); ?>" sub-type-id="1" special-value-value="0" onClick="addBet(this.id,this.getAttribute('sub-type-id'),this.getAttribute('odd-key'),this.getAttribute('custom'),this.getAttribute('special-value-value'),this.getAttribute('bettype'),this.getAttribute('hometeam'),this.getAttribute('awayteam'),this.getAttribute('oddvalue'),this.getAttribute('oddtype'),this.getAttribute('parentmatchid'),this.getAttribute('pos'))"><span class="pick"> </span><span class="odd"><?php echo $home_odd; ?></span></button></td>


                                        </tr>
                                      </table>
                                    </td>
                                    <td width="33%" class="draw <?php echo $day['match_id']; ?> <?php
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
                                                <td class="">
                                                  <button href="javascript:;" class="" hometeam="<?php echo $day['home_team']; ?>" pos="<?= $day['pos']; ?>" oddtype="3 Way" bettype='jackpot' awayteam="<?php echo $day['away_team']; ?>" oddvalue="<?php echo $home_odd; ?>" target="javascript:;" odd-key="draw" parentmatchid="<?php echo $day['parent_match_id']; ?>" id="<?php echo $day['match_id']; ?>" custom="<?php echo clean($day['match_id'].$day['sub_type_id'].'draw'); ?>" sub-type-id="1" special-value-value="0" onClick="addBet(this.id,this.getAttribute('sub-type-id'),this.getAttribute('odd-key'),this.getAttribute('custom'),this.getAttribute('special-value-value'),this.getAttribute('bettype'),this.getAttribute('hometeam'),this.getAttribute('awayteam'),this.getAttribute('oddvalue'),this.getAttribute('oddtype'),this.getAttribute('parentmatchid'),this.getAttribute('pos'))"><span class="pick"> </span><span class="odd"><?php echo $neutral_odd; ?></span></button></td>

                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                    <td width="33%" class="clubtwo <?php echo $day['match_id']; ?> <?php
                              echo clean($day['match_id'].$day['sub_type_id'].$day['away_team']);
                                 if($theMatch['bet_pick']==$day['away_team'] && $theMatch['sub_type_id']=='1'){
                                    echo ' picked';
                                 }
                              ?>">
                                      <table>
                                        <tr>
                                          <td class=""><button href="javascript:;" class="" pos="<?= $day['pos']; ?>" hometeam="<?php echo $day['home_team']; ?>" oddtype="3 Way" bettype='jackpot' awayteam="<?php echo $day['away_team']; ?>" oddvalue="<?php echo $home_odd; ?>" target="javascript:;" odd-key="<?php echo $day['away_team']; ?>" parentmatchid="<?php echo $day['parent_match_id']; ?>" id="<?php echo $day['match_id']; ?>" custom="<?php echo clean($day['match_id'].$day['sub_type_id'].$day['away_team']); ?>" sub-type-id="1" special-value-value="0" onClick="addBet(this.id,this.getAttribute('sub-type-id'),this.getAttribute('odd-key'),this.getAttribute('custom'),this.getAttribute('special-value-value'),this.getAttribute('bettype'),this.getAttribute('hometeam'),this.getAttribute('awayteam'),this.getAttribute('oddvalue'),this.getAttribute('oddtype'),this.getAttribute('parentmatchid'),this.getAttribute('pos'))"><span class="pick"> </span><span class="odd"><?php echo $away_odd; ?></span></button></td>

                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                    {% endif %}
                                  </tbody>
                                </table>
                              </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                    </table>

                    <?php endforeach; ?>


                  </td>
                </tr>
                <tr class="spacer"></tr>
              </table>
            </td>
          </tr>
        </table>
        {% if jackpotMeta['status'] == 'ACTIVE' %}
        <div class="placebet">
          <?php echo $this->tag->form("betslip/betJackpot"); ?>
          <input type="hidden" id="user_id" name="user_id" value="{{session.get('auth')['id']}}">
          <input type="hidden" name="jackpot_type" id="jackpot_type" value="8" >
          <input type="hidden" name="src" id="src" value="mobile" >
          <input type="hidden" name="jackpot_id" id="jackpot_id" value="{{jackpotID}}" >
          <div class="total-stake" style="color: white"><span class="met" style="color: white">Total Stake: </span><span class="stake-amt" style="color: white"><?php echo $amount;?>/=</span></div>



          <!-- if session.get('auth') != null %} -->
          <button type="submit" id="place_bet_button" class="place" onclick="fbJackpot()">Place Bet</button>
          <!-- else %}
        <a href="{{url('login')}}?ref=jackpot" class="place dark-gray login-button">Login to Bet</a>
          endif %} -->
          </form>
        </div>
         {% endif %}
      <?php
   }else{
    ?>
      <div style="color: white; text-align: center; box-shadow: 1px 1px 1px 1px #1C313B; margin-top: 2px">
        There are no active jackpots at the moment.
      </div>
    <?php
   }

?>

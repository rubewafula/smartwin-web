<table width="100%" class="betslip top">
                <th class="title" colspan="10">BETSLIP</th>
                <tr>
                  <td colspan="10">



                     <div class="alert alert-danger">
                         {{ this.flashSession.output() }}
                     </div>

              <?php
                $matchCount = 0;
                $bonus = 0;
                $bonusOdds = 1;
              ?>

              <?php foreach((array)$betslip as $bet): ?>
                <?php
                  if (!$bet){continue;}
                  $odd = $bet['odd_value'];

                  if($bet['bet_pick']=='x'){
                      $pick = 'DRAW';
                  }else if($bet['bet_pick']=='2'){
                      $pick = $bet['away_team'];
                  }else if($bet['bet_pick']=='1'){
                      $pick = $bet['home_team'];
                  }
                  else{
                      $pick = $bet['bet_pick'];
                  }

                  if($bet['odd_value']>=1.6){
                  $bonusOdds*=$odd;
                  $matchCount++;
                  }

                  ?>
                    <table class="bet">
                      <tr>
                        <td class="padding-up-down" colspan="10">
                          <table width="100%">
                            <tr style="background: #f3f3f3">
                              <td>
                                <table>
                                  <tr class="game">
                                    <td>

                                    <?php
                                    if(isset($bet['bet_type']) && $bet['bet_type'] == 'live'){
                                      echo '<span style="color:red">Live </span>';
                                    }

                                    if($bet['away_team']=='na'){
                                      echo $bet['home_team']; 
                                      }
                                      else{
                                        echo $bet['home_team']." v ".$bet['away_team'];
                                      }

                                    ?>


                                    </td>
                                  </tr>
                                  <tr>
                                    <td class=""><?php echo $bet['bet_type'].' : '; echo $bet['odd_type']; ?></td>
                                  </tr>
                                  <tr style="color: #101b25">
                                    <td>Your Pick: <?= $pick; ?></td>
                                  </tr>
                                </table>
                              </td>
                              <td class="odd-del">
                                <table style="width:100%;text-align:center;">
                                  <tr>
                                  <?php echo $this->tag->form("betslip/remove?bs=1"); ?>
                                    <td class="delete">
                                    <input type="hidden" name="match_id" value="{{bet['match_id']}}">
                                    <button class="remove-match" type="submit" value="submit">X</button>
                                    </td>
                                  </form>
                                  </tr>
                                  <tr>
                                    <td></td>
                                  </tr>
                                  <tr>
                                    <td class="odd"><?php echo $bet['odd_value']; ?></td>
                                  </tr>
                                 
                                </table>
                              </td>

                            </tr>
                          </table>
                        </td>
                      </tr>
                      <?php if(isset($bet['market_status']) && $bet['market_status']!='Market active') { ?>
                             
                                  <tr>
                                    <td class="odd" style="color:red;padding-left:10px;"><?php echo $bet['market_status']; ?></td>
                                  </tr>
                                  
                              
                              <?php } ?>
                    </table>
                <?php endforeach; ?>

                  </td>
                </tr>
				</table>

               <?php if(count($betslip)){ ?>
				<!-- begin betslip bottom fixed pane -->
                <table width="100%" class="betslip full-width" style="overflow:hidden; border-top:2px solid #16202C;">
                <tr class="details" style="">
                  <td class="left" colspan="3">
                    <?php echo $this->tag->form("betslip/placebet"); ?>
                        <table width="100%">
                          <tr>
                            <td>ToTAL ODDS</td>
                            <td class="text-right bold" id="total_odds_id"><?= $betslip_data['total_odd']; ?></td>
                          </tr>
                          <tr>
                            <td>BET AMOUNT</td>
                            <td class="text-right"><input type="number" id="stake_amount" class="stake" name="stake" onkeyup="updateWinning()" value="<?= $betslip_data['bet_amount']; ?>"></td>

                          </tr>
                          <tr>
                            <td>STAKE AFTER TAX</td>
                            <td class="text-right bold" id="stake_after_tax_id"><?= $betslip_data['stake_after_tax']; ?></td>
                          </tr>
                          <tr>
                            <td>7.5 % EXCISE TAX</td>
                            <td class="text-right bold" id="excise_tax_id"><?= $betslip_data['excise_tax']; ?></td>
                          </tr>
                          <tr >
                            <td>POSSIBLE WINNINGS</td>
                            <td class="text-right bold" id="raw_possible_win_id"><?= $betslip_data['raw_possible_win']; ?></td>
                          </tr>
                          <tr >
                            <td>20% WITHHOLDING TAX</td>
                            <td class="text-right bold" id="withholding_tax_id"><?= $betslip_data['withholding_tax']; ?></td>
                          </tr>
                          <tr style="background:#902065;">
                            <td>KIBOKO BONUS</td>
                            <td class="text-right bold" id="kiboko_bonus_id"><?= $betslip_data['withholding_tax']; ?></td>
                          </tr>

                        </table>
                      <table width="100%" >
                        <tr>
                          <td>NET WINNINGS</td>
                          <td class="text-right bold" id="net_win_id"><?= $betslip_data['possible_win'] ?></td>
                        </tr>

                        <tr>
                          <td>&nbsp;</td>
                          <td width="50%">
                          <!-- echo $this->tag->form("betslip/placebet");  -->
                          <input type="hidden" name="msisdn" value="{{session.get('auth')['mobile']}}">
                          <input type="hidden" name="src" value="mobile">
                          <input type="hidden" id="user_id" name="user_id" value="{{session.get('auth')['id']}}">
                          <input type="hidden" id="total_odd_m" name="total_odd" value="<?= $betslip_data['total_odd']; ?>">
                          <input type="hidden" id="possible_win" name="possible_win" value="<?= $betslip_data['possible_win'] ?>">
                          {% if session.get('auth') != null %}
                          <button type="submit" class="place" >BET NOW</button>
                          {% else %}
                          <a style="color:#000000 !important" href="{{url('login')}}?ref=betslip" class="place dark-gray login-button">BET NOW</a>
                          {%  endif %}
                          </td>

                        </tr>
                      </table>

                      </form>
                    </td>
                </tr>
                <tr class="spacer"></tr>
                <tr>
                  <td class="" colspan="10" style="background-color:#ff1a1a">
                    <?php echo $this->tag->form("betslip/clearslip"); ?>
                      <input type="hidden" name="src" value="mobile">
                      <button type="submit" class="delete-all">Delete All</button>
                    </form>
                  </td>
                </tr>
              </table>

			  <!-- end slip footer -->
              <script type="text/javascript" >
                function updateWinning(){
                   var bamount = document.getElementById("stake_amount").value;
                   var total_odd = document.getElementById("total_odd_m").value;
                   var stake_after_tax = bamount/107.5*100;
                   var excise_tax = bamount - stake_after_tax;
                   var raw_win = stake_after_tax*total_odd;

                   var withholding_tax = (raw_win -bamount)*0.2;
                   var net_wi = raw_win -withholding_tax;

                   var stake_after_tax_id = document.getElementById("stake_after_tax_id");
                   stake_after_tax_id.innerHTML = stake_after_tax.toFixed(2);

                   var poss_id = document.getElementById("raw_possible_win_id");
                   poss_id.innerHTML = raw_win.toFixed(2);

                   var excise_tax_id = document.getElementById("excise_tax_id")
                   excise_tax_id.innerHTML = excise_tax.toFixed(2)


                   var new_win_id = document.getElementById("net_win_id")
                   net_win_id.innerHTML = net_wi.toFixed(2);


                   var withholding_tax_id = document.getElementById("withholding_tax_id");
                   withholding_tax_id.innerHTML = withholding_tax.toFixed(2);
                   
                   var koboko_bonus_id = document.getElementById("kiboko_bonus_id");
                   kiboko_bonus_id.innerHTML = withholding_tax.toFixed(2);

                   var total_odds_id = document.getElementById("total_odds_id");
                   total_odds_id.innerHTML = total_odd;

                   return false;

                }
              </script>
              <?php } ?>


<style>
.alert-danger {
    color: #a94442;
    background-color: #f2dede;
    border-color: #ebccd1;
}

.alert {
    border: 1px solid transparent;
    border-radius: 4px;
}
</style>

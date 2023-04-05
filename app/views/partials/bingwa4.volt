<?php 
      function clean($string) {
         $string = str_replace(' ', '-', $string); // Replaces all spaces with hyphens.
         $string = preg_replace('/[^A-Za-z0-9\-]/', '', $string); // Removes special chars.

         return preg_replace('/-+/', '-', $string); // Replaces multiple hyphens with single one.
      }
?>
<table class="bingwa4">
  <th class="title">Correct - KES. 2,500,000 <br><span class="meta">{{startTime}}</span> </th>
  <tr>
    <td>
      <tr>
        <td>
          <div class="errorMessage">{{ this.flashSession.output() }} </div>
           <div class="jp-matches">  
          <?php foreach($games as $day): ?>
          <?php
             $theMatch = @$theBetslip[$day['match_id']];
             $odds = $day['correctscore'];
             $scores = explode(',',$odds);
          ?>

            <div class="row">

             <div class="teams">
                      <span class="bold"><?php echo $day['pos'].". ".$day['home_team']; ?></span> v <span class="bold"><?php echo $day['away_team']; ?></span><br>
                      <span class="meta sml">Date: <?php echo date('d/m', strtotime($day['start_time'])); ?> 
                      <?php echo date('H:i', strtotime($day['start_time'])); ?></span>
              </div>

            <?php foreach($scores as $score): ?>
            <button class="<?php echo $day['match_id']; ?> <?php echo clean($day['match_id'].$day['sub_type_id'].@$day['odd_key'].$day['special_bet_value'].$score); 
                              if($theMatch['bet_pick']==$score && $theMatch['sub_type_id']=='332'){
                                  echo ' picked';
                               }
                            ?>" pos="<?= $day['pos']; ?>" hometeam="<?php echo $day['home_team']; ?>" oddtype="Correct four Jackpot" bettype='bingwafour' awayteam="<?php echo $day['away_team']; ?>" parentmatchid="<?php echo $day['parent_match_id']; ?>" oddvalue="1" value="332" custom="<?php echo clean($day['match_id'].$day['sub_type_id'].$day['odd_key'].@$day['special_bet_value'].$score); ?>" bet-type="bingwafour" odd-key="<?= $score; ?>" target="javascript:;" id="<?php echo $day['match_id']; ?>" onclick="addBet(this.id,this.value,this.getAttribute('odd-key'),this.getAttribute('custom'),this.getAttribute('special-value-value'),this.getAttribute('bettype'),this.getAttribute('hometeam'),this.getAttribute('awayteam'),this.getAttribute('oddvalue'),this.getAttribute('oddtype'),this.getAttribute('parentmatchid'),this.getAttribute('pos'))"><span class="theteam col-sm-12"> <?php echo $score; ?> </span></button>
            <?php endforeach; ?>

          </div>

          <?php endforeach; ?>

          </div>
        </td>
      </tr>
    </td>
  </tr>
</table>
<div class="placebet">
<?php echo $this->tag->form("betslip/betJackpot"); ?>
<input type="hidden" id="user_id" name="user_id" value="{{session.get('auth')['id']}}">
             <input type="hidden" name="jackpot_type" id="jackpot_type" value="5" >
             <input type="hidden" name="src" id="src" value="mobile" >
             <input type="hidden" name="jackpot_id" id="jackpot_id" value="{{jackpot_id}}" >
 <div class="total-stake"><span class="met">Total Stake: </span><span class="stake-amt">KES. 1000</span></div>

{% if session.get('auth') != null %}
<input type="hidden" name="account" id="account" value="1" />
<button type="submit" id="place_bet_button" class="place">Place Bet</button>
{% else %}
<input type="hidden" name="account" id="account" value="0" />
<input type="text" name="msisdn" id="msisdn" value="" placeholder="255XXXXXXXXXX" />
<button type="submit" id="place_bet_button" class="place">Bet Bila Account</button>
<div clas="">&nbsp;</div>
<a href="{{url('login')}}?ref=correct" class="place dark-gray login-button">Login to Bet</a>
{% endif %}
 </form>
</div>

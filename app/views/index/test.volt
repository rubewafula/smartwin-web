{% if freebet and session.get('auth')['freebie'] is defined and session.get('auth')['freebie'] == 1 %}
<?php list($home_odd, $neutral_odd, $away_odd) = explode(",", $freebet['odds']); ?>
<table id="free-bet" width="100%" style="background:#fff; margin-bottom: 5px; padding:0; border-collapse:collapse;border-left: 2px solid #d4d4d4;
border-right: 2px solid #d4d4d4; border-radius:5px;">
	<tr>
		<td style="color:#fff; background:red; padding:5px; font-size:12px; ">Congratulations! You won Free Bet (Stake KES 20)!</td>
	</tr>
	<tr>
		<td >
			<table width="100%" style="text-align:center; vertical-align:middle">
			</tr>
				<td><div class="btn"><?= $freebet['home_team'] . ' VS '. $freebet['away_team']; ?></div></td>
			</tr>
			<tr>
				<td><div class="btn"><?= $freebet['start_time'] ; ?></td>
			</tr>
		   </table>

		</td>
	</tr>
	<tr>
	    <td class="">
		<table width="100%" style="text-align:center; vertical-align:middle">
			</tr>
				<td><div id="free-bet-home-win" class="freebet-btn" data-pick="1"  data-pmid="{{freebet['parent_match_id']}}" data-odd-value="{{home_odd}}" onclick="prepareFreeBet(this)">1<br/>{{home_odd}}</div></td>
				<td><div id="free-bet-draw" class="freebet-btn" data-pick="X" data-pmid="{{freebet['parent_match_id']}}" data-odd-value="{{neutral_odd}}" onclick="prepareFreeBet(this)">X<br/>{{neutral_odd}}</div></td>
				<td><div id="free-bet-away-win" class="freebet-btn" data-pick="2"  data-pmid="{{freebet['parent_match_id']}}" data-odd-value="{{away_odd}}" onclick="prepareFreeBet(this)">2<br/>{{away_odd}}</div></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
	    <td>

			<table width="100%" style="text-align:center; vertical-align:middle">
				<td style="align-contents:left" width="35%">&nbsp;</td>
				<td style="align-contents:right"><div style="font-size:11px; color:red">Possible Win <span id="free-possible-win">20</span></div></td>
				<td style="align-contents:right">
					<form name="place-free-bet" id="place-free-bet" action="/betslip/freebet" method="post">
						<input type="hidden" value="" name="bet_pick"  id="free-bet-pick"/>
						<input type="hidden" value="" name="parent_match_id" id="free-bet-pmid"/>
						<input type="hidden" value="" name="sub_type_id" id="free-bet-sbid" />
						<input type="hidden" name="profile_id" value="{% if session.get('auth') %}{{session.get('auth')['id']}}{% endif%}" id="free-bet-profile-id"/>
						<input type="submit" class="freebet-text place" id="free-bet-submit-btn"
							style="float:right; margin-bottom:5px; margin-right:2px; text-align:center; color:#000; background-color:#999; font-size:11px; width:100%;" 
							value="CLAIM NOW" disabled="disabled"/>

					</form>
				</td>
			</table>

		</td>
	</tr>

</table>
<script type="text/javascript" >
    function prepareFreeBet(d){
       var bamount = 20;
	   var pick=d.getAttribute("data-pick");
	   var parent_match_id =d.getAttribute("data-pmid");
	   var odd_value =d.getAttribute("data-odd-value");
	   var selected =d.getAttribute("id");

       document.getElementById('free-bet-home-win').classList.remove("picked");
       document.getElementById('free-bet-draw').classList.remove("picked");
       document.getElementById('free-bet-away-win').classList.remove("picked");

       document.getElementById(selected).classList.add("picked");

       document.getElementById("free-bet-pick").value = pick;
       document.getElementById("free-possible-win").innerHTML = odd_value*20;
       document.getElementById("free-bet-sbid").value = 1;
       document.getElementById("free-bet-pmid").value = parent_match_id;
	   var submit = document.getElementById("free-bet-submit-btn");
	   submit.removeAttribute('disabled')
	   submit.style.backgroundColor = '#FFD800';
       return false;

    }
  </script>
{% else %} 
    <a href="/index" style=""><img  width="100%"  src="/img/banner.jpeg" alt="Claim your FREEBET NOW" /> </a>
{%endif%}
<table id="main">
  <tr>
    <td>
      {{ partial('partials/matches') }}
    </td>
  </tr>
</table>

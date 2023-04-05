
<table id="main" class="mybets">
  <th class="title"> JAMVI <?= $myBet['status'] == 200? "- Pay Online" : "" ?><br> </th>
  <tr>
  </tr>
    <td>
      <table class="highlights--item" width="100%">
        <tr>
          <td style="padding: 0;">
            <!-- {{ this.flashSession.output() }} -->

	<?php 
	$created = strtotime($myBet['created']);
	$nowT = date("Y-m-d H:i:s");
	$nowTime = strtotime($nowT);
	$interval  = abs($nowTime - $created);
	$minutes   = round($interval / 60);
	?>
    <table class="login" width="100%" cellpadding="0" cellspacing="0"> 
        <?php 
        $diff = strtotime(date('Y-m-d H:i:s')) - strtotime($myBet['created']);

        $pasttime = $diff/60/60;

        if($myBet['status'] == 200 && $pasttime <=15 ){
	        echo "<tr><td>";
	        echo "<div class='bet-message alert alert-info'>"; 
	        echo "<p>Lipia kukamilisha bet yako. Tiketi/kumbukumbu No. ".$myBet['bet_id'].", Mechi ulizochagua ni ".sizeof($betDetails).", Kiasi ulichobet TZS ".$myBet['bet_amount'].", Ushindi wako TZS ".$myBet['raw_possible_win'].". No ya kampuni 101010</p>";
	        echo "</div>";

            if(isset($_GET['msg']) && $_GET['msg'] == 'FAILED'){
		        echo '<p style="color:red !important; font-weight: bold; font-style:italic;">Haijafanikiwa kulipa. Lipia tena.</p>';
          	}
          	echo "</td></tr>";
	       ?>
          <tr><td>
	        <table>
	          <tr>
	            <td colspan=3>
	             Chagua mfumo wa kipia:
	            </td>
	          </tr>
	          <tr>
	           <td> <a href='#tigopesa' onclick="showTigoForm(this)" data-method='Tigopesa'><img src='/img/tigopesa.png' /></a> </td>
               <td><a href='#mpesa'  onclick="showMpesaForm(this)"  data-method='Mpesa'><img src='/img/mpesa1.png' /></a> </td>
               <td><a href='#airtelmoney'  onclick="showAirtelForm(this)" data-method='airtelmoney'><img src='/img/airtelmoney.png' /></a> </td>
	          </tr>
	        </table>

          </td></tr>
          <tr><td class="payment-tabs-container">
              <table class="payment-tab form" id="tigopesa">
               <tr class="input">
                 <td>
                         <div><h4>Lipia kwa Tigopesa</h4></div>
                          <form action='/paybet' method='get' class='payment-form'>
                              <input type='hidden' name='ref' value='{{myBet['bet_id']}}' />
                              <input type='hidden' id='pmethod' name='payment_method' value='Tigopesa' />
                              <input type='hidden' name='amount' value='{{myBet['bet_amount']}}' />

                               <div class='form-group-'>
                                 <label for='msisdn'>Namba ya simu</label>
                                 <input class='form-control' type="text" id='msisdn' name='msisdn' value='' style="width:96%"  placeholder='' />
                               </div>
                               <div><input type='submit' value='Bofya hapa kulipia' class='btn btn-primary' /></div>
                           </form>
                 </td>
               </tr>
              </table>

			  <table class="payment-tab form" id="mpesa">
               <tr class="input">
                 <td>
					<div><h4>Lipia kwa M-Pesa</h4></div>
					<p style="display:none">
					1. Dial *150*00#<br/>
					2. Lipa kwa M-Pesa<br/>
					3. Weka namba ya kampuni: 101010<br/>
					4. Weka kumbukumbu namba: {{myBet['bet_id']}}<br/>
					5. Weka kiwango: {{myBet['bet_amount']}}<br/>
					6. Weka neno siri kukamilisha malipo
					</p>
                         <form action='/paybet' method='get' class='payment-form'>
                             <input type='hidden' name='ref' value='{{myBet['bet_id']}}' />
                             <input type='hidden' id='pmethod' name='payment_method' value='Tigopesa' />
                             <input type='hidden' name='amount' value='{{myBet['bet_amount']}}' />

                            <div class='form-group-'>
                                <label for='msisdn'>Namba ya simu</label>
                                <input class='form-control' type="text" id='msisdn' name='msisdn' value='' style="width:96%"  placeholder='' />

                                <input type='submit' value='Bofya hapa kulipia' class='btn btn-primary' />
                            </div>
                        </form>

                 </td>
               </tr>
              </table>

              <table class="payment-tab form" id="airtelmoney">
               <tr class="input">
                 <td>
				    <div><h4>Lipia kwa Airtel Money</h4></div>

				    <p style='display: none'>
				        1. Dial *150*60#<br/>
					    2. Lipa bili<br/>
					    3. Weka namba ya kampuni: 101010<br/>
					    4. Weka kumbukumbu namba: {{myBet['bet_id']}}<br/>
					    5. Weka kiwango: {{myBet['bet_amount']}}<br/>
					    6. Weka neno siri kukamilisha malipo
				    </p>
                        <form action='/paybet' method='get' class='payment-form'>
                            <input type='hidden' name='ref' value='{{myBet['bet_id']}}' />
                            <input type='hidden' id='pmethod' name='payment_method' value='Tigopesa' />
                            <input type='hidden' name='amount' value='{{myBet['bet_amount']}}' />

                            <div class='form-group-'>
                                <label for='msisdn'>Namba ya simu</label>
                                <input class='form-control' type="text" id='msisdnAirtel' name='msisdn' value='' style="width:96%"  placeholder='' />
                            </div>
                            <div>
                                <input type='submit' value='Bofya hapa kulipia' class='btn btn-primary' />
                            </div>
                        </form>
                 </td>
               </tr>
              </table>

         </td></tr>
       <?php } else if($pasttime <=15) {
            echo "<tr></td>";
			echo "<div class='bet-message alert alert-success'>";
			echo "Umelipia jamvi lako namba ".$myBet['bet_id'].", lenye mechi ".sizeof($betDetails).". Ushindi wako ni TZS ".$myBet['raw_possible_win']; 
			echo "</div>";
			echo "</td></tr>";
        }?>
        <tr><td>
		<table class="table basic-table table-responsive bd" width="94%" style="text-align:left; border:none; margin-left:12px; margin-top:12px; margin-right:12px; border-collapse:collapse;"> 
		  <thead class="" style="background:#999; color:#fff"> 
		    <tr> <th>Tiketi Namba</th> <th class="web-element">JAMVI</th> <th>TAREHE</th> <th>MALIPO</th> <th>USHINDI</th><th class="web-element"></th> </tr> 
		  </thead> 
		  <tbody>
	    	<tr> 
		       <td><a href="#"><?= $myBet['bet_id'] ?></a></td>
		       <td class="web-element"><?php if($myBet['total_matches']>1){
					    echo "Multi Bet";
                    }else{
                        echo "Single Bet";
                    }?>
				</td> 
				<td><?= date("d/m H:i", strtotime($myBet["created"])); ?></td> 
				<td><?= $myBet["bet_amount"] ?></td> 
				<td><?= $myBet['is_void'] ? $myBet['revised_possible_win'] : $myBet['raw_possible_win'] ?></td>
				<td class="web-element"><?= $myBet['status'] == 200? 'NOT PAID':'PAID'; ?></td>
		    </tr> 
		    <tr><td colspan="6"><h3 class="events">MKEKA (<?= sizeof($betDetails) ?>)</h3></td></tr>
		    <tr>
		      <td colspan="6">
		      	<table class="table bdd" width="100%" style="border-collapse:collapse"> 
                    <thead class="table-h"> 
                        <tr> <th>Mechi</th> <th>Odds</th> <th class="web-element">Soko</th><th>Chaguo</th></tr> 
                    </thead> 
                    <tbody> 
                    <?php foreach($betDetails as $bet): ?>
                        <tr style="border-top:1px solid #eee;"> 
                            <td><?= $bet['home_team']."<span classs='mobi visible-mobile'> <br/> </span> <span class='web-element'>V</span>".$bet['away_team'] ?></td> 
                            <td><?= $bet['odd_value'] ?></td> 
                            <td class="web-element"><?= $bet['bet_type'] ?></td> 
                            <td><?= $bet['bet_pick'] ?></td> 
                        </tr> 
                    <?php endforeach; ?>
                    </tbody> 
                </table> 
                </td> <!-- colspan6 -->
              </tr>
	    	</tbody> 
		</table> 

	    </td>
  </tr>
</table>
<script type="text/javascript">
  var mp = document.getElementById("mpesa");
  mp.style.display='none';
  var tg = document.getElementById("tigopesa");
  tg.style.display='none';
  var am = document.getElementById("airtelmoney")
  am.style.display='none';
</script>


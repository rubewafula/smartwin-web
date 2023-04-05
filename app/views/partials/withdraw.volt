<table class="withdraw">
<th class="title" style="background-color:#bebebe; color:#781c5d">Withdraw</th>
<tr style="background-color:#bebebeE; color:##781c5d">
  <td style="padding: 5px;">
    <p>
      Enter amount below to initiate transaction
    </p>
    {{ this.flashSession.output() }}
  </td>
</tr>
<tr style="background-color:#fff; color:#781c5d">
  <td style="padding: 5px;">
      <table class="form">
      <?php echo $this->tag->form("withdraw/withdrawal"); ?>
	<tr class="input">
	  <td>
	    <div>
	      <label for="amount" style="color:##781c5d">Amount (KES) *</label>
	      <input type="number" name="amount" placeholder="KES">
	    </div>
	  </td>
	</tr>
	<tr class="spacer"></tr>
	<tr class="input">
	  <td>
	    <button type="submit">Withdraw Now</button>
	  </td>
	</tr>
	</form>
      </table>
    </form>
  </td>
</tr>

</table>

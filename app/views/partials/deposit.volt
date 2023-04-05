<table class="deposit">
  <th class="title" style="">Deposit</th>
  <tr style="">
    <td style="padding: 5px; color:#999;">
      <p>
        Enter amount below, use your service pin to authorize the transaction. If you do not have a service pin, please follow the instructions to set.
      </p>
      {{ this.flashSession.output() }}
    </td>
  </tr>
  <tr style="">
    <td style="padding: 5px;">
        <table class="form">
        <?php echo $this->tag->form("deposit/topup"); ?>
          <tr class="input">
            <td>
              <div>
                <label for="amount">Mobile Number*</label>
                <input type="number" readonly=true name="msisdn" placeholder="2547...." value="{{session.get('auth')['mobile']}}">
              </div>
            </td>
          </tr>
          <tr class="input">
            <td>
              <div>
                <label for="amount">Amount (KES) *</label>
                <input type="number" name="amount" placeholder="KES">
              </div>
            </td>
          </tr>
          <tr class="spacer"></tr>
          <tr class="input">
            <td style="padding:10px">
              <button type="submit" onclick="fbDeposit()">Deposit Now</button>
            </td>
          </tr>
      </form>
        </table>
      </form>
    </td>
  </tr>
</table>

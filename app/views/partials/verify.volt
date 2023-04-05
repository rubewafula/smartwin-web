<table class="register">
    <th class="title"><?php echo $t->_('Verify Mobile Number'); ?></th>
    <tr>
        <td style="padding: 5px;">
            <p style="color:#FFFFFF">
                <?php echo $t->_('enter-mobile'); ?>
            </p>
            {{ this.flashSession.output() }}
        </td>
    </tr>
    <tr>
        <td style="padding: 5px;">
            <?php echo $this->tag->form("verify/check"); ?>
            <table class="form">
                <tr class="input">
                    <td>
                        <div>
                            <label for="phone"><?php echo $t->_('enter-mobile-label'); ?> *</label>
                            <input type="number" name="mobile" placeholder="<?php echo $t->_(''); ?>">
                        </div>
                    </td>
                </tr>
                <tr class="spacer"></tr>
                <tr class="input">
                    <td>
                        <div>
                            <label for="password"><?php echo $t->_('Enter Verification Code'); ?> *</label>
                            <input type="number" name="verification_code" placeholder="*****">
                        </div>
                    </td>

                </tr>
                <tr class="spacer"></tr>
                <tr class="input">
                    <td>
                        <button type="submit"><?php echo $t->_('Verify'); ?></button>
                    </td>
                </tr>

                <tr class="spacer"></tr>
                <tr class="reset-password ">
                    <td>
                        <div>
                            <p style="text-align: center;"><a href="/resetpassword?redirect=signup/verify"><?php echo $t->_('Resend Code'); ?>?</a></p>
                        </div>
                    </td>
                </tr>
            </table>
            </form>
        </td>
    </tr>
</table>
<table class="login">
    <tr>
        <th class="title"><?php echo $t->_('LOGIN'); ?></th>
    </tr>
    <th>{{ this.flashSession.output() }}</th>
    <tr>
        <td style="padding: 10px 15px;">
            <?php echo $this->tag->form("login/authenticate"); ?>
            <table class="form">
                <tr class="input">
                    <td>
                        <div>
                            <label for="phone"><?php echo $t->_('mobile_number'); ?> *</label>
                            <input type="number" name="mobile" placeholder="0XXX XXX XXX">
                        </div>
                    </td>
                </tr>
                <tr class="spacer"></tr>
                <tr class="input">
                    <td>
                        <div>
                            <label for="password"><?php echo $t->_('password'); ?> *</label>
                            <input type="password" name="password" placeholder="*************">
                        </div>
                    </td>
                </tr>
                <tr class="spacer"></tr>
                <tr class="input">
                    <td>
                        <div>
                            <input type="checkbox" name="remember"  value="1">
                            <span style=""><?php echo $t->_('Remember me'); ?></span>
                            <input type="hidden" name="ref" value="{{ ref }}">
                        </div>
                    </td>
                </tr>
                <tr class="spacer"></tr>
                <tr class="input">
                    <td>
                        <div>
                            <button type="submit"><?php echo $t->_('login'); ?></button>
                        </div>
                    </td>
                </tr>
                <tr class="spacer"></tr>
                <tr class="reset-password">
                    <td>
                        <div>
                            <p class="text-center"><a href="resetpassword"><?php echo $t->_('Forgot Password'); ?>?</a></p>
                        </div>
                    </td>
                </tr>
            </table>
            </form>
        </td>
    </tr>
</table>

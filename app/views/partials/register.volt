<table class="register">
                <th class="title"><?php echo $t->_('welcome'); ?>!</th>
                <tr>
                  <td style="padding: 5px;">
                    <!-- <p>
                      <?php echo $t->_('signup_message')?>
                        <a href="{{ url('verify') }}" class="verify"><?php echo $t->_('ask_verification'); ?></a> 
                    </p> -->
                    {{ this.flashSession.output() }}
                  </td>
                </tr>
                <tr>
                  <td style="padding: 5px;">
                    <?php echo $this->tag->form("signup/join"); ?>
                      <table class="form">
                        <tr class="input">
                          <td>
                            <div>
                              <label for="phone"><?php echo $t->_('mobile_number'); ?> *</label>
                              <input type="number" name="mobile" placeholder="<?php echo $t->_('mobile_number_placeholder'); ?>">
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
                              <label for="confirm-password"><?php echo $t->_('confirm_password');?> *</label>
                              <input type="password" name="repeatPassword" placeholder="*************">
                            </div>
                          </td>
                        </tr>
                        <tr class="spacer"></tr>
                        <tr class="input">
                          <td>
                            <div class="checkbox">
                              <input type="checkbox" name="terms" value="1">
                                <?php echo $t->_('I accept these'); ?> <a href="{{ url('terms') }}"><?php echo $t->_('Terms & Conditions'); ?></a>
                            </div>
                          </td>
                        </tr>
                        <tr class="spacer"></tr>
                        <tr class="input">
                          <td>
                            <div class="checkbox">
                              <input type="checkbox" name="age" value="1"><?php echo $t->_('I am over 18 years of age'); ?></a>
                            </div>
                          </td>
                        </tr>
                        <tr class="spacer"></tr>
                        <tr class="input">
                          <td style="padding: 10px 15px;">
                            <button type="submit"><?php echo $t->_('Submit'); ?></button>
                          </td>
                        </tr>
                      </table>

                    </form>
                  </td>
                </tr>
              </table>

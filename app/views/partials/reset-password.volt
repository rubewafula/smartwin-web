<table class="login">
                <tr><th class="title">Reset Password</th></tr>

                <tr>
                  <td style="padding: 5px;">
                    <p style="color:#FFFFFF">
                    Please enter your mobile number to receive a reset code
                    </p>
                    {{ this.flashSession.output() }}
                  </td>
                </tr>
                {% if msisdn is not defined %}
                <tr>
                  <td style="padding: 5px;">
                    <?php echo $this->tag->form("resetpassword/code"); ?>
                      <table class="form">
                        <tr class="input">
                          <td>
                            <div>
                              <label for="phone">Mobile Number *</label>
                              <input type="number" name="mobile" placeholder="07XX XXX XXX">
                              <input type="hidden" name="redirect" placeholder="" value="<?php echo $redirect??'resetpassword'?>">
                            </div>
                          </td>
                        </tr>
                        <tr class="spacer"></tr>
                        <tr class="input">
                          <td>
                          <div>
                            <button type="submit">Get Reset Code</button>
                            </div>
                          </td>
                        </tr>
                        <tr class="spacer"></tr>
                      </table>
                    </form>
                  </td>
                </tr>
                {% else %} 
                <tr>
                  <td style="padding: 5px;">
                    <?php echo $this->tag->form("resetpassword/password"); ?>
                      <table class="form">
                        <tr class="input">
                          <td>
                            <div>
                              <label for="phone">Mobile number *</label>
                              <?php echo $this->tag->textField(["mobile","placeholder"=>"07XX XXX XXX","class"=>"form-control","value"=>$msisdn]) ?>
                            </div>
                          </td>
                        </tr>

                        <tr class="input">
                          <td>
                            <div>
                              <label for="phone">Reset code *</label>
                              <?php echo $this->tag->numericField(["reset_code","placeholder"=>"XXXX","class"=>"form-control"]) ?>
                            </div>
                          </td>
                        </tr>

                        <tr class="input">
                          <td>
                            <div>
                              <label for="phone">New password *</label>
                              <?php echo $this->tag->passwordField(["password","name"=>"password","class"=>"form-control","placeholder"=>"Password"]) ?>
                            </div>
                          </td>
                        </tr>

                        <tr class="input">
                          <td>
                            <div>
                              <label for="phone">Confirm password *</label>
                              <?php echo $this->tag->passwordField(["password","name"=>"repeatPassword","class"=>"form-control","placeholder"=>"Confirm password"]) ?>
                              <input type="hidden" value="{{profile_id}}" name="profile_id" />
                            </div>
                          </td>
                        </tr>

                        <tr class="spacer"></tr>
                        <tr class="input">
                          <td>
                          <div>
                            <button type="submit">Reset Password</button>
                            </div>
                          </td>
                        </tr>
                        <tr class="spacer"></tr>
                      </table>
                    </form>
                  </td>
                </tr>
                {% endif %} 
              </table>
<div style="padding: 5px 5px 5px 5px; ">
<?php echo $this->tag->form([ "/?id=".$current_sport['sport_id'], "method" => "post" ]); ?>
  <table width="100%">
    <tr>
      <td>
        <input style="border-bottom-left-radius: 4px; border-top-left-radius: 4px; font-size: 10px;" type="text" name="keyword" placeholder="<?php echo $t->_('Team, League, ID'); ?>" class="top--search--input">
      </td>
      <td>
        <button type="submit" class="top--search--button" style="border-bottom-right-radius: 4px; border-top-right-radius: 4px;"><?php echo $t->_('Search'); ?></button>
      </td>
    </tr>
  </table>
</form>
</div>

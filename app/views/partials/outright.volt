<?php 
$sub_type_id=''; 
  function clean($string) {
     $string = str_replace(' ', '-', $string); // Replaces all spaces with hyphens.
     $string = preg_replace('/[^A-Za-z0-9\-]/', '', $string); // Removes special chars.

     return preg_replace('/-+/', '-', $string); // Replaces multiple hyphens with single one.
  }
?>
<table class="feature">
  <th class="title">
    <table width="100%">
      <tr class="game">
        <td colspan="3">Outrights - <?php echo $matchInfo['competition_name'].','.$matchInfo['category']; ?></td>
      </tr>
      <tr class="spacer"></tr>
    </table>
  </th>
  
</table>
<div class="sidebets"> 
<?php foreach($outright as $bt): ?>
<?php 
$theMatch = @$betslip[$bt['parent_outright_id']];
?>
<?php if($bt['event_name']): ?>
<div class="sidebet-card">
<?php if($sub_type_id!=$bt['outright_id']): ?>
   <div><a class="sidebet-header" href="{{url('football/outrights?pid=')}}{{bt['parent_outright_id']}}">{{bt['event_name']}} - <span class="text-left"><?= date('d/m', strtotime($bt['event_date'])); ?></span> <span><?= date('g:i a', strtotime($bt['event_date'])); ?></span></a></div>
<?php endif; ?>

<?php 
if($bt['event_name']){
$sub_type_id=$bt['outright_id']; 
}
?>

<?php if($sub_type_id==$bt['outright_id']): ?>

<button class="sidebet-odd <?= @$style[$sub_type_id]; ?> <?php echo $bt['parent_outright_id']; ?> <?php echo clean($bt['outright_id'].$bt['betradar_competitor_id'].'o'); 
                    if($theMatch['match_id']==$bt['parent_outright_id'] && $theMatch['special_bet_value'] == $bt['betradar_competitor_id']){
                        echo ' picked';
                     }
                  ?>" oddtype="Outright winner" parentmatchid="<?php echo $bt['parent_outright_id']; ?>" bettype='prematch' hometeam="<?php echo $bt['event_name']; ?>" awayteam="na" oddvalue="<?php echo $bt['odd_value']; ?>" custom="<?php echo clean($bt['outright_id'].$bt['betradar_competitor_id'].'o'); ?>" target="javascript:;" id="<?php echo $bt['parent_outright_id']; ?>" odd-key="<?php echo $bt['competitor_name']; ?>" value="30" special-value-value="<?= $bt['betradar_competitor_id']; ?>" onClick="addBet(this.id,this.value,this.getAttribute('odd-key'),this.getAttribute('custom'),this.getAttribute('special-value-value'),this.getAttribute('bettype'),this.getAttribute('hometeam'),this.getAttribute('awayteam'),this.getAttribute('oddvalue'),this.getAttribute('oddtype'),this.getAttribute('parentmatchid'))"><span class="side-label"> <?php echo $bt['competitor_name']; ?></span> <span class="odd-value"> <?php echo $bt['odd_value']; ?></span> </button> 
<?php endif; ?>
</div>
<?php endif; ?>
<?php endforeach; ?>
</div>
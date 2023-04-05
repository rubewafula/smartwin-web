<style >
.item {
	background: #613354;
	padding: 5px 10px;
	border-radius: 2px;
	margin-top: 2px;
	width: max-content;
    margin-right:2px;
}

.item a{
    color:#ffffff;
}
.selected {
    background:#2c2457;
}
</style>
<div class="menu-wrapper">

<table class="top--nav" width="100%">
    <tr>
        <td class="v-menu">
          <div class="item <?= ($type == 'rgs-vsb') ? 'selected': ''; ?>">
            <a href="{{ url('virtuals/index') }}">Virtual Games</a>
        </div>
        </td>

       <?php if ( strpos(strtolower($_SERVER['HTTP_HOST']),'test') !== false || preg_match('/127.0.0.1/', $_SERVER['HTTP_HOST']))  {  ?>
        <td class="v-menu">
          <div class="item <?= ($type == 'live') ? 'selected': ''; ?>">
            <a href="{{ url('virtuals/livecasino') }}">Live Casino</a>
          </div>
        </td>
        <?php } ?>

        <td class="v-menu">
          <div class="item <?= ($type == 'vs') ? 'selected': ''; ?>">
            <a href="{{ url('virtuals/casino') }}">Casino</a>
        </div>
        </td>

        <td class="v-menu">
          <div class="item <?= ($type == 'drops-n-wins') ? 'selected': ''; ?>">
            <a href="{{ url('virtuals/casino/drops-n-wins') }}">Drops & Wins</a>
        </div>
        </td>
        <?php foreach($game_types as $cat){ ?>
           <?php if( in_array($cat['game_type_id'],  ['vs', 'rgs-vsb'])) continue; ?>
            <td class="v-menu">
              <div class="item <?= ($type == $cat['game_type_id']) ? 'selected': ''; ?>">
                <a href="{{ url('virtuals/index') }}/<?= $cat['game_type_id']; ?>"><?= $cat['game_type_description']; ?></a>
              </div>
            </td>
       <?php  } ?>
    </tr>
</table>
</div>
<?php

foreach($games as $chunks){
    ?>
        <tr>
            <td style="padding:2px" width="100%">
            <table width="100%" style="text-align:center">
            <?php
                $count = 0;
                foreach($chunks as $game){
                    if($count % 3 == 0  ){
                        echo "<tr>";
                    }
                        
                    ?>
                        <td style="padding:2px; border-radius:2px; background:#eee; width:33.33%" >
                           <div class="cover-img">
                            <a href="/virtuals/launch/<?php echo $game['game_id']?>?live=1">
                               <?php if($type == 'drops-n-wins') { ?>

                                    <img src="<?= '/img/drops-n-wins/' . $game['game_name'] . '/390x390.png'; ?>" alt="" style="max-height: 150px; width: 100%">
                                <?php } else { ?>
                                    <img src="<?php echo $game['game_icon']?>" alt="" style="max-height: 150px; width: 100%">
                                <?php } ?>
                            </a>
                            </div>
                            <table width="100%" style="height: 47px;">
                                <tr>
                                  <?php if ($type != 'rgs-vsb') { ?>
                                    <td style="padding:3px">
                                        <a href="/virtuals/launch/<?php echo $game['game_id']?>?live=0" style="display:block; background: #ffc107; color:#000; padding:5px; border-radius:2px; text-align:center">Demo </div>
                                    </td>
                                    <td>
                                        <a href="/virtuals/launch/<?php echo $game['game_id']?>?live=1" style="display:block; background: #902065; color:#fff; padding:5px; border-radius:2px; text-align:center;">Live</div>
                                    </td>
                                   <?php } else { ?>
                                    <td style="color:#902065;"> <?= $game['game_name']; ?></td>

                                   <?php } ?>
                                </tr>
                            </table>
                        </td>
                    <?php
                    $count++;

                    if($count % 3 == 0 ){
                        echo "</tr>";
                    }
                }
            ?>
            </table>
            </td>
        </tr>
    <?php
}
?>

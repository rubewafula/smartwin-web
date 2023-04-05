<style >
.item {
	background: #110e02;
	padding: 5px 10px;
	border-radius: 2px;
	margin-top: 2px;
	margin-right: 2px;
	border: 1px solid #463b09;
}

.item a{
    color:#7b6710;
}
.selected {
    border-bottom:4px solid #c25f02;
}
.v-menu {
   font-size:12px;
   text-align:center;
}
</style>
<div class="menu-wrapper">

<table class="top--nav" width="100%">
    <tr>
        <td class="v-menu">
          <div class="item " style="background:#373428; font-weight:bold; text-transform:capitalize">
            <a href="{{ url('/') }}?section-id=<?= $sectionId ?>"><?= $sectionId ?: 'ALL' ; ?></a>
        </div>
        </td>

        <td class="v-menu">
          <div class="item <?= ($gametype == 'slots') ? 'selected': ''; ?>">
            <a href="{{ url('/') }}?game-type-id=slots&section-id=<?= $sectionId ?>"">SLOTS</a>
          </div>
        </td>

        <td class="v-menu">
          <div class="item <?= ($gametype == 'casino') ? 'selected': ''; ?>">
            <a href="{{ url('/') }}?game-type=casino&section-id=<?= $sectionId ?>"">CASINO</a>
        </div>
        </td>
        </td>
    </tr>
</table>
</div>
<table class="top--nav" width="">
   <tr>
    <td style="padding:2px" width="100%">
    <table width="100%" style="text-align:center">
<?php $count = 0; ?>
<?php foreach($games['data'] as $game){
    ?>
        <?php if($count % 3 == 0  ){ echo "<tr>"; } ?>
                        <td style="padding:2px; border-radius:5px; width:33.33%" >
                           <div class="cover-img" style="position:relative">
                            <a href="/index/launch/<?php echo $game['game_id']?>?live=1">
                                    <img src="/img/235x235/<?= $game['section_id']; ?>/<?= $game['game_id']. ".jpg"; ?>" alt="" style="max-height: 150px; width: 100%; border-radius:2px;">
                            </a>
                            <table width="100%" style="position:absolute; bottom:5px; font-size:12px">
                                <tr>

                                    <td style="padding:0px 3px">
                                        <a href="/index/launch/<?php echo $game['game_id']?>?live=0" 
                                           class="demo-button">DEMO</div>
                                        <a href="/index/launch/<?php echo $game['game_id']?>?live=1" class="play-button">PLAY</div>
                                    </td>

                                </tr>
                            </table>
                            </div>
                        </td>
                    <?php $count++; if($count % 3 == 0 ){ echo "</tr>"; } ?>
    <?php } ?> 
   </table>
   </td>
  </tr>
</table>

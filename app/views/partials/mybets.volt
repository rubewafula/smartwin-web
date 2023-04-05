<table class="mybets">
  <th class="title" >My Bets</th>
  <tr class="bet" style="color: #6c590d; font-weight:bold;">
    <td >Created</td>
    <td >Game</td>
    <td >Spin</td>
    <td >Win Type</td>
    <td >Stake</td>
    <td >Winnings</td>
  </tr>
  <?php foreach($myBets as $bet): ?>
  <tr class="bet">
    <td ><?= $bet['created']; ?></td>
    <td ><?= $bet['game_id']; ?></td>
    <td ><?= $bet['spin_type']; ?></td>
    <td ><?= $bet['win_type']; ?></td>
    <td ><?= $bet['stake']; ?></td>
    <td ><?= $bet['winnings']; ?></td>
  </tr>
  <?php endforeach; ?>

</table>

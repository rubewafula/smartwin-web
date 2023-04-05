<table class="landing">
<tr>
<td>
<table class="top--nav" width="100%">
    <tr>
        <td class="<?= ($men == 'sports') ? 'selected': ''; ?>">
            <a href="{{ url('sports') }}?id={{current_sport['sport_id']}}">Sports</a>
        </td>
        <td class="<?= ($men == 'top-leagues') ? 'selected': ''; ?>">
            <a href="{{ url('top-leagues') }}?id={{current_sport['sport_id']}}">Leagues</a>
        </td>

    </tr>
</table>
<table class="football highlights">
    <tbody>
    <tr>
        <th class="title" colspan="2">ALL Sports</th>
    </tr>
    <?php foreach($sports as $key => $sp): ?>
        <tr class="menu">
          <td class="text">
              <a href="/sport-competition?id=<?= $sp['sport_id']; ?>"> {{sp['sport_name']}} </a>
          </td>
      </tr>
      <?php endforeach; ?>
    </tbody>
</table> <!-- end table football -->

</td>
</tr>
</table> <!-- end table .landing -->

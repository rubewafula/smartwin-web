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
        <td class="<?= ($men == 'countries') ? 'selected': ''; ?>">
            <a href="{{ url('countries') }}?id={{current_sport['sport_id']}}">Countries</a>
        </td>
    </tr>
</table>

<table class="football">
	<th class="title" colspan="2">{{sport_name}} - Top Countries</th>
	<?php foreach($top_countries as $c): ?>
	<tr class="menu">
		<td class="text"><a href="{{url('top-leagues?id=')}}{{sport_id}}&c={{ c['category_id'] }}">{{ c['country'] }} <span style="float:right; margin-right:5px"># {{c['games_count']}}</span></a></td>
	</tr>
    <?php endforeach; ?>
</table>
<table class="football highlights">
	<th class="title" colspan="2">Countries (A-Z)</th>
	<?php foreach($countries as $cc): ?>
	<tr class="menu">
		<td class="text"><a href="{{url('top-leagues?id=')}}{{sport_id}}&c={{cc['category_id']}}">{{cc['country']}} <span style="float:right; margin-right:5px"># {{cc['games_count']}}</span></a></a></td>
	</tr>
<?php endforeach; ?>
</table>

</td>
</tr>
</table> <!-- end table .landing -->

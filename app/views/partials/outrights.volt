<table class="football">
	<th class="title" colspan="2">Football Outrights</th>
<?php foreach($outrights as $ot): ?>
	<tr class="menu">
		<td class="text"><a href="{{url('football/outrights?id=')}}{{ot['betradar_competition_id']}}">{{ot['category']}}, {{ot['competition_name']}}</a></td>
	</tr>
<?php endforeach; ?>
</table>
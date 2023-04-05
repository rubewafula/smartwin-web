<table class="football">
	<th class="title" colspan="2">Top Leagues</th>
	<tr class="menu">
		<td class="text"><a href="{{url('upcoming')}}">Upcoming Events</a></td>
	</tr>
    <?php foreach($competitions as $competition): ?>
	<tr class="menu">
		<td class="text"><a href="{{url('competition?id=')}}{{ competition['competition_id'] }}">{{ competition['competition_name'] }}</a></td>
	</tr>
    <?php endforeach; ?>
</table>
<table class="football">
	<th class="title" colspan="2">Football (A-Z)</th>
	<?php foreach($football as $fb): ?>
	<tr class="menu">
		<td class="text"><a href="{{url('competition?id=')}}{{fb['competition_id']}}">{{fb['category']}}, {{fb['competition_name']}}</a></td>
	</tr>
<?php endforeach; ?>
</table>
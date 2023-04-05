<table class="football">
	<th class="title" colspan="2">Soccer - Top Competitions</th>
	<?php foreach($top_competitions as $competition): ?>
	<tr class="menu">
		<td class="text">
		<a href="{{url('competition?id=')}}{{ competition['competition_id'] }}">
		{{ competition['competition_name'] }}

		</a>
		</td>
	</tr>
    <?php endforeach; ?>
</table>
<table class="football highlights">
	<th class="title" colspan="2">{{sport_name}} Competitions (A-Z)</th>


	<?php foreach($categories as $cat): ?>
	    <tr class="menu">
		    <th class="title" colspan="2">{{cat['category_name']}}</th>
		    <?php foreach($cat['competitions'] as $competition): ?>
		    	<tr class="menu">
            		<td class="text"><a href="{{url('competition?id=')}}{{competition['competition_id']}}">{{competition['competition_name']}} </a></a></td>
            	</tr>
		    <?php endforeach; ?>
		</tr>
    <?php endforeach; ?>
</table>

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
{%if sport_name == 'Soccer'  %}
<table class="football">
	<th class="title" colspan="2">{{sport_name}} - {{category}} Leagues</th>
	<?php foreach($top_competitions as $competition): ?>
	<tr class="menu">
		<td class="text">
          <a href="{{url('competition?id=')}}{{ competition['competition_id'] }}">
          {{competition['category']}} - {{ competition['competition_name'] }}</a></td>
	</tr>
    <?php endforeach; ?>
</table>
{% endif %}
</td>
</tr>
</table> <!-- end table .landing -->

<table class="football highlights">
	<th class="title" colspan="2">All Leagues (A-Z)</th>


	<?php foreach($allSports as $sport): ?>
	    <tr class="menu">

		    <th class="mkt-headers" colspan="2"><span style="font-size:22px">{{sport['sport_name']}}</span></th>

		    <?php foreach($sport['categories'] as $cat): ?>

            <tr class="menu">
		        <th class="title" colspan="2">{{cat['category_name']}}</th>
		    </tr>

		    <?php foreach($cat['competitions'] as $competition): ?>
		            <tr class="menu">
                		<td class="text"><a href="{{url('competition?id=')}}{{competition['competition_id']}}">{{competition['competition_name']}} </a></a></td>
                    </tr>
		    <?php endforeach; ?>

		    <?php endforeach; ?>
		</tr>
    <?php endforeach; ?>
</table>
                                  

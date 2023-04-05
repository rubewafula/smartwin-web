<!-- <table class="football">
<tbody>
    <tr><th class="title" colspan="2"><?= $current_sport['sport_name'] ?></th></tr>

</tbody>
</table>
-->
<table class="top--nav" width="100%; font-size:11px">
    <tr>
        <td class="<?= ($tab == 'highlights') ? 'selected': ''; ?>">
            <a href="{{ url('highlights') }}?id={{current_sport['sport_id']}}">Highlights</a>
        </td>
        <td class="<?= ($tab == 'today') ? 'selected': ''; ?>">
            <a href="{{ url('') }}?id={{current_sport['sport_id']}}">Today</a>
        </td>
        <td class="<?= ($tab == 'tomorrow') ? 'selected': ''; ?>">
            <a href="{{ url('tomorrow') }}?id={{current_sport['sport_id']}}"><?php echo $t->_('tomorrow'); ?></a>
        </td>
        <td class="">
            <a href="{{ url('top-leagues') }}?id={{current_sport['sport_id']}}">Leagues</a>
        </td>
        <td class="">
            <a href="{{ url('sports') }}"><?php echo $t->_('Sports'); ?></a>
        </td>
    </tr>
</table>

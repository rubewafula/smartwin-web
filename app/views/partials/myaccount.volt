<table class="mybets">
  <th class="title" >My Account</th>
  <table class="terms" >
  <tr>
    <td colspan="2" class="text-center"><b>{{session.get('auth')['mobile']}}</b><hr style="border:1px solid #282105;"></td>
  </tr>

  <tr>
    <td><b>Bal:</b> KES {{user['balance']}}</td>
    <td><b>Bonus:</b> KES. {{user['bonus']}}</td>
  </tr>
  <tr>
    <td><b>Smartwin points:</b> {% if user['points'] is defined %}{{user['points']}} {%else%}0{%endif%}</td>
  </tr>
  
  </table>
</table>
<table class="full-width profile">
   
   <tr class="menu">
    <td class="text"><a href="{{url('deposit')}}" >Deposit</a></td>
  </tr> 
  <tr class="menu">
    <td class="text"><a href="{{url('withdraw')}}" >Withdraw</a></td>
  </tr>
  <tr class="menu" >
    <td class="text"><a href="{{url('logout')}}">Logout</a></td>
  </tr> 

</table>

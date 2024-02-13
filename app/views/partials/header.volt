<a href="/deposit" style="text-decoration: none;">
  <table style="background-color: rgb(240,35, 30); width:100%; padding:2px 0px; text-align: center;">
    <tr>
      <td style="width: 100%; font-size: 11px; color: #fff; height:32px;">
            DEPOSIT<span style="margin-bottom: 1px;"> → </span> <span style="font-weight: bold;"> M-PESA </span>(<strong>4093333</strong>) <span>&nbsp OR &nbsp; </span> 
        SMS '<strong>JOIN</strong>' to 29400
      </td>
    </tr>
  </table>

</a>

<table class="brand brandt" style="position: sticky; top: 0px; width: 100%; ">
	<tr>
	  <td>
	     <table style="width: 100%; ">
		  <tr>
		  <td class="logo"><a href="{{ url('') }}"> <img src="{{ url('/img/logo.png') }}" alt="logo"></a></td>
		  <td class="" style="font-size: 10px; display: none;">
				Paybill <strong>4093333</strong> <br>
				 {% if session.get('auth') == null %}
				     SMS '<strong>JOIN</strong>' 29400
			     {% else %}
                         <a href="/deposit" style="color: #fff;background: green;border: 1px solid #991;border-radius: 2px;padding: 2px 5px;display: block;width: max-content;text-decoration: none;margin-top:2px;">DEPOSIT NOW</a>
					 {% endif %}

	  </td>
	  <td class="betslip" style="">
	    {% if session.get('auth') ==  null %}
		   <a href="/login" style="background-color: rgb(240,35, 30); padding:5px 10px; border-radius:4px; margin-left:5px; color: white!important; text-decoration: none;">Login</a>
	       <a href="/signup" style="background-color: rgb(255,200, 5); padding:5px 10px; border-radius:4px; margin-left:5px; color: white!important; text-decoration: none;">Register</a>
	       <!-- <a href="/signup/verify" style="background-color: green; padding:5px 10px; border-radius:4px; margin-left:5px; color: white!important; text-decoration: none;">Verify Account</a> -->
		{% else %}
            <a href="/myaccount" style="color: #ab7a22; padding:5px 10px; border-radius:2px; margin-left:5px; text-decoration: none;">MY ACCOUNT</a> <span style="color:#282105">|</span>
            <a href="/mybets" style="color: #ab7a22; padding:5px 10px; border-radius:2px; margin-left:5px; text-decoration: none;">BETS</a>
		{% endif %}
            </td>
	  </tr>
	</table>
	  </td>
	</tr>
  </table>
<!--
<table id="header">
  <tr>
    <td>
      <table class="landing" style="width: 100%; border-top:1px solid #252122;">
	  <tr class="top--search">
		  <td style="width: 60%;">
		    <div style="padding: 2px;">
		       <?php $height = 18; ?>
			<a href="/index" 
			  style="font-size: 11px; background-color: #16202C; padding: 5px 8px 5px 8px; border-top-left-radius: 4px; border-bottom-left-radius: 4px; float:left;">
			    <img style="height:  <?php echo $height; ?>px;" src="{{ url('/img/home.svg?v=1') }}" alt="Home">
			</a>
			<a href="/" style="color: #fff; font-size: 11px; background-color: #16202C; padding: 6px 8px; margin-left:1px; float:left">Sports</a>
		    </div>
		   </td>
		  <td>
			{{ partial("partials/search") }}
		  </td>
	  </tr>
    </table> -->
    <div class="menu-wrapper">
        <table class="menu-table" style="width: 100%; text-align: center; background:#060606; border-top:1px solid #151515;" >
          <tr>

                <!-- end current sport -->
                <?php foreach($games['types'] as $provider=>$games): ?>

                  <td class="menu-t" >
                      <a href="/?section-id={{provider}}" style="text-decoration: none; color: unset; ">
                          <div class="inner-div" style="padding: 5px 10px;">
                               <div class="menu-img" >
                                   <img src="/img/providers/{{provider}}" style="height: 35px; border-radius:5px; border:1px solid #342c06;" alt="#" onerror="this.style.display='none'">
                              </div>
                              <div style="text-align: center; font-size: 12px; overflow-x: hidden; text-transform:capitalize;">{{provider}}</div>
                          </div>
                       </a>
                   </td>

                <?php endforeach; ?>
           </tr>
       </table>
      </div>

    </td>
  </tr>
</table>
 <?php if(!preg_match('/index.launch/', $_SERVER['REQUEST_URI'])) { ?> 
<style>
    .carousel-item img{
        width:100%;
        max-height:150px;
    }
</style>
<div id="myCarousel" class="carousel slide block-shadow" data-ride="carousel" >
    <!-- Indicators -->
    <ol class="carousel-indicators">
        <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
        <li data-target="#myCarousel" data-slide-to="1"></li>
        <li data-target="#myCarousel" data-slide-to="2"></li>
        <li data-target="#myCarousel" data-slide-to="3"></li>
        <li data-target="#myCarousel" data-slide-to="4"></li>
        <li data-target="#myCarousel" data-slide-to="5"></li>
    </ol>

    <!-- Wrapper for content -->
    <div class="carousel-inner" role="listbox">
         <div class="carousel-item active">
            <img alt="Smart Win" src="/img/banner/6-Winning-Gambling-Strategies-for-Smart-Gamblers.jpg"/>
        </div>
         <div class="carousel-item">
            <img alt="Drops n Wins" src="/img/banner/DRWN_MC_1676899146530"/>
        </div>
         <div class="carousel-item">
            <img alt="Winning" src="/img/banner/winningatomahapoker.jpg"/>
        </div>
    </div>
    <!-- Controls -->
    <a class="left carousel-control-prev" href="#myCarousel" role="button" data-slide="prev">
        <span class="fa fa-chevron-left" aria-hidden="true"></span>
        <span class="sr-only">Previous</span>
    </a>
    <a class="right carousel-control-next" href="#myCarousel" role="button" data-slide="next">
        <span class="fa fa-chevron-right" aria-hidden="true"></span>
        <span class="sr-only">Next</span>
    </a>
</div>
<?php } ?>

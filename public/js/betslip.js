function refreshSlip() {
    $.post("betslip", {}, function (data) {
        $("#betslip").animate({opacity: '0.8'});
        $("#betslip").html(data);
        $("#betslip").animate({opacity: '1'});
    }).done(function () {
        $(".loader").css("display", "none");
    });
}

function refreshJackSlip() {
    $.post("matches/jackpot", {}, function (data) {
        $("#betslipJ").animate({opacity: '0.8'});
        $("#betslipJ").html(data);
        $("#betslipJ").animate({opacity: '1'});
    }).done(function () {
        $(".loader").css("display", "none");
    });
}


function refreshBingwaFour() {
    $.post("betslip/bingwa", {}, function (data) {
        $("#betslipB").animate({opacity: '0.8'});
        $("#betslipB").html(data);
        $("#betslipB").animate({opacity: '1'});
    }).done(function () {
        $(".loader").css("display", "none");
    });
}

function addBet(value, sub_type_id, odd_key, custom, special_bet_value, bet_type, home, away, odd, oddtype, parentmatchid, pos) {
    var self = this;
    if ($('.' + custom).hasClass('picked')) {
        var counterHolder = $(".slip-counter"),
            count = counterHolder.html() * 1;
        counterHolder.html(--count);
        return removeMatch(value);
    }
    $(".loader").slideDown("slow");
    $.post("betslip/add", {
        match_id: value,
        sub_type_id: sub_type_id,
        odd_key: odd_key,
        custom: custom,
        special_bet_value: special_bet_value,
        bet_type: bet_type,
        home: home,
        away: away,
        odd: odd,
        oddtype: oddtype,
        parentmatchid: parentmatchid,
        pos: pos
    }, function (data) {
        $("." + value).removeClass('picked');
        $(self).addClass('picked');
        $("." + custom).addClass('picked');
        //add odds and recalculate values
        var bamount = data.betslip_data.bet_amount;
        var total_odd = data.betslip_data.total_odd;
        var possible_win = data.betslip_data.possible_win;
        
        var total_odd_el = document.getElementById("total_odd_m");
        var total_odd_label = document.getElementById("total_odd");
        if (bet_type!=='jackpot'){
            var bet_slip_count_label = document.getElementById("betslip-count");
            var bet_slip_count_label_opera = document.getElementById("betslip-count-opera");

            if(bet_slip_count_label_opera != undefined && bet_slip_count_label_opera != null){
                bet_slip_count_label_opera.innerHTML = Object.keys(data.betslip).length;
            }
            bet_slip_count_label.innerHTML = Object.keys(data.betslip).length;

            total_odd_el.innerHTML = total_odd;
            total_odd_label.innerHTML = total_odd;
            var poss_id = document.getElementById("possible_win_id");
            poss_id.innerHTML = possible_win.toFixed(2);
        }

    });
}

function removeMatch(value) {
    $(".loader").slideDown("slow");
    $.post("betslip/remove", {match_id: value}, function (data) {
        //refreshSlip();
        $("." + value).removeClass('picked');
        console.log(data);
        var bamount = data.betslip_data.bet_amount;
        var total_odd = data.betslip_data.total_odd;
        var possible_win = data.betslip_data.possible_win;
        
        var total_odd_el = document.getElementById("total_odd_m");
        var total_odd_label = document.getElementById("total_odd");
        var bet_slip_count_label = document.getElementById("betslip-count");
        var bet_slip_count_label_opera = document.getElementById("betslip-count-opera");
        bet_slip_count_label.innerHTML = Object.keys(data.betslip).length
        if(bet_slip_count_label_opera != undefined && bet_slip_count_label_opera != null){
            bet_slip_count_label_opera.innerHTML = Object.keys(data.betslip).length;
        }
        total_odd_el.innerHTML = total_odd;
        total_odd_label.innerHTML = total_odd;
        var poss_id = document.getElementById("possible_win_id");
        poss_id.innerHTML = possible_win.toFixed(2);

    });
}

function clearSlip(value) {
    $(".loader").slideDown("slow");
    $.post("betslip/clearslip", {}, function (data) {
        refreshSlip();
        $(".picked").removeClass('picked');
    });
}

function winnings() {
    var value = $("#bet_amount").val();
    var odds = $("#total_odd").val();
    var totalWin = value * odds;
    var totalWin = Math.round(totalWin);
    $("#pos_win").html(totalWin);
}


function winningsM() {
    var value = $("#bet_amount_m").val();
    var odds = $("#total_odd_m").val();
    var totalWin = value * odds;
    var totalWin = Math.round(totalWin);
    $("#pos_win_m").html(totalWin);
}

function showMpesaForm(){
  var tg = document.getElementById("tigopesa");
  tg.style.display='none';
  var am = document.getElementById("airtelmoney")
  am.style.display='none';
  var mp = document.getElementById("mpesa");
  mp.style.display='block';
  return false;
}

function showTigoForm(){
  var mp = document.getElementById("mpesa");
  mp.style.display='none';
  var am = document.getElementById("airtelmoney")
  am.style.display='none';
  var tg = document.getElementById("tigopesa");
  tg.style.display='block';
  return false;
}
function showAirtelForm(){
 var mp = document.getElementById("mpesa");
  mp.style.display='none';
  var tg = document.getElementById("tigopesa");
  tg.style.display='none';
  var am = document.getElementById("airtelmoney")
  am.style.display='block';
  return false;
}

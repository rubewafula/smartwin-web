<?php

use Phalcon\Session\Bag as SessionBag;
use Phalcon\Http\Response;

class BetslipController extends ControllerBase
{
    public function IndexAction()
    {
        $stake = $this->session->get('stake') ?: 49;
        $betslip = $this->session->get("betslip") ?: [];
        $newslip = [];
        $totalOdd = 1;

        list($status, $data) = $this->validateMatches(array_values($betslip));

        $validationData = $data['slip_data'];

        foreach ($validationData as $slipData) {
            $slip = $betslip[$slipData['match_id']];
            $sub_type_id = $slip['sub_type_id'];
            $parent_match_id = $slip['parent_match_id'];
            $special_bet_value = $slip['special_bet_value'];
            $bet_pick = $slip['bet_pick'];
            $bet_type = $slip['bet_type'];
            $active_status = $slipData['odd_active'];
            $slip['odd_value'] = $slipData['odd_value'];
            if ($slipData['odd_active'] == 1 && !in_array($slipData['event_status'], ['Suspended', 'Settled', 'Abandoned', 'Ended'])) {
                $slip['market_status'] = 'Market active';
            } else {
                $slip['odd_value'] = 1;
                $slip['market_status'] = 'Market disabled';
            }

            $betslip[$slipData['match_id']] = $slip;

            $totalOdd *= (float)$slipData['odd_value'];
        }

        $totalOdd = round($totalOdd, 2);
        $betslip_data = $this->get_betslip_data($stake, $totalOdd);

        $this->session->set('betslip', $betslip);

        $count = sizeof($betslip);
        $this->view->setVars([
            'stake' => $stake,
            'betslip' => $betslip,
            'totalOdd' => $totalOdd,
            'betslip_data' => $betslip_data,
            'slipCount' => $count
        ]);
    }

    public function stakeAction()
    {
        $stake = $this->request->get('stake') ?: 49;

        if ($stake < 20) {
            $stake = 20;
        }

        $this->session->set('stake', $stake);

        $this->flashSession->error($this->flashSuccess('Possible win updated'));

        $this->response->redirect('betslip');
        // Disable the view to avoid rendering
        $this->view->disable();
    }

    private function get_betslip_data($bet_amount, $odds)
    {
        $betslip_data = [];
        $betslip_data['bet_amount'] = $bet_amount;
        $betslip_data['total_odd'] = round($odds, 2);

        $betslip_data['stake_after_tax'] = round($bet_amount / 107.5 * 100, 2);
        $betslip_data['excise_tax'] = round($bet_amount - $betslip_data['stake_after_tax']);

        $betslip_data['raw_possible_win'] = round($betslip_data['total_odd'] * $betslip_data['stake_after_tax'], 2);

        $betslip_data['withholding_tax'] = round(($betslip_data['raw_possible_win'] - $bet_amount) * 0.2);
        $betslip_data['possible_win'] = $betslip_data['raw_possible_win'] - $betslip_data['withholding_tax'];

        return $betslip_data;
    }

    public function addAction()
    {
        $match_id = $this->request->getPost('match_id', 'int');
        $bet_pick = $this->request->getPost('odd_key');
        $sub_type_id = $this->request->getPost('sub_type_id', 'int');
        $special_bet_value = $this->request->getPost('special_bet_value');
        $bet_type = $this->request->getPost('bet_type') ?: 'prematch';
        $home_team = $this->request->getPost('home');
        $away_team = $this->request->getPost('away');
        $odd_value = $this->request->getPost('odd');
        $odd_type = $this->request->getPost('oddtype');
        $parent_match_id = $this->request->getPost('parentmatchid', 'int');
        $bet_amount = $this->session->get('stake') ?: 49;
        $pos = $this->request->getPost('pos');

        if ($special_bet_value == '0') {
            $special_bet_value = '';
        }

        // if ($bet_type == 'live') {
        //     $this->session->set("betslip", '');
        // }

        $status = 1;

        $betslip = [];
        $live_slip = [];

        if ($this->session->has("betslip")) {
            $betslip = $this->session->get("betslip");
        }

        if ($bet_type == 'jackpot' && $this->session->has('jackpot_betslip')) {
            $betslip = $this->session->get('jackpot_betslip');
        }


        $betslip["$match_id"] = [
            'match_id' => $match_id,
            'bet_pick' => $bet_pick,
            'sub_type_id' => $sub_type_id,
            'special_bet_value' => $special_bet_value,
            'bet_type' => $bet_type,
            'home_team' => $home_team,
            'away_team' => $away_team,
            'odd_value' => $odd_value,
            'odd_type' => $odd_type,
            'parent_match_id' => $parent_match_id,
            'pos' => $pos,
        ];
        $odds = 1;
        array_walk($betslip, function ($slip, $pmid) use (&$odds) {
            $odds *= $slip['odd_value'];
        });

        $betslip_data = $this->get_betslip_data($bet_amount, $odds);

        if ($bet_type != 'jackpot') {
            $this->session->set("betslip", $betslip);
        } else {
            $this->session->set('jackpot_betslip', $betslip);
        }

        $this->session->set("betslip_data", $betslip_data);

        if ($bet_type == 'live' || $bet_type == 1) {
            if ($this->session->has("orig_betslip")) {
                $live_slip = $this->session->get("orig_betslip");
            }

            $live_slip["$match_id"] = [
                'match_id' => $match_id,
                'bet_pick' => $bet_pick,
                'sub_type_id' => $sub_type_id,
                'special_bet_value' => $special_bet_value,
                'bet_type' => $bet_type,
                'home_team' => $home_team,
                'away_team' => $away_team,
                'odd_value' => $odd_value,
                'odd_type' => $odd_type,
                'parent_match_id' => $parent_match_id,
                'pos' => $pos,
            ];

            $this->session->set("orig_betslip", $live_slip);

        }

        $bets = $this->session->get('betslip');

        if ($bet_type == 'jackpot') {
//            die(var_export($this->session->get('jackpot_betslip')));
            $bets = $this->session->get('jackpot_betslip');
        }

        $count = sizeof($bets);

        $data = [
            'status' => $status,
            'total' => $count,
            'betslip' => $betslip,
            'betslip_data' => $betslip_data,
        ];

        $response = new Response();
        $response->setStatusCode(201, "OK");
        $response->setHeader("Content-Type", "application/json");

        $response->setContent(json_encode($data));

        return $response;
    }

    public function removeAction()
    {
        $match_id = $this->request->getPost('match_id', 'int');
        $bs = $this->request->get('bs', 'int');
        $betslip = $this->session->get("betslip");
        $betslip_data = $this->session->get("betslip_data");

        unset($betslip["$match_id"]);
        $odds = 1;
        array_walk($betslip, function ($slip, $pmid) use (&$odds) {
            $odds *= $slip['odd_value'];
        });

        $betslip_data['total_odd'] = round($odds, 2);
        $bet_amount = $betslip_data['bet_amount'];
        $betslip_data = $this->get_betslip_data($bet_amount, $odds);

        $this->session->set("betslip_data", $betslip_data);
        $this->session->set("betslip", $betslip);

        if ($bs != 1) {
            $data = [
                'betslip' => $betslip,
                'betslip_data' => $betslip_data,
            ];

            $response = new Response();
            $response->setStatusCode(201, "OK");
            $response->setHeader("Content-Type", "application/json");

            $response->setContent(json_encode($data));

            return $response;
        } else {
            $this->flashSession->error($this->flashSuccess('Match successfully removed'));
            $this->response->redirect('betslip');
            //Disable the view to avoid rendering
            $this->view->disable();
        }
    }

    public function clearslipAction()
    {

        $this->session->remove("betslip");

        $this->session->remove("betslip_data");
        $data = '1';

        $src = $this->request->getPost('src', 'string');
        //$this->flashSession->error($this->flashSuccess('Betslip cleared'));
        $this->response->redirect('/');
        // Disable the view to avoid rendering
        $this->view->disable();

    }

    public function freebetAction()
    {
        $profile_id = $this->request->getPost('profile_id', 'int');
        $parent_match_id = $this->request->getPost('parent_match_id', 'int');
        $bet_pick = $this->request->getPost('bet_pick', 'string');
        $src = $this->request->getPost('src', 'string') ?: 'internet';
        $endCustomerIP = $this->getClientIP();

        $response = new Response();
        $response->setStatusCode(201, "OK");
        $response->setHeader("Content-Type", "application/json");

        $checkUser = $this->rawSelect("SELECT * from profile where profile_id='$profile_id' limit 1");
        $checkUser = $checkUser['0'];

        $mobile = $checkUser['msisdn'];


        $bet = [
            "bet_string" => 'api',
            "app_name" => "LITE",
            "bet_pick" => $bet_pick,
            "profile_id" => $profile_id,
            "deviceID" => "6489000GX",
            "endCustomerIP" => $endCustomerIP,
            "channelID" => $src,
            'msisdn' => $mobile,
        ];

        $place_freebet = $this->free_bet($bet);
        $feedback = $place_freebet['message'];
        if ($place_freebet['status_code'] == 201) {
            $feedback = $place_freebet['message'];
            $this->flashSession->success($this->flashSuccess($feedback));
            //update freebie consumed
            $auth = $this->session->get('auth');
            $auth['freebie'] = 3;
            $exp = time() + (3600 * 24 * 5);
            $this->registerAuth($auth, $exp);
        } else {
            $this->flashSession->error($this->flashError($feedback));
            $this->response->redirect('index');
        }

        $this->response->redirect('betslip');
        $this->view->disable();
    }

    public function placebetAction()
    {
        $user_id = $this->request->getPost('user_id', 'int');
        $msisdn = $this->request->getPost('msisdn', 'int');
        $bet_amount = $this->request->getPost('stake', 'float');
        $total_odd = $this->request->getPost('total_odd', 'int');
        $possible_win = $this->request->getPost('possible_win', 'float');
        $betslip_data = $this->get_betslip_data($bet_amount, $total_odd);
        $src = $this->request->getPost('src', 'string') ?: 'internet';
        $betslip = $this->session->get('betslip');
        $endCustomerIP = $this->getClientIP();

        $account = $this->request->getPost('account', 'int', 0);
        $account = $user_id > 0 ? 1 : $account;

        if ($account !== 1) {
            $account = 0;
        }

        $response = new Response();
        $response->setStatusCode(201, "OK");
        $response->setHeader("Content-Type", "application/json");


        if (!($user_id || $msisdn) || !$bet_amount || !$total_odd || !$possible_win) {
            $this->flashSession->error($this->flashError('All fields are required'));
            $this->response->redirect('betslip');
            // Disable the view to avoid rendering
            $this->view->disable();
        } else {

            $user = $this->session->get('auth');

            $mobile = $user['mobile'];
            $has_redeemed_freebie = $user['bonus'] == 3;
            $totalMatch = sizeof($betslip);

            $slip = [];

            foreach ($betslip as $match) {
                $parent_match_id = $match['parent_match_id'];
                $bet_pick = $match['bet_pick'];
                $odd_value = $match['odd_value'];
                $sub_type_id = $match['sub_type_id'];
                $home_team = $match['home_team'];
                $away_team = $match['away_team'];
                $special_bet_value = $match['special_bet_value'];
                $bet_type = $match['bet_type'] == 'live' ? "1" : "0";

                $thisMatch = '';

                if ($away_team == 'na') {
                    $thisMatch = [
                        "sub_type_id" => $sub_type_id,
                        "betrader_competitor_id" => $special_bet_value,
                        "odd_value" => $odd_value,
                        "parent_outright_id" => $parent_match_id,
                        "bet_type" => $bet_type,
                    ];
                } else {
                    $thisMatch = [
                        "sub_type_id" => $sub_type_id,
                        "special_bet_value" => $special_bet_value,
                        "bet_pick" => $bet_pick,
                        "odd_value" => $odd_value,
                        "parent_match_id" => $parent_match_id,
                        "bet_type" => $bet_type,
                    ];
                }


                $slip[] = $thisMatch;
            }

            $bet = [
                "bet_string" => 'sms',
                "app_name" => "LITE",
                "possible_win" => $betslip_data['possible_win'],
                "profile_id" => $user_id,
                "stake_amount" => $bet_amount,
                "bet_total_odds" => $total_odd,
                "deviceID" => "6489000GX",
                "endCustomerIP" => $endCustomerIP,
                "channelID" => $src,
                "slip" => $slip,
                "account" => $account,
                "msisdn" => $user_id ? $mobile : $msisdn,
                "accept_all_odds_change" => true
            ];


            $placeB = $this->bet($bet);

//				die(json_encode($placeB));
            if ($placeB['status_code'] == 201) {
                $feedback = json_decode($placeB['message'])->message;
                $this->session->remove("betslip");

                if (!$has_redeemed_freebie || $bet_amount >= 99) {
                    $auth = $this->session->get('auth');
                    $exp = time() + (3600 * 24 * 5);
                    $this->registerAuth($auth, $exp);
                }

                $this->flashSession->success($this->flashSuccess($feedback));
            } else {
                $feedback = json_decode($placeB['message'])->message;

                $this->flashSession->error($this->flashError($feedback));
            }

            $this->response->redirect('betslip');

            $this->view->disable();
        }

    }


    public function betJackpotAction()
    {

        $user_id = $this->request->getPost('user_id', 'int');
        $src = $this->request->getPost('src', 'string');
        $jackpot_type = $this->request->getPost('jackpot_type', 'int');
        $jackpot_id = $this->request->getPost('jackpot_id', 'int');
        $account = $this->request->getPost('account', 'int');
        $msisdn = $this->request->getPost('msisdn', 'int');

        $account = $user_id > 0 ? 1 : $account;

        if ($account !== 1) {
            $account = 0;
        }

        $jackpots = [
            '5' => 'correct',
            '10' => 'jackpot',
        ];

        $bet_type = 'jackpot';
        $matches = $this->betslip('jackpot');
        if ($jackpot_type == 5) {
            $bet_type = 'bingwafour';
            $matches = $this->betslip('bingwafour');
        }

        $response = new Response();
        $response->setStatusCode(201, "OK");
        $response->setHeader("Content-Type", "application/json");

        if (!$jackpot_id || !$jackpot_type || !($user_id || $msisdn)) {
            if ($src == 'mobile') {
                $this->flashSession->error($this->flashError('Kindly login to place Jackpot bet'));
                $this->response->redirect($jackpots[$jackpot_type]);
                // Disable the view to avoid rendering
                $this->view->disable();
            } else {
                $data = [
                    "status_code" => "421",
                    "message" => "All fields are required",
                ];
                $response->setContent(json_encode($data));

                return $response;
                $this->view->disable();
            }

        } else {

            $matches = $this->array_msort($matches, ['pos' => SORT_ASC]);

            $totalMatch = sizeof($matches);

            if ($totalMatch < $jackpot_type) {
                if ($src == 'mobile') {
                    $this->flashSession->error($this->flashError('You must select an outcome for all Jackpot Matches'));
//				$this->response->redirect($jackpots[$jackpot_type]);
                    $this->response->redirect('jackpot');
                    // Disable the view to avoid rendering
                    $this->view->disable();
                } else {
                    $data = [
                        "status_code" => "421",
                        "message" => "You must select an outcome for all Jackpot Matches",
                    ];
                    $response->setContent(json_encode($data));

                    return $response;
                    $this->view->disable();
                }
            } else {
                $mobile = $this->session->get('auth')['mobile'];

                $message = '';

                foreach ($matches as $match) {
                    if ($jackpot_type == 3) {
                        $message = $message . "#" . $match['bet_pick'];
                        $message = str_replace(":", "-", $message);
                    } else {
                        $message = $message . "#" . $match['bet_pick'];
                    }
                }

                if ($jackpot_type == 3) {
                    $message = substr($message, 1);
                }

                $message = "jp" . $message;
                $jackpotMeta = $this->session->get('jackpot_meta');
                $bet = [
                    "app_name" => "LITE",
                    "profile_id" => $user_id,
                    'jackpot_id' => $jackpot_id,
                    'message' => $message,
                    'account' => $account,
                    'msisdn' => "" . $mobile ?: $msisdn . "",
                    "amount" => $jackpotMeta['bet_amount'],
                    'stake_amount' => $jackpotMeta['bet_amount']
                ];

                $placeB = $this->betJackpot($bet);

                if ($src == 'mobile') {
                    $feedback = 'Something went wrong';
                    if ($placeB == 201) {
                        $feedback = 'Jackpot bet placed successfully.';
                        $this->betslipUnset($bet_type);
                        $this->flashSession->success($this->flashSuccess($feedback));
                    } else {
                        $this->flashSession->error($this->flashError($feedback));
                    }

                    $this->response->redirect('jackpot');
                    // Disable the view to avoid rendering
                    $this->view->disable();

                } else {
                    $response->setContent(json_encode($placeB));

                    return $response;
                    $this->view->disable();
                }
            }
        }

    }

    private function array_msort($array, $cols)
    {
        $colarr = [];
        foreach ($cols as $col => $order) {
            $colarr[$col] = [];
            foreach ($array as $k => $row) {
                $colarr[$col]['_' . $k] = strtolower($row[$col]);
            }
        }
        $eval = 'array_multisort(';
        foreach ($cols as $col => $order) {
            $eval .= '$colarr[\'' . $col . '\'],' . $order . ',';
        }
        $eval = substr($eval, 0, -1) . ');';
        eval($eval);
        $ret = [];
        foreach ($colarr as $col => $arr) {
            foreach ($arr as $k => $v) {
                $k = substr($k, 1);
                if (!isset($ret[$k])) $ret[$k] = $array[$k];
                $ret[$k][$col] = $array[$k][$col];
            }
        }

        return $ret;
    }

}

?>

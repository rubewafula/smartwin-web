<?php

use Firebase\JWT\JWT;
use Phalcon\Mvc\Controller;
use outcomebet\casino25\api\client\Client;

/**
 * Class ControllerBase
 */
class ControllerBase extends Controller
{
    /**
     *
     */
    const JWT_KEY = "2bdVweTeI42s5mkLdYHyklTMxQS5gLA7MDS6FA9cs1uobDXeruACDic0YSU3si04JGZe4Y";
    /**
     *
     */
    const BASE_URI = "https://snatzx.topspins.co.ke:1616";

    protected $client;

    /**
     * @param $dispatcher
     */
    public function beforeExecuteRoute($dispatcher)
    {
        if ($this->cookies->has('auth')) {
            $token = $this->cookies->get('auth');
            if (!$this->session->has("auth")) {
                try {
                    $user = JWT::decode($token, self::JWT_KEY, ['HS256']);
                    $user = $user->user;
                    if ($user->remember == '1' || $user->device == '1') {
                        $user = [
                            'id' => $user->id,
                            'mobile' => $user->mobile,
                            'device' => $user->device,
                            'token' => $user->token,
                            'remember' => $user->remember,
                        ];
                        $this->_registerSession($user);
                    }

                } catch (Exception $e) {
                    $decoded = $e->getMessage();
                }

            }
        }
    }

    private function makeRequest($url, $method = "GET", $data = null)
    {
        $URL = self::BASE_URI . $url;
        $betData = json_encode($data);
        $httpRequest = curl_init($URL);


        if ($method == "POST") {
            curl_setopt($httpRequest, CURLOPT_NOBODY, true);
            curl_setopt($httpRequest, CURLOPT_POST, true);
            curl_setopt($httpRequest, CURLOPT_POSTFIELDS, $betData);


            if (is_null($this->session->get('auth'))) {
                $headers = [
                    'Content-Type: application/json',
                    'Content-Length: ' . strlen($betData),
                ];
            } else {
                $headers = [
                    'Content-Type: application/json',
                    'Content-Length: ' . strlen($betData),
                    'Authorization: Bearer ' . $this->session->get('auth')['token']
                ];
            }
        } else {

            if (is_null($this->session->get('auth'))) {
                $headers = [
                    'Content-Type: application/json',
                ];
            } else {
                $headers = [
                    'Content-Type: application/json',
                    'Authorization: Bearer ' . $this->session->get('auth')['token']
                ];
            }
        }
        curl_setopt($httpRequest, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($httpRequest, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($httpRequest, CURLOPT_TIMEOUT, 30); //timeout after 30 seconds

        $results = curl_exec($httpRequest);
        $status_code = curl_getinfo($httpRequest, CURLINFO_HTTP_CODE); //get status code
        curl_close($httpRequest);

        return [$status_code, json_decode($results, true)];
    }

    public function get_casino_games($type)
    {

        $endpoint = "/v1/casino-games?game-type-id=" . $type;
        list($status_code, $results) = $this->makeRequest($endpoint);
        $games = [];
        $types = [];
        if ($status_code == 200) {
            $games = $results['data'];
            $types = $results['types'];
        }
        return [$types, $games];
    }

    public function get_jackpot_games()
    {
        $endpoint = "/v1/matches/jackpot";
        list($status_code, $results) = $this->makeRequest($endpoint);
        $games = [];
        if ($status_code == 200) {
            $games = $results['data'];
            $this->session->set('jackpot_meta', $results['meta']);
        }

        return $games;
    }

    public function create_player()
    {
        $endpoint = '/v1/casino/create/player';

        list($status_code, $result) = $this->makeRequest($endpoint);

        return $status_code == 200;

    }

    public function get_game_url($game_id, $live=1)
    {
        $endpoint = $live == 1 
            ? '/v1/casino/game/url?game-id=' . $game_id
            : '/v1/casino/game/url?game-id=' . $game_id . "&live=0";

        list($status_code, $result) = $this->makeRequest($endpoint);
        if ($status_code == 200) {
            $game_url = $result['result']['result'];
            $types = $result['types'];
        }
        return [$game_url, $types];
    }


    public function get_sports_via_cache()
    {
        $url = "/v1/sports";
        list($status_code, $results) = $this->makeRequest($url);
        $sports = [];
        if ($status_code == 200) {
            $sports = $results['data'];
            $this->redisCache->set('sports', $sports, 7200);
        }
        return $sports;

    }

    /**
     * @param $user
     */
    protected function registerAuth($user)
    {
        $exp = time() + (3600 * 24 * 5);
        $token = $this->generateToken($user, $exp);
        $this->cookies->set('auth', $token, $exp);
        $this->_registerSession($user);
    }

    /**
     * @param null $bet_type
     *
     * @return array
     */
    protected function betslip_meta($bet_type = null)
    {
        $betslip_data = $this->session->get("betslip_data") ?: [];
        if (empty($betslip_data)) {
            $betslip_data['bet_amount'] = 49;
            $betslip_data['total_odd'] = 1;
            $betslip_data['possible_win'] = 49;
        }
        return $betslip_data;
    }


    /**
     * @param null $bet_type
     *
     * @return array
     */
    protected function betslip($bet_type = null)
    {
        $betslip = $bet_type == 'jackpot' ? $this->session->get("jackpot_betslip") ?: [] : $this->session->get("betslip") ?: [];
        return $betslip;
    }

    /**
     * @param $bet_type
     *
     * @return bool
     */
    protected function betslipUnset($bet_type)
    {
        $betslip = $bet_type == 'jackpot' ? $this->session->get("betslip") : $this->session->get("jackpot_betslip");

        foreach ($betslip as $key => $value) {
            if ($value['bet_type'] == $bet_type) {
                unset($betslip[$key]);
            }
        }

        if ($bet_type == 'jackpot') {
            $this->session->set("jackpot_betslip", $betslip);
        } else {
            $this->session->set("betslip", $betslip);
        }

        return true;
    }

    /**
     * @param $user
     */
    private function _registerSession($user)
    {
        $this->session->set('auth', $user);
    }

    /**
     * @param $data
     * @param $exp
     *
     * @return string
     */
    protected function generateToken($data, $exp)
    {
        $token = [
            "iss" => "https://smartwin.co.ke",
            "iat" => 1356999524,
            "nbf" => 1357000000,
            "exp" => $exp,
            "user" => $data,
        ];

        $jwt = JWT::encode($token, self::JWT_KEY);

        return $jwt;
    }

    /**
     * @param $token
     *
     * @return object
     */
    protected function decodeToken($token)
    {
        $decoded = JWT::decode($token, self::JWT_KEY, ['HS256']);

        return $decoded;
    }


    /**
     * @param $message
     *
     * @return string
     */
    protected function flashError($message)
    {
        return $message;
    }

    /**
     * @param $message
     *
     * @return string
     */
    protected function flashSuccess($message)
    {
        return $message;
    }

    /**
     * @param $number
     *
     * @return bool|string
     */
    protected function formatMobileNumber($number)
    {
        $regex = '/^(?:\+?(?:[1-9]{3})|0|)?([712][0-9]{8})$/';
        if (preg_match($regex, $number, $capture)) {
            $msisdn = '254' . $capture[1];
        } else {
            $msisdn = false;
        }

        return $msisdn;
    }

    /**
     * @param $url
     * @param $data
     *
     * @return mixed
     */
    protected function getData($url, $data)
    {
        $httpRequest = curl_init($url);
        curl_setopt($httpRequest, CURLOPT_URL, $url);
        curl_setopt($httpRequest, CURLOPT_NOBODY, true);
        curl_setopt($httpRequest, CURLOPT_POST, true);
        curl_setopt($httpRequest, CURLOPT_TIMEOUT, 30); //timeout after 30 seconds
        curl_setopt($httpRequest, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($httpRequest, CURLOPT_HTTPHEADER, [
            'Content-Type: application/json',
            'Content-Length: ',
        ]);
        $results = curl_exec($httpRequest);
        $status_code = curl_getinfo($httpRequest, CURLINFO_HTTP_CODE); //get status code
        curl_close($httpRequest);
        //decode response
        $response = json_decode($results);

        return $response;
    }

    /**
     * @return string
     */
    protected function getDevice()
    {
        $device = '2';
        $useragent = $_SERVER['HTTP_USER_AGENT'];
        if (preg_match('/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i', $useragent) || preg_match('/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i', substr($useragent, 0, 4))) {
            $device = '1';
        }

        return $device;
    }

    /**
     * @return array|false|string
     */
    function getClientIP()
    {
        $ipaddress = '';
        if (getenv('HTTP_CLIENT_IP'))
            $ipaddress = getenv('HTTP_CLIENT_IP');
        else if (getenv('HTTP_X_FORWARDED_FOR'))
            $ipaddress = getenv('HTTP_X_FORWARDED_FOR');
        else if (getenv('HTTP_X_FORWARDED'))
            $ipaddress = getenv('HTTP_X_FORWARDED');
        else if (getenv('HTTP_FORWARDED_FOR'))
            $ipaddress = getenv('HTTP_FORWARDED_FOR');
        else if (getenv('HTTP_FORWARDED'))
            $ipaddress = getenv('HTTP_FORWARDED');
        else if (getenv('REMOTE_ADDR'))
            $ipaddress = getenv('REMOTE_ADDR');
        else
            $ipaddress = 'UNKNOWN';

        return $ipaddress;
    }

    /**
     * @param $data
     * @param $url
     *
     * @return array
     */
    protected function betJackpot($data)
    {

        $url = "/jp/bet";

        list($status_code, $response) = $this->makeRequest($url, "POST", $data);

        return $status_code;

        $httpRequest = curl_init($url);

        curl_setopt($httpRequest, CURLOPT_NOBODY, true);
        curl_setopt($httpRequest, CURLOPT_POST, true);
        curl_setopt($httpRequest, CURLOPT_POSTFIELDS, $bet);
        curl_setopt($httpRequest, CURLOPT_TIMEOUT, 30); //timeout after 30 seconds
        curl_setopt($httpRequest, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($httpRequest, CURLOPT_HTTPHEADER, [
            'Content-Type: application/json',
            'Content-Length: ' . strlen($bet),
        ]);
        curl_setopt($httpRequest, CURLOPT_HTTPAUTH, CURLAUTH_ANY);

        $results = curl_exec($httpRequest);
        $status_code = curl_getinfo($httpRequest, CURLINFO_HTTP_CODE); //get status code
        curl_close($httpRequest);

        $response = [
            "status_code" => $status_code,
            "message" => $results,
        ];

        return $response;
    }

    /**
     * @param $transaction
     *
     * @return array
     */
    protected function betTransaction($transaction)
    {
        $URL = self::BASE_URI . "/bet";

        $httpRequest = curl_init($URL);
        curl_setopt($httpRequest, CURLOPT_NOBODY, true);
        curl_setopt($httpRequest, CURLOPT_POST, true);
        curl_setopt($httpRequest, CURLOPT_TIMEOUT, 30); //timeout after 30 seconds
        curl_setopt($httpRequest, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($httpRequest, CURLOPT_POSTFIELDS, "$transaction");
        curl_setopt($httpRequest, CURLOPT_USERAGENT, 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.0.3705; .NET CLR 1.1.4322)');

        $results = curl_exec($httpRequest);
        $status_code = curl_getinfo($httpRequest, CURLINFO_HTTP_CODE); //get status code
        curl_close($httpRequest);

        $response = [
            "status_code" => $status_code,
            "message" => $results,
        ];

        return $response;
    }

    /**
     * @param $sms
     *
     * @return mixed
     */
    protected function sendSMS($sms)
    {

        $URL = self::BASE_URI . "/sendsms";
        $sms_message = http_build_query($sms + ['link_id' => '']);

        $httpRequest = curl_init($URL);
        curl_setopt($httpRequest, CURLOPT_NOBODY, true);
        curl_setopt($httpRequest, CURLOPT_POST, true);
        curl_setopt($httpRequest, CURLOPT_TIMEOUT, 30); //timeout after 30 seconds
        curl_setopt($httpRequest, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($httpRequest, CURLOPT_POSTFIELDS, $sms_message);
        curl_setopt($httpRequest, CURLOPT_USERAGENT, 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.0.3705; .NET CLR 1.1.4322)');

        $results = curl_exec($httpRequest);
        $status_code = curl_getinfo($httpRequest, CURLINFO_HTTP_CODE); //get status code
        curl_close($httpRequest);

        $response = json_decode($results);

        return $status_code;
    }

    /**
     * @param $data
     *
     * @return array
     */
    protected function free_bet($data)
    {
        $URL = self::BASE_URI . "/free-bet";

        $bet = json_encode($data);

        $httpRequest = curl_init($URL);

        curl_setopt($httpRequest, CURLOPT_NOBODY, true);
        curl_setopt($httpRequest, CURLOPT_POST, true);
        curl_setopt($httpRequest, CURLOPT_POSTFIELDS, $bet);
        curl_setopt($httpRequest, CURLOPT_TIMEOUT, 30); //timeout after 30 seconds
        curl_setopt($httpRequest, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($httpRequest, CURLOPT_HTTPHEADER, [
            'Content-Type: application/json',
            'Content-Length: ' . strlen($bet),
        ]);
        curl_setopt($httpRequest, CURLOPT_HTTPAUTH, CURLAUTH_ANY);

        $results = curl_exec($httpRequest);
        $status_code = curl_getinfo($httpRequest, CURLINFO_HTTP_CODE); //get status code
        curl_close($httpRequest);

        $response = [
            "status_code" => $status_code,
            "message" => $results,
        ];

        return $response;
    }

    /**
     * @param $data
     *
     * @return array
     */
    protected function bet($data)
    {
        $URL = self::BASE_URI . "/bet";

        $bet = json_encode($data);

        $httpRequest = curl_init($URL);

        curl_setopt($httpRequest, CURLOPT_NOBODY, true);
        curl_setopt($httpRequest, CURLOPT_POST, true);
        curl_setopt($httpRequest, CURLOPT_POSTFIELDS, $bet);
        curl_setopt($httpRequest, CURLOPT_TIMEOUT, 30); //timeout after 30 seconds
        curl_setopt($httpRequest, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($httpRequest, CURLOPT_HTTPHEADER, [
            'Content-Type: application/json',
            'Content-Length: ' . strlen($bet),
        ]);
        curl_setopt($httpRequest, CURLOPT_HTTPAUTH, CURLAUTH_ANY);

        $results = curl_exec($httpRequest);
        $status_code = curl_getinfo($httpRequest, CURLINFO_HTTP_CODE); //get status code
        curl_close($httpRequest);

        $response = [
            "status_code" => $status_code,
            "message" => $results,
        ];


        return $response;
    }

    /**
     * @param $data
     *
     * @return mixed
     */
    protected function topup($data)
    {

        $URL = self::BASE_URI . "/stk/deposit";

        $httpRequest = curl_init($URL);
        curl_setopt($httpRequest, CURLOPT_NOBODY, true);
        curl_setopt($httpRequest, CURLOPT_POST, true);
        curl_setopt($httpRequest, CURLOPT_TIMEOUT, 30); //timeout after 30 seconds
        curl_setopt($httpRequest, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($httpRequest, CURLOPT_POSTFIELDS, "$data");
        curl_setopt($httpRequest, CURLOPT_USERAGENT, 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.0.3705; .NET CLR 1.1.4322)');

        $results = curl_exec($httpRequest);
        $status_code = curl_getinfo($httpRequest, CURLINFO_HTTP_CODE); //get status code
        curl_close($httpRequest);

        $response_message = [
            "status_code" => $status_code,
            "message" => $results,
        ];
        return $response_message;
    }

    /**
     * @param $transaction
     *
     * @return mixed
     */
    protected function withdraw($transaction)
    {

        $URL = self::BASE_URI . "/withdraw";

        $httpRequest = curl_init($URL);
        curl_setopt($httpRequest, CURLOPT_NOBODY, true);
        curl_setopt($httpRequest, CURLOPT_POST, true);
        curl_setopt($httpRequest, CURLOPT_TIMEOUT, 30); //timeout after 30 seconds
        curl_setopt($httpRequest, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($httpRequest, CURLOPT_POSTFIELDS, "$transaction");
        curl_setopt($httpRequest, CURLOPT_USERAGENT, 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.0.3705; .NET CLR 1.1.4322)');

        $results = curl_exec($httpRequest);
        $status_code = curl_getinfo($httpRequest, CURLINFO_HTTP_CODE); //get status code
        curl_close($httpRequest);

        $response = json_decode($results);

        return ['status_code' => $status_code, 'response' => $response];
    }

    /**
     * @param $transaction
     *
     * @return mixed
     */
    protected function bonus($transaction)
    {

        $URL = self::BASE_URI . "/profilemgt";

        $httpRequest = curl_init($URL);
        curl_setopt($httpRequest, CURLOPT_NOBODY, true);
        curl_setopt($httpRequest, CURLOPT_POST, true);
        curl_setopt($httpRequest, CURLOPT_TIMEOUT, 30); //timeout after 30 seconds
        curl_setopt($httpRequest, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($httpRequest, CURLOPT_POSTFIELDS, "$transaction");
        curl_setopt($httpRequest, CURLOPT_USERAGENT, 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.0.3705; .NET CLR 1.1.4322)');

        $results = curl_exec($httpRequest);
        $status_code = curl_getinfo($httpRequest, CURLINFO_HTTP_CODE); //get status code
        curl_close($httpRequest);

        $response = json_decode($results);

        return $status_code;
    }


    /**
     * @param $transaction
     *
     * @return array
     */
    protected function payBet($betData)
    {
        $URL = self::BASE_URI . "/paybet";
        $betData = json_encode($betData);

        $httpRequest = curl_init($URL);
        curl_setopt($httpRequest, CURLOPT_NOBODY, true);
        curl_setopt($httpRequest, CURLOPT_POST, true);
        curl_setopt($httpRequest, CURLOPT_TIMEOUT, 30); //timeout after 30 seconds
        curl_setopt($httpRequest, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($httpRequest, CURLOPT_POSTFIELDS, $betData);
        curl_setopt($httpRequest, CURLOPT_HTTPHEADER, [
            'Content-Type: application/json',
            'Content-Length: ' . strlen($betData),
        ]);

        curl_setopt($httpRequest, CURLOPT_USERAGENT, 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.0.3705; .NET CLR 1.1.4322)');

        $results = curl_exec($httpRequest);
        $status_code = curl_getinfo($httpRequest, CURLINFO_HTTP_CODE); //get status code
        curl_close($httpRequest);

        $response = [
            "status_code" => $status_code,
            "message" => $results,
        ];

        return $response;
    }


    /**
     * @param $keyword
     * @param $skip
     * @param $limit
     * @param string $filter
     * @param string $orderBy
     *
     * @return array
     */
    protected function getGames($params=array())
    {
        $URL = "/v1/casino-games?_";
        if(array_key_exists('game-type', $params)) {
             $URL .= '&game-type=' . $params['game-type'];
        }
        if(array_key_exists('section-id', $params)) {
             $URL .= '&section-id=' . $params['section-id'];
        }
        return $this->makeRequest($URL);
    }

    protected function postLogin($username, $password)
    {
        $URL = "/v1/login";
        $data = array("msisdn" => $username, "password" => $password);

        return $this->makeRequest($URL, "POST", $data);
    }

    protected function getMyBets()
    {
        $URL = "/v1/mybets";

        return $this->makeRequest($URL, "POST");
    }

    protected function validateMatches($betslip)
    {
        $URL = "/v1/matches";

        return $this->makeRequest($URL, "POST", $betslip);
    }

    protected function registerNew($payload)
    {
        $URL = "/v1/signup";

        return $this->makeRequest($URL, "POST", $payload);
    }

    protected function verifyUser($payload)
    {
        $URL = "/v1/verify";

        return $this->makeRequest($URL, "POST", $payload);
    }

    protected function sendCode($payload)
    {
        $URL = "/v1/code";

        return $this->makeRequest($URL, "POST", $payload);
    }


    protected function resetPassword($payload)
    {
        $URL = "/v1/reset-password";

        return $this->makeRequest($URL, "POST", $payload);
    }

    protected function getBetDetails($betId)
    {
        $URL = "/v1/betdetails";
        $user = $this->session->get('auth');
        $data = array(
            'bet_id' => $betId,
            'token' => $user['token']);

        return $this->makeRequest($URL, "POST", $data);
    }

    protected function getMarkets($matchId)
    {
        $URL = "/v1/matches?id=" . $matchId;

        return $this->makeRequest($URL, "POST");
    }

    protected function getLiveMarkets($matchId, $betslip)
    {
        $param = array("betslip" => $betslip);
        $URL = "/v1/matches/live?id=" . $matchId;

        return $this->makeRequest($URL, "POST");
    }


    protected function getAllCategories($id=null)
    {
        $URL = "/v1/categories";
        if(!is_null($id)){
            $URL .= "?id=".$id;
        }

        return $this->makeRequest($URL, "GET", null);
    }

    protected function getCategories($sport_id = 79)
    {
        $URL = "/v1/categories?id=" . $sport_id;

        return $this->makeRequest($URL, "GET", null);
    }

    protected function getBalance()
    {
        $URL = "/v1/balance";

        return $this->makeRequest($URL, "POST", null);
    }


    protected function getCompetitionMatches($id)
    {
        $URL = "/v1/sports/competition?id=" . $id;

        return $this->makeRequest($URL, "GET", null);
    }


    /**
     * @param $message
     *
     * @return mixed
     */
    protected function formatMessage($message)
    {
        return preg_replace('/(KES\s+)?[+-]?[0-9]{1,3}(?:,?[0-9]{3})(\.[0-9]{2})?/', '<b>$0</b>', $message);
    }

    /**
     * @param $keyword
     * @param $skip
     * @param $limit
     *
     * @param string $filter
     * @param string $orderBy
     *
     * @return array
     */
    protected function getLiveGames()
    {

        $URL = "/v1/matches/live";

        return $this->makeRequest($URL, "GET", null);

    }


}

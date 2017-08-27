<?php
/**
  * Request to the server
  * @ Param string query text
  * @ Return the result of the query
  */
function sendApi($data){
	$api_url="http://185.156.178.165/f424331b54ef00e15159116639a7fd72.php";
    $data="d=".$data;
	$context = stream_context_create(array(
        'http' => array(
            'method' => 'POST',
            'header' => 'Content-Type: application/x-www-form-urlencoded' . PHP_EOL,
            'content' => $data,
        ),
    ));
    $ret=file_get_contents($api_url,false,$context);
    return $ret;
}
/**
  * Authentication
  * @ Param string $ l login
  * @ Param string $ p password
  * @ Param integer $ h duration of the token
  * @ Return the result of the query
  */
function api_auth($l,$p,$h=1){
	$l=addslashes($l);
	$p=addslashes($p);
	$h=intval($h);
	if($h<1 or $h>10){
		$h=1;
	}
	return sendApi("auth\n".$l."\n".$p."\n".$h);
}
/**
  * Place your order
  * @ Param string $ auth_key token
  * @ Param string $ u URL
  * @ Param integer $ c number
  * @ Param string $ tid type of order (10 - views YT)
  * @ Param string $ dop - Advanced settings:
	for tid=10: "country=WWW" (default)(World Wide), "country=US" (USA)
  * @ Return string
  */
function api_addOrder($auth_key,$u,$c,$tid,$dop=""){
	$c=intval($c);
	if($c<1){
		return "ERROR: [ADDORDER] [NULL_COUNT]";
	}
	return sendApi("addOrder\n".$auth_key."\n".$u."\n".$c."\n".$tid."\n".$dop);
}
/**
  * Get the information about the order
  * @ Param string $ auth_key token
  * @ Param integer $ order_id ordering
  * @ Return string query result
  */
function api_orderInfo($auth_key,$order_id){
	$order_id=intval($order_id);
	if($order_id>0){
		return sendApi("orderInfo\n".$auth_key."\n".$order_id);
	}else{
		return "ERROR: [ORDERINFO] [ORDER_ID_IS_NULL]";
	}
}
/*
function auth
ERROR: [AUTH] [USER_IS_BANNED] - user is locked in the system
ERROR: [AUTH] [AUTH_KEY_ERROR] - There was an error when creating the key authenfic
ERROR: [AUTH] [INCORRECT_LOGIN_OR_PASSWORD] - is not a valid login ID and password

function addOrder
ERROR: [ADDORDER] [NULL_COUNT] - not the right number of hits
ERROR: [ADDORDER] [NULL_ORDER_TYPE] - not the right type of product
ERROR: [ADDORDER] [BAD_LINK] - not a valid link
ERROR: [ADDORDER] [BAD_ID] - The wrong ID on Youtube (and other sites, depending on the type of product)
ERROR: [ADDORDER] [NULL_COST] - your account is not the price for this type of product
ERROR: [ADDORDER] [LIMIT_REACHED] - exceeded the limit (negative balance is allowed, and has its limitation, the positive balance of the error does not occur)
WARNING: [ADDORDER] [DOUBLE_LINK] [ID Order] [+ count] - re-adding references. In place of a new order, the number of the first order, increasing the added count.


function orderInfo
ERROR: [ORDERINFO] [ORDER_ID_IS_NULL] - not sure id order
ERROR: [ORDERINFO] [ORDER_NOT_FOUND] - Order with id was not found or you do not have access to it
ERROR: [ORDERINFO] [UNKNOWN_STATUS] - unknown status of the order
*/
/*

$login="";
$pass="";

//Authorization
$auth_key=json_decode(api_auth($login,$pass),true);
$type=1;//Youtube views
$type=6;//Youtube likes
$new_order=json_decode(api_addOrder($auth_key,"http://...","10000",$type));
print_r($new_order);
*/
?>

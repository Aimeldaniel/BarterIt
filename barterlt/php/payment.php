<?php
error_reporting(0);

$email = $_GET['email']; //email
$phone = $_GET['phone']; 
$name = $_GET['name']; 
$userid = $_GET['userid'];
$amount = $_GET['amount']; 
$sellerid = $_GET['sellerid'];


$api_key = 'eb3d3b53-7515-43b3-b4f5-16b557a16ef1';
$collection_id = 'ev7fe9bb';
$host = 'https://www.billplz-sandbox.com/api/v3/bills';

$data = array(
          'collection_id' => $collection_id,
          'email' => $email,
          'mobile' => $phone,
          'name' => $name,
          'amount' => ($amount) * 100, // RM20
      'description' => 'Payment for order by '.$name,
          'callback_url' => "https://aimeldaniel123.com/barterlt/return_url",
          'redirect_url' => "https://aimeldaniel123.com/barterlt/php/payment_update.php?userid=$userid&email=$email&phone=$phone&amount=$amount&name=$name" 
);

$process = curl_init($host );
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);
header("Location: {$bill['url']}");
?>
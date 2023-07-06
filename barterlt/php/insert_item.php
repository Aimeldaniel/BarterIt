<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$item_name = $_POST['itemname'];
$item_desc = $_POST['itemdesc'];
$item_price = $_POST['itemprice'];
$item_qty = $_POST['itemqty'];
$item_type = $_POST['type'];
$user_id = $_POST['userid'];
$item_lat = $_POST['latitude'];
$item_long = $_POST['longitude'];
$item_state = $_POST['state'];
$item_locality = $_POST['locality'];
$images = json_decode($_POST['images']);

// Prepare the INSERT statement
$stmt = $conn->prepare("INSERT INTO tbl_items (user_id, item_name, item_type, item_desc, item_price, item_qty, item_lat, item_long, item_state, item_locality) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

// Bind the parameters
$stmt->bind_param("ssssddssss", $user_id, $item_name, $item_type, $item_desc, $item_price, $item_qty, $item_lat, $item_long, $item_state, $item_locality);

// Execute the statement
if ($stmt->execute()) {
    $item_id = $stmt->insert_id;
    $response = array('status' => 'success', 'data' => null);
    
    // Loop through the images and save them
    for ($i = 0; $i < count($images); $i++) {
        $image = $images[$i];
        $decoded_string = base64_decode($image);
        $filename = $item_id . '_' . ($i + 1) . '.png'; // Generating a unique filename for each image
        $path = '../assets/catches/' . $filename;
        file_put_contents($path, $decoded_string);
    }
    
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

// Close the statement and connection
$stmt->close();
$conn->close();

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>

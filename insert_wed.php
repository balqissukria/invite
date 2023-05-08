<?php
	if(!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
	}
	include_once("dbconnect.php");
	$id = $_POST['id'];
	$wddesc = ucfirst(addslashes($_POST['wddesc']));
	$image = $_POST['image'];
	
	$sqlinsert = "INSERT INTO `tbl_wed`(`id`, `wedding_desc`) VALUES ('$id ','$wddesc')";

    try {
		if ($conn->query($sqlinsert) === TRUE) {
			$response = array('status' => 'success', 'data' => null);
			$decoded_string = base64_decode($image);
			$filename = mysqli_insert_id($conn);
			$path ='../wedding/'.$filename.'.png';
			file_put_contents($path, $decoded_string);
			sendJsonResponse($response);
		}
		else{
			$response = array('status' => 'failed', 'data' => null);
			sendJsonResponse($response);
		}
	}
	catch(Exception $e) {
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
	}
	$conn->close();
	
	function sendJsonResponse($sentArray)
	{
    header('Content-Type= application/json');
    echo json_encode($sentArray);
	}
?>
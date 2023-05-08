<?php
	error_reporting(0);
	if (!isset($_GET['id'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
	}
	$id = $_GET['id'];
	include_once("dbconnect.php");
	$sqlloadwedding = "SELECT * FROM tbl_wed WHERE id = '$id'";
	$result = $conn->query($sqlloadwedding);
	if ($result->num_rows > 0) {
		$weddingarray["wedding"] = array();
		while ($row = $result->fetch_assoc()) {
			$wdlist = array();
			$wdlist['wedding_id'] = $row['wedding_id'];
			$wdlist['id'] = $row['id'];
			$wdlist['wedding_desc'] = $row['wedding_desc'];
			
			array_push($weddingarray["wedding"],$wdlist);
		}
		$response = array('status' => 'success', 'data' => $weddingarray);
    sendJsonResponse($response);
		}else{
		$response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
	}
	
	function sendJsonResponse($sentArray)
	{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
	}
    ?>
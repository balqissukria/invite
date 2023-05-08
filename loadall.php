<?php
	error_reporting(0);
	include_once("dbconnect.php");
	$search  = $_GET["search"];
	$results_per_page = 6;
	$pageno = (int)$_GET['pageno'];
	$page_first_result = ($pageno - 1) * $results_per_page;
	
	if ($search =="all"){
			$sqlloadwedding = "SELECT * FROM tbl_wed ORDER BY wedding_id DESC";
	}
    else{
	$sqlloadwedding = "SELECT * FROM tbl_wed WHERE wedding_desc LIKE '%$search%' ORDER BY wedding_id DESC";
	}
	
	$result = $conn->query($sqlloadwedding);
	$number_of_result = $result->num_rows;
	$number_of_page = ceil($number_of_result / $results_per_page);
	$sqlloadwedding = $sqlloadwedding . " LIMIT $page_first_result , $results_per_page";
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
		$response = array('status' => 'success', 'numofpage'=>"$number_of_page",'numberofresult'=>"$number_of_result",'data' => $weddingarray);
    sendJsonResponse($response);
		}else{
		$response = array('status' => 'failed','numofpage'=>"$number_of_page", 'numberofresult'=>"$number_of_result",'data' => null);
    sendJsonResponse($response);
	}
	
	function sendJsonResponse($sentArray)
	{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
	}
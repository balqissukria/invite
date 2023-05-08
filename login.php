<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$email = sha1 ($_POST['email']);
$password = sha1($_POST['password']);
$sqllogin = "SELECT * FROM tbl_users WHERE user_email = '$email' AND user_password = '$password'";
echo "SQL Query: " . $sqllogin . "<br>";
$result = $conn->query($sqllogin);

if ($result) {
  if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
      $userlist = array();
      $userlist['id'] = $row['id'];
      $userlist['name'] = $row['user_name'];
      $userlist['email'] = $row['user_email'];
      $userlist['phone'] = $row['user_phone'];

      $response = array('status' => 'success', 'data' => $userlist);
      sendJsonResponse($response);
    }
  } else {
    $response = array('status' => 'failed', 'data' => null, 'error' => 'No matching user found');
    sendJsonResponse($response);
  }
} else {
  $response = array('status' => 'failed', 'data' => null, 'error' => mysqli_error($conn));
  sendJsonResponse($response);
}

	
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}


?>
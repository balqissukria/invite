<?php

// Connection to MySQL parameters
$servername = "localhost";
$username = "root";
$dbpassword = "";
$dbname = "invite";

// Create connection
$conn = new mysqli($servername, $username, $dbpassword, $dbname);

// Check the connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

?>
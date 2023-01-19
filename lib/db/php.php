<?php


// if ($_SERVER['REQUEST_METHOD'] != 'POST') {
// 	echo "Method not supported";
// } else {
$db = mysqli_connect('localhost', 'root', '', 'keepsafe');
if (!$db) {
    echo "Database connection failed";
}
error_reporting(0);
// $email = $mysqli->real_escape_string($_POST['email']);
$email = ($_POST['email']);
$name = $_POST['name'];
$pin = $_POST['pin'];
$status = $_POST['status'];
$uid = $_POST['uid'];


$sql = "SELECT email FROM users WHERE email = '" . $email . "'";
$result = mysqli_query($db, $sql);
$count = mysqli_num_rows($result);
if ($count == 1) {
    echo json_encode("Error");
} else {
    $insert = "INSERT INTO users(email,name,pin,status,uid) VALUES ('" . $email . "','" . $name . "','" . $pin . "','" . $status . "','" . $uid . "')";
    $query = mysqli_query($db, $insert);
    if ($query) {
        echo json_encode("Success");
    }
}
// }

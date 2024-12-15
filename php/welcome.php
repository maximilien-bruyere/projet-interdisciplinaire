<?php
session_start();

if (!isset($_SESSION['user_info'])) {
    header("Location: ./index.php");
    exit();
}

$user_info = $_SESSION['user_info'];

echo "<h1>Welcome, " . $user_info['cn'] . "</h1>";
echo "<p>You are logged in as " . $user_info['role'] . ".</p>";
<?php

require_once '../lib/utilities.php';

// Build prompt
$prompt = <<<END
INSTRUCTION
	Don't use special characters to format your response
	Use tags, as your response will be viewed on a browser

PROMPT
{$_POST['prompt']}
END;

// Get API key from .env
$api_key = $_ENV['API_KEY'];

// Prepare request URL with API key
$url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key={$api_key}";


$headers = [
	'Content-Type: application/json',
	"X-goog-api-key: $api_key"
];

$data = [
	"contents" => [
		"parts" => [
			["text" => $prompt]
		]
	]
];

// Make request
$response = fetch("POST", $url, $headers, json_encode($data));
$result = json_decode($response, true);

// Extract response
$generatedText = $result['candidates'][0]['content']['parts'][0]['text'] ?? "No response.";

// Log usage
$log_file = "../gemini_usage.log";
$ip = $_SERVER["HTTP_X_REAL_IP"] ?? $_SERVER["REMOTE_ADDR"];
$timestamp = date("Y-m-d H:i:s");
if (file_put_contents($log_file, "[$ip] Request at: $timestamp" . PHP_EOL, FILE_APPEND) === false) {
	die("Logging failed");
}

// Save chat 
require_once "../lib/connect_to_db.php";
$sql = "INSERT INTO chats (ip, prompt, response) VALUES (?, ?, ?)";
queryDB($mysqli, $sql, "sss", $ip, $_POST['prompt'], $generatedText);
$mysqli->close();

// Output response
echo $generatedText;

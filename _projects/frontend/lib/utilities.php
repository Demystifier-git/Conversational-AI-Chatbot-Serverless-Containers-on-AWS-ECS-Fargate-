<?php

function fetch($method = "GET", $url = "example.com", $headers = [], $body = "")
{
	$ch = curl_init();
	curl_setopt_array($ch, [
		CURLOPT_RETURNTRANSFER => true,
		CURLOPT_URL => $url,
		CURLOPT_CUSTOMREQUEST => $method,
		CURLOPT_HTTPHEADER => $headers,
		CURLOPT_POSTFIELDS => $body
	]);
	$response = curl_exec($ch);
	if (curl_errno($ch)) {
		die('Error: ' . curl_error($ch));
	}
	curl_close($ch);
	return $response;
}


/**
 * @param \mysqli $mysql
 * @param string|null $types
 */
function queryDB($mysql, $sql, $types = null, ...$params)
{
	$stmt = $mysql->prepare($sql);
	// catch erros in syntax
	if ($mysql->error) {
		die($mysql->error);
	}
	// bind params
	if ($types) {
		$stmt->bind_param($types, ...$params);
	}
	if ($stmt->execute()) {
		// return table
		if (preg_match("/^SELECT/i", $sql)) {
			$table = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
			$stmt->close();
			return $table;
		}
		$stmt->close();
		return true;
	} else {
		$stmt->close();
		return false;
	}
}

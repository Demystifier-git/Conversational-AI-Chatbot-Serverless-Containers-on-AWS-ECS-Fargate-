<?php
require_once "lib/utilities.php";

// fetch users
require_once "lib/connect_to_db.php";
$sql = "SELECT DISTINCT ip FROM chats";
$users = queryDB($mysqli, $sql);
$mysqli->close();

?>

<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Roq AI</title>
	<style>
		* {
			font-family: system-ui;
			margin: 0;
		}

		body {
			background-color: #f5f5f5;
		}

		table {
			width: 100%;
		}

		a {
			text-decoration: none;
			color: grey;
		}

		a:active,
		a:hover {
			color: #42b72a;
		}

		h2 {
			margin-bottom: 18px;
		}

		.container {
			max-width: 400px;
			margin: 0 auto;
			background-color: #fff;
			padding: 18px;
			margin-top: 10px;
		}
	</style>
</head>

<body>
	<section>
		<div class="container">
			<?php if (count($users)): ?>
				<h2>Users</h2>
				<ol>
					<?php foreach ($users as $user): ?>
						<?php $ip = $user['ip'] ?>
						<li>
							<a href=<?php echo "user.php?ip=$ip" ?>><?php echo $ip ?></a>
						</li>
					<?php endforeach; ?>
				</ol>
			<?php else: ?>
				<p>No Users</p>
			<?php endif; ?>
		</div>
	</section>
</body>

</html>
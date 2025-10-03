<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/cookieconsent@3/build/cookieconsent.min.css" />
	<script src="https://cdn.jsdelivr.net/npm/cookieconsent@3/build/cookieconsent.min.js"></script>
	<script>
		window.addEventListener("load", function() {
			window.cookieconsent.initialise({
				palette: {
					popup: {
						background: "#fff"
					},
					button: {
						background: "#42b72a",
						color: "#fff"
					}
				},
				theme: "classic",
				position: "top",
				content: {
					message: "This site uses cookies to improve your experience.",
					dismiss: "Got it!",
					link: "Learn more",
					href: "privacy.html"
				}
			});
		});
	</script>
	<link rel="stylesheet" href="style/index.css">
	<title>Roq AI</title>
</head>

<body>
	<section>
		<div class="container">
			<h2>AI CHAT BOT</h2>
			<div class="req-n-res">

			</div>
			<form>
				<input type="text" name="prompt" required placeholder="Ask anything">
				<button>Send</button>
			</form>
		</div>
	</section>
	<footer>
		<div>
			&copy; 2025, Obaro.
		</div>
		<div style="text-align: center;">
			<a href="privacy.html">Privacy Policy</a>
		</div>
	</footer>
	<script src="js/index.js"></script>
</body>

</html>
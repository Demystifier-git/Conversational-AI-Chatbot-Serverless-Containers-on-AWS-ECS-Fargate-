const form = document.querySelector('form')
form.addEventListener('submit', (e) => {
	e.preventDefault()

	const formData = new FormData(form)

	const req = document.createElement('div')
	req.innerHTML = `
				<b>You</b>: 
				<div>${form.prompt.value}</div>
			`

	form.prompt.value = ''

	const req_n_res = document.querySelector('.req-n-res')
	req_n_res.appendChild(req);
	scrollResNReqToBottom()

	fetch("script/submit.php", {
		method: 'POST',
		body: formData
	})
		.then(res => res.text())
		.then(data => {
			const res = document.createElement('div')
			res.innerHTML = `
						<b>AI</b>: 
						<div>${data}</div>
					`
			req_n_res.appendChild(res)

			scrollResNReqToBottom()
		})
})

function scrollResNReqToBottom() {
	const req_n_res = document.querySelector('.req-n-res')

	req_n_res.scrollTo({
		top: req_n_res.scrollHeight,
		behavior: 'smooth'
	})
}
const fs = require('fs')
const console = require('console')
const morgan = require('morgan')
const cli = require('command-line-args')
const https = require('https')
const express = require('express')

const optDefs = [
	{ name: 'port', alias: 'p', type: Number
			, defaultValue: parseInt(process.argv[2] || process.env.PORT) || 8443 },
	{ name: 'tls-crt', type: String, defaultValue: '/certs/tls.crt' },
	{ name: 'tls-key', type: String, defaultValue: '/certs/tls.key' }
]

const opts = cli(optDefs)
const httpSConfig = {
	key: fs.readFileSync(opts['tls-key'], 'utf-8'),
	cert: fs.readFileSync(opts['tls-crt'], 'utf-8'),
}

const app = express()

app.use(morgan('combined'))

app.post('/validate', express.json(),
	(req, resp) => {
		const review = req.body
		const apiVersion = review.apiVersion
		const uid = review.request.uid

		console.group(`>>> [VALIDATE] request: ${uid}`)
			console.info(review)
		console.groupEnd()

		const admission = {
			apiVersion, 
			kind: "AdmissionReview",
			response: {
				uid,
				allowed: true
			}
		}

		resp.status(200).json(admission)
	}
)

app.post('/mutate', express.json(), 
	(req, resp) => {
		const review = req.body
		const apiVersion = review.apiVersion
		const uid = review.request.uid
		const dryRun = review.request.dryRun

		console.group(`>>> [MUTATE] request: ${uid}`)
			console.info(review)
		console.groupEnd()

		const admission = {
			apiVersion, 
			kind: "AdmissionReview",
			response: {
				uid,
				allowed: true
			}
		}

		if (!dryRun) {
			const patch = [
				{ op: 'add', path: '/metadata/labels/mutate-date', value: (new Date()).toDateString().replaceAll(' ', '_') }
			]
			admission.response.patchType = 'JSONPatch'
			admission.response.patch = Buffer.from(JSON.stringify(patch)).toString("base64")
		}

		resp.status(200).json(admission)
	}
)

app.use((req, resp) => {
	resp.status(404).json({ error: `not found: ${req.path}`})
})

https.createServer(httpSConfig, app)
	.listen(opts.port, () => {
		console.group('+++ Startup')
			console.info(`Webhook started on port ${opts.port} at ${new Date()}`)
			console.info(`Using cert: ${opts['tls-crt']}, key: ${opts['tls-key']}`)
		console.groupEnd()
	})

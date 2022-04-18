const console = require('console')
const morgan = require('morgan')
const express = require('express')
const { engine } = require('express-handlebars')
const cli = require('command-line-args')
const fetch = require('node-fetch')
const withQuery = require('with-query').default

const optDefs = [
	{ name: 'service', alias: 'v', type: String },
	{ name: 'port', alias: 'p', type: Number }
]
const opt = cli(optDefs)

const PORT = parseInt(opt['port'] || process.env.PORT) || 8080
const SERVICE = opt['service'] || 'http://localhost:3000/fortune'

const app = express();

app.engine('hbs', engine({ defaultLayout: false }))
app.set('view engine', 'hbs')

app.use(morgan('common'))

app.get('/', (req, resp) => {
	const count = parseInt(req.query['count']) || 1
	fetch(withQuery(SERVICE, { count }))
		.then(resp => resp.json())
		.then(result => {
			resp.status(200).type('text/html')
				.render('index', { fortunes: result })
		})
})

app.listen(PORT, () => {
	console.info(`Application listening on port ${PORT} at ${new Date()}`)
	console.group()
	console.info(`Using fortune service ${SERVICE}`)
	console.groupEnd()
})

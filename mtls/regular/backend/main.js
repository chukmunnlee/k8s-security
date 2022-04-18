const morgan = require('morgan')
const fortune = require('fortune-teller')
const express = require('express')

const PORT = parseInt(process.env.PORT) || 3000

const app = express();

app.use(morgan('common'))

app.get('/fortune', (req, resp) => {
	const count = parseInt(req.query.count) || 1
	const result = []
	for (let i = 0; i < count; i++)
		result.push(fortune.fortune())
	resp.status(200).contentType('application/json').json(result)
})

app.use((req, resp) => {
	resp.status(404).contentType('application/json').json({message: `Not found ${req.path}` })
})

app.listen(PORT, () => {
	console.info(`Application listening on port ${PORT} at ${new Date()}`)
})

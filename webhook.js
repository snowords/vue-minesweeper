const http = require('http');
const { spawn } = require('child_process');
const url = require('url');

const server = http.createServer((req, res) => {
  const { pathname } = url.parse(req.url);

  if (req.method === 'POST' && pathname === '/webhook') {
    let body = '';
    req.on('data', (data) => {
      body += data;
    });
    req.on('end', () => {
      const payload = JSON.parse(body);

      if (payload.ref === 'refs/heads/main') {
        console.log('Received a push event to the main branch');
        deploy();
      }
    });
  }

  res.statusCode = 200;
  res.end();
});

function deploy() {
  const deployProcess = spawn('sh', ['deploy.sh']);

  deployProcess.stdout.on('data', (data) => {
    console.log(data.toString());
  });

  deployProcess.stderr.on('data', (data) => {
    console.error(data.toString());
  });

  deployProcess.on('close', (code) => {
    console.log(`Deployment process exited with code ${code}`);
  });
}

const port = 3000;
server.listen(port, () => {
  console.log(`Webhook server listening on port ${port}`);
});

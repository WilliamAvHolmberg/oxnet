module.exports = require('./src/account');
var net = require('net');

const account = require('runescape-account-creator');
const two_captcha_api_key = 'e31776b8685b07026204462c8919564e';
/*
account.create(two_captcha_api_key).then(response => {
    console.log(response)
}).catch(error => {
    console.log(error)
});*/




// creating a custom socket client and connecting it....

var client = new net.Socket();
client.connect(43594, 'oxnetservser.ddns.net', function() {
    console.log('Connected');
    client.write('Hello, server! Love, Client.');
});

client.on('data', function(data) {
    console.log('Received: ' + data);
    client.destroy(); // kill client after server's response
});

client.on('close', function() {
    console.log('Connection closed');
});
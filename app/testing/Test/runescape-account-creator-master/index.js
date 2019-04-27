module.exports = require('./src/account');
var net = require('net');

const account = require('./src/account');

const two_captcha_api_key = 'e31776b8685b07026204462c8919564e';

account.create(two_captcha_api_key, "wowiloloi2amom@gmail.com", "ugot00wned2", "50.239.137.55","20000", "william50", "william50").then(response => {
    console.log(response)
}).catch(error => {
    console.log(error)
});





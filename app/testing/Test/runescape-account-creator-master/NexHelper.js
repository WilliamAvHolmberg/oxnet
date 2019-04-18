// creating a custom socket client and connecting it....
var net = require('net');
var publicIp = require('public-ip');
const account = require('./src/account');
const two_captcha_api_key = 'e31776b8685b07026204462c8919564e';


var external_ip = "";
publicIp.v4().then(ip => {
    console.log("your public ip address", ip);
    external_ip = ip;

});

setTimeout(startProgram,3000);


var queue = [];
queue.push("create_account:FrePine:FrePine@smart-mail.info:ugot00wned2:50.239.137.52:20000:william50:william50");
//queue.push("create_account:SteeSnaR:SteeSnaR@hotelnextmail.com:ugot00wned2:92.32.68.149:8888:::");
/*Queue has an instruction:create_account:AbyHooBr:AbyHooBr@direct-mail.info:ugot00wned2:92.32.68.149:8888:::425:NEX:http://oxnetserver.ddns.net:3000/accounts/30442/json
lets create account
Queue has an instruction:create_account:FrePine:FrePine@smart-mail.info:ugot00wned2:50.239.137.52:20000:william50:william50:398:NEX:http://oxnetserver.ddns.net:3000/accounts/30443/json
lets create account
Queue has an instruction:create_account:ThrPotaBl:ThrPotaBl@direct-mail.info:ugot00wned2:50.239.137.55:20000:william50:william50:431:NEX:http://oxnetserver.ddns.net:3000/accounts/30445/json
*/
function startProgram(){
    var client = new net.Socket();
    client.connect(43594, 'oxnetserver.ddns.net', function() {
        console.log('Connected with ip:'+external_ip);
        var computer = "Testcomputer"
        var message = "computer:1:"+external_ip+":"+computer+"\n";
        client.write(message);
        setInterval(write,3000);


    });

    client.on('data', function(data) {
        if(data.includes("connected")){
            console.log('We have connected to nexus');
            setInterval(write,3000);
        }
        if(data.includes("create_account")){
            console.log("lets create account")
            queue.push(data);
        }

    });

    function write(){
        if (queue.length < 1){
            client.write("log:0\n");
        }else{
            console.log("Queue has an instruction:" + queue[0]);
            var instruction = queue[0];
            queue.shift();
            if(isString(instruction)) {
                var splitted_instruction = instruction.split(":");
                console.log(splitted_instruction[0]);
                if (splitted_instruction[0].includes("create")) {
                    createAccount(splitted_instruction);
                }else if(splitted_instruction[0].includes("unlocked")){
                    console.log("UNLOCKED ACCOUNT!!");
                    client.write(instruction);
                }
            }
            client.write("log:0\n");
        }
    }

    function createAccount(splitted_instruction) {
        console.log("lets create account")
        var email = splitted_instruction[2];
        var password = splitted_instruction[3];
        var proxy_ip = splitted_instruction[4];
        var proxy_port = splitted_instruction[5];
        var proxy_user = splitted_instruction[6];
        var proxy_pass = splitted_instruction[7];

        if (proxy_user.length < 3) {
            account.create(two_captcha_api_key, email, password, proxy_ip, proxy_port).then(response => {
                console.log(response)
                if (response.includes("CREATED")) {
                    console.log("ACCOUNT CREATED");
                    queue.push("unlocked_account:" + email + ":" + password + "\n");
                }
            }).catch(error => {
                console.log(error)
            });
        } else {
            account.create(two_captcha_api_key, email, password, proxy_ip,proxy_port, proxy_user, proxy_pass).then(response => {
                console.log(response)
                if (response.includes("CREATED")) {
                    console.log("ACCOUNT CREATED");
                    queue.push("unlocked_account:" + email + ":" + password + "\n");
                }
            }).catch(error => {
                console.log(error)
            });
        }
    }

    client.on('close', function() {
        console.log('Connection closed');
    });
}



function isString (value) {
    return typeof value === 'string' || value instanceof String;
}
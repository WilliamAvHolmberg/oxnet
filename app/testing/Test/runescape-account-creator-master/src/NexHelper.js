// creating a custom socket client and connecting it....
var net = require('net');
var publicIp = require('public-ip');
const account = require('./account');
const two_captcha_api_key = 'e31776b8685b07026204462c8919564e';


var external_ip = "";
getIp();

setTimeout(startProgram,3000);


var queue = [];
var ready_to_create = true;

function getIp(){
    publicIp.v4().then(ip => {
        console.log("your public ip address", ip);
        external_ip = ip;
    });


}



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
            var respond = "log:0\n";
            var instruction = queue.shift().toString();

            var splitted_instruction = instruction.split(":");
            console.log(splitted_instruction[0]);
            if (splitted_instruction[0].includes("create")) {

                if (!ready_to_create) {
                    queue.push(instruction);
                    console.log("not ready to create account");
                } else {
                    ready_to_create = false;
                    console.log("LETS CREATE");
                    createAccount(splitted_instruction);
                }

            }else if(splitted_instruction[0].includes("unlocked")){

                console.log("UNLOCKED ACCOUNT!!");
                respond = instruction;
            }else if(splitted_instruction[0].includes("ip_cooldown")){

                console.log("IP Cooldown!!");
                respond = instruction;
            }

                client.write(respond);
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

        account.create(two_captcha_api_key, email, password, proxy_ip,proxy_port, proxy_user, proxy_pass).then(response => {
            console.log(response)
            if (response !== null && response.length > 0 && response.includes("CREATED")) {
                console.log("ACCOUNT CREATED");
                queue.push("unlocked_account:" + email + ":" + password + ":\n");

            }else{
                queue.push("ip_cooldown:" + proxy_ip + ":" + 600 + ":\n");
            }
            ready_to_create = true;
            console.log("SET TO TRUE");
        }).catch(error => {
            console.log(error);
            ready_to_create = true;
            console.log("SET TO TRUE");
        });

    }

    client.on('close', function() {
        console.log('Connection closed');
    });
}



function isString (value) {
    return typeof value === 'string' || value instanceof String;
}
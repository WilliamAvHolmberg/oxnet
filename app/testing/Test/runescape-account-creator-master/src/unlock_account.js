const unirest = require('unirest');
const crypto = require('crypto');

var login = "MonBurDr@cyber-host.net";
var API_URL = "https://privatix-temp-mail-v1.p.rapidapi.com";
try {
    console.log(getInbox(login));
}catch{

}




function get_emails(login){
    var md5 = crypto.createHash('md5').update(login.toLowerCase()).digest("hex");
    const return_emails = [];
    unirest.get("https://privatix-temp-mail-v1.p.rapidapi.com/request/mail/id/" + md5 + "/")
        .header("X-RapidAPI-Host", "privatix-temp-mail-v1.p.rapidapi.com")
        .header("X-RapidAPI-Key", "4c0e429fd6mshf2cbfeb2892c652p1f83bfjsn5f63eb9b0431")
        .end(function (result) {
            for(var k in result.body){
                console.log(k["mail_subject"]);
            }
        });

}

/**
 * Makes GET request
 * @param {string} url
 * @returns {Promise}
 */
function get(url) {
    return new Promise((resolve, reject) => {
        https
            .get(url, (res) => {
                if (res.statusCode < 200 || res.statusCode > 299) {
                    reject(new Error(`Request failed: ${res.statusCode}`));
                }

                let data = '';

                res
                    .on('data', (chunk) => { data += chunk; })
                    .on('end', () => resolve(data));
            })
            .on('error', reject);
    });
}

/**
 * Generates MD5 hash from email
 * @param {string} email
 * @returns {string}
 */
function getEmailHash(email) {
    return crypto.createHash('md5').update(email).digest('hex');
}


function getInbox(email) {
    if (!email) {
        throw new Error('Please specify email');
    }

    return get(`${API_URL}/request/mail/id/${getEmailHash(email)}/format/json/`).then(JSON.parse);
}
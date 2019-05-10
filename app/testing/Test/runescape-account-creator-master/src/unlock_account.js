const unirest = require('unirest');
const crypto = require('crypto');

var login = "BrooStrB@webgmail.info";
get_emails(login);
function get_emails(login){
    var md5 = crypto.createHash('md5').update(login.toLowerCase()).digest("hex");
    const return_emails = [];
    unirest.get("https://privatix-temp-mail-v1.p.rapidapi.com/request/mail/id/" + md5 + "/")
        .header("X-RapidAPI-Host", "privatix-temp-mail-v1.p.rapidapi.com")
        .header("X-RapidAPI-Key", "4c0e429fd6mshf2cbfeb2892c652p1f83bfjsn5f63eb9b0431")
        .end(function (result) {
           return result.body
        });

}

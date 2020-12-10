const app = require('./app');

let port = process.env.PORT || 4000;

async function main(){
    app.listen(port);
}


main();
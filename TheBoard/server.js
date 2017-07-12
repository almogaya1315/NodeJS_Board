//var http = require('http');
//var port = process.env.port || 1337;
//http.createServer(function (req, res) {
//    res.writeHead(200, { 'Content-Type': 'text/plain' });
//    res.end('xxx\n');
//}).listen(port);

var http = require("http");
var express = require("express");
var app = express();
var ejsEngine = require("ejs-locals");
var controllers = require('./controllers');

//set-up the view engine
//app.set("view engine", "jade");
//app.engine("ejs", ejsEngine); //support master pages 
//app.set("view engine", "ejs"); // ejs view engine
app.set("view engine", "vash");

//map the routes
controllers.init(app);

app.get("/api/users", function (req, res) {
    res.set("Content-Type", "application/json");
    res.send({ name: "Lior", surname: "Matsliah" });
});

var server = http.createServer(app);

//var server = http.createServer(function (req, res) {
//    console.log(req.url);
//    res.write("<html><body><h1>" + req.url + "</h1></body></html>");
//    res.end();
//});

server.listen(1337);
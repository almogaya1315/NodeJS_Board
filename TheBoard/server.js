﻿//var http = require('http');
//var port = process.env.port || 1337;
//http.createServer(function (req, res) {
//    res.writeHead(200, { 'Content-Type': 'text/plain' });
//    res.end('xxx\n');
//}).listen(port);

var http = require("http");
var express = require("express");
var app = express();

app.get("/", function (req, res) {
    res.send("<html><body><h1>Express</h1></body></html>");
});

var server = http.createServer(app);

//var server = http.createServer(function (req, res) {
//    console.log(req.url);
//    res.write("<html><body><h1>" + req.url + "</h1></body></html>");
//    res.end();
//});

server.listen(1337);
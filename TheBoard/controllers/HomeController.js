﻿(function (homeController) {
    var data = require("../data")

    homeController.init = function (app) {

        app.get("/", function (req, res) {
            //res.send("<html><body><h1>Express</h1></body></html>");
            //res.render("jade/index", { title: "Express + Jade" });
            //res.render("ejs/index", { title: "Express + EJS" });

            data.getNotesCategories(function (err, results) {
                res.render("vash/index", { title: "Express + Vash", error: err, categories: results });
            });

            
        });

    };
})(module.exports);
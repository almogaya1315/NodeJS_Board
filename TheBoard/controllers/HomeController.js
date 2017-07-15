(function (homeController) {
    var data = require("../data")

    homeController.init = function (app) {

        app.get("/", function (req, res) {
            //res.send("<html><body><h1>Express</h1></body></html>");
            //res.render("jade/index", { title: "Express + Jade" });
            //res.render("ejs/index", { title: "Express + EJS" });

            data.getNotesCategories(function (err, results) {
                res.render("vash/index", { title: "The Board", error: err, categories: results });
            });
        });

        app.get("/api/users", function (req, res) {
            res.set("Content-Type", "application/json");
            res.send({ name: "Lior", surname: "Matsliah" });
        });
    };
})(module.exports);
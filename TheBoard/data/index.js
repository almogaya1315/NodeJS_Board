(function (data) {
    var seedData = require("./seedData");

    data.getNotesCategories = function (next) {
        next(null, seedData.initialNotes);
    }
})(module.exports);


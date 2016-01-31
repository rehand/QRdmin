var express = require('express');
var bodyParser = require('body-parser');

var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database(':memory:');

var app = express();
app.use(bodyParser.json({limit: '20mb'}));
app.use(bodyParser.urlencoded({limit: '20mb', extended: true}));

app.put('/device/:id', function (request, response) {
    db.serialize(function () {
        var stmt = db.prepare("INSERT INTO devices VALUES (?,?)");
        stmt.run([request.params.id, JSON.stringify(request.body)]);
        stmt.finalize();

        db.each("SELECT id, value FROM devices", function (err, row) {
            console.log(row.id + ": " + row.value);
        });

        response.status(200);
        response.send();
    });
});

app.get('/device/:id', function (request, response) {
    db.get("SELECT value FROM devices where id = '" + request.params.id + "'", function (err, row) {
        if (row) {
            response.send(row.value);
        } else {
            response.status(404);
            response.send();
        }
    });
});

app.listen(3333, function () {
    db.run("CREATE TABLE devices (id TEXT, value TEXT)");
});

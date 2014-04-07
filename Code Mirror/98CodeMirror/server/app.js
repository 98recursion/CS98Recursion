



var express = require('express');
var app = express();
var routes = require('./routes');

var hbs = require('hbs');

var blogEngine = require('./blog');

app.set('view engine', 'html');
app.engine('html', hbs.__express);
app.use(express.bodyParser());

//This is for the style sheet which I dont need right now...
//app.use(express.static('public'));

app.get('/', routes.index);

app.get('/towers', routes.towers);

app.get('/about', routes.about);

app.get('/article/:id', routes.articles);

app.get('/debugger', routes.debug);

app.listen(3000);
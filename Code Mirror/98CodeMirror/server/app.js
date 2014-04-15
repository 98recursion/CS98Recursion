



var express = require('express');
var app = express();
var routes = require('./routes');

var hbs = require('hbs');

//var ejs = require( 'ejs')

var blogEngine = require('./blog');

app.set('view engine', 'html');
app.engine('html', hbs.__express);
app.use(express.bodyParser());




//Get rid of layout
app.set('view options', { layout: false });

//app.use(express.static(__dirname + '../TowersofHanoi'));
app.use(express.static(__dirname ));


//This is for the style sheet which I dont need right now...
//app.use(express.static('public'));

app.get('/', routes.index);

app.get('/towers', routes.towers);

app.get('/queens', routes.queens);

app.get('/code', routes.codeM);

app.get('/theme', routes.theme);


//app.get('../../TowersofHanoi/doc/docs.css', routes.test);

app.get('/about', routes.about);
app.get('/article/:id', routes.articles);

app.listen(3000);
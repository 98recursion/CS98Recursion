

/*
 * GET home page.
 */

var blogEngine = require('../blog');
var path = require('path');
var fs = require('fs');

exports.index = function(req, res) {
	res.render('index',{title:"My Blog", entries:blogEngine.getBlogEntries()});
};

exports.about = function( req, res ){
	res.render('about', {title:"About Me"});
};

exports.articles = function(req, res) {
	var entry = blogEngine.getBlogEntry(req.params.id);
	res.render('article',{title:entry.title, blog:entry});
};

exports.towers = function( req, res ){
	res.render('../views/TowersTest.html', {title:"Towers of Hanoi"});
	
	//fs.readFile('../../TowersofHanoi/demo/TOH-Connected.html');
};

exports.queens = function( req, res ){
	res.render('../TowersofHanoi/demo/nQueens-Connected.html', {title:"nQueens"});
};

exports.codeM = function( req, res ){
	res.render('../TowersofHanoi/demo/fullscreen.html', {title:"codeMirror"});
};

exports.theme = function( req, res ){
	res.render('../views/theme1.html', {title:"THEME"});
}




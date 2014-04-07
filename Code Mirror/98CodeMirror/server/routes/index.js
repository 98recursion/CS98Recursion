

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

exports.debug = function(req, res){
	//Because this is still a hack, hard code the name
	var requestedFile = 'sample.js';
	var fileBaseDir = path.join( __dirname, '../tempCode');
	var filesDir = path.normalize(fileBaseDir);
	var fullRequestedFilePath = path.join(filesDir, requestedFile);
	
	/* File must exist and must be located inside the filesDir */
	if (fs.existsSync(fullRequestedFilePath) && fullRequestedFilePath.indexOf(filesDir) === 0) {
		ok200({
			data: fs.readFileSync(fullRequestedFilePath).toString(),
			  breakpoints: require('../rewriter/multirewriter.js').getRewrittenContent(requestedFile).breakpoints || []
		});
	}
	
	function ok200(data) {
		//res.set('content-type', 'application/json' );
		res.writeHead(200, { 'Content-Type': 'application/json' });
		res.end(JSON.stringify(data || {}));
	}
	
};


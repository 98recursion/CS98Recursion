'use strict';

var path = require('path');
var fs = require('fs');

// var config = require('../config/config.defaults.js');
// 
// function isRewritable(filePath) {
//     var fileServerBaseDir = path.normalize(config.fileServerBaseDir);
//     var fullRequestedFilePath = path.join(fileServerBaseDir, filePath);
//     
//     /* File must exist and must be located inside the fileServerBaseDir */
//     if (fs.existsSync(fullRequestedFilePath) &&
//         fs.statSync(fullRequestedFilePath).isFile() &&
//         fullRequestedFilePath.indexOf(fileServerBaseDir) === 0)
//     {
//         if (filePath.substr(-3) == '.js' || filePath.substr(-7) == '.coffee') {
//             return true;
//         }
//         
//         return false;
//     }
// }

function getRewrittenContent(filePath) {
	
	//Get the location of the files.
	//This is temporary and will eventually be switched to the entire text coming from online.
	var fileBaseDir = path.join( __dirname, '../tempCode');
    var fileServerBaseDir = path.normalize(fileBaseDir);
    var fullRequestedFilePath = path.join(fileServerBaseDir, filePath);
    
    //Use a different rewriter for different languages.  This is something I will get rid of with time because the tool is going to be javascript only.
	var rewriter;
    if (filePath.substr(-3) == '.js') {
        rewriter = require('../rewriter/jsrewriter.js');
    }
    else if (filePath.substr(-7) == '.coffee') {
        rewriter = require('../rewriter/coffeerewriter.js');
    }
    
    if (rewriter) {
        var content = fs.readFileSync(fullRequestedFilePath).toString();
        return rewriter.addDebugStatements(filePath, content);
    }

}

module.exports = {
    getRewrittenContent: getRewrittenContent,
    //isRewritable: isRewritable
};


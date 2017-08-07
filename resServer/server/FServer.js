 // FServer.js    
var fs   = require('fs');    
var mime = require('../common/mime').mime;    
function filesLoad(filePath, type, req, res){
	console.log('filesLoad:', filePath, type)
	fs.exists(filePath, function(exists){    
		if ( !exists ) {    
			res.writeHead(404, {'Content-Type': 'text/plain'});    
			// res.write();    
			res.end();    
		} else {    
			fs.readFile(filePath, 'binary', function(err, file){    
				if ( err ) {    
					res.writeHead(500, {'Content-Type': 'text/plain'});    
					// res.write();    
					res.end();    
				} else {
					res.writeHead(200, {'Content-Type': mime[type]});    
					res.write(file, 'binary');    
					res.end();    
				}    
			});    
		}    
	})    
}    
exports.filesLoad = filesLoad;  
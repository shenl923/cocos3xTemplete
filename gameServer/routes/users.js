var express = require('express');
var router = express.Router();

var bodyParser = require('body-parser');
var urlEncodeParser = bodyParser.urlencoded({extended: false});

import {MysqlQuery} from '../mysql';


/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});

router.post('/login', function (req, res) {
  console.log(req.body);
  MysqlQuery('select * from user where id=2',(rows, fields) => {
    res.send(JSON.stringify(rows));
  });
});


module.exports = router;

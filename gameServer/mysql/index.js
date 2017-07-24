var mysql      = require('mysql');
var pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password : '',
  database : 'login',
});


export function MysqlQuery(sql, callback) {
  pool.getConnection(function(err, connection) {
    if (err) throw err;

    connection.query(sql, (error, results, fields) => {
      connection.release();
      if (callback){
        callback(results, fields);
      }

      if (error) throw error;
    })
  })
}


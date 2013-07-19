var config = require('../config'),
context = config.server.context,
logger = config.logger,
memoryDB = require('./memory_db');

module.exports = function(server) {

	var io = require('socket.io').listen(server, {
		resource: context + '/socket.io'
	});

	io.set('transports', [
			'websocket'
		// , 'flashsocket'
		, 'jsonp-polling'
		// , 'htmlfile'
		// , 'xhr-polling'
	]);
	io.enable('browser client minification'); // send minified client
	io.enable('browser client etag'); // apply etag caching logic based on version number
	io.enable('browser client gzip'); // gzip the file
	io.set('log level', 1); // reduce logging



	io.of(context).on('connection', function(socket) {
		console.info("conection:" + socket.id);
		var sid = socket.id;


		socket.on('talk', function(data) {
			console.log(data);
			data['sendDate'] = new Date();
			console.log(data);
			var from = data.from;
			var to = data.to;
			var msgType = data.msgType;
			var sendType = data.sendType;

			// 单点发送
			if(!sendType || sendType != 'group'){
				io.of(context).emit('talk-' + data.to, data);
			}else{
				// 群组消息遍历发送
				memoryDB.groupUser[to].forEach(function(user){
					console.info(user);
					io.of(context).emit('talk-' + user, data);
				});
			}

		});


		//断开连接
		socket.on('disconnect', function(data) {
			console.info("data---------->" + data);
			console.info('id=====>>' + socket.id);
			console.info('user disconnected!' + socket.id);
		});
	});

	return io;

};
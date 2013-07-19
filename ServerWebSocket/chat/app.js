var io = require('socket.io').listen(8127);

io.sockets.on('connection', function (socket) {
	
	console.info('connection:' + socket);
	
  socket.emit('talk-client',{text:'connectok'});	
	
  socket.on('message', function (data) {
  	console.info('data:' + data);
    if(data=='你好'){
    		socket.emit('NIHAO',{text:'景先生您好!有什么可以帮到你?'});
    }
    else if(data=='现在几点')
    {
        socket.emit('JIDIAN',{text:'现在是2013年7月18日上午11:00'});
    }
    else if(data=='谢谢')
    {
        socket.emit('THANKS',{text:'不客气'});
    }
    else{
        socket.emit('OTHER',{text:'不客气'});	
    }
  });
});
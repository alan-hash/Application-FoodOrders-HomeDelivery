module.exports = (io) => {
    const namespace = io.of('/orders/delivery');
    namespace.on('connection', (socket) => {

        console.log('USUARIO SE CONECTO A SOCKET IO: /orders/delivery');

        socket.on('position', (data) => {

            console.log('CLIENTE EMITIO: ', data);
            namespace.emit(`position/${data.id_order}`, { id_order: data.id_order, lat: data.lat, lng: data.lng  });

        });
       
        socket.on('delivered', (data) => {

            console.log('DELIVERY EMITIO: ', data);
            namespace.emit(`delivered/${data.id_order}`, { id_order: data.id_order });

        });

        socket.on('disconnect', (data) => {
            console.log('UN USUARIO SE DESCONECTO DE SOCKET IO');
        });

    });
}

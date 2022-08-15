const productsController = require('../controllers/productsController');
const passport = require('passport');

module.exports = (app, upload) => {

    // GET -> OBTENER DATOS
    // POST -> ALMACENAR DATOS
    // PUT -> ACTUALIZAR DATOS
    // DELETE -> ELIMINAR DATOS


    app.get('/api/products/findByCategory/:id_category',  passport.authenticate('jwt', { session: false }), productsController.findByCategory);
    app.get('/api/products/findByNameAndCategory/:id_category/:name',  passport.authenticate('jwt', { session: false }), productsController.findByNameAndCategory);
    app.post('/api/products/create',  passport.authenticate('jwt', { session: false }), upload.array('image', 3), productsController.create);
    


}
const addressController = require('../controllers/addressController');
const passport= require('passport');

module.exports = (app) => {

    app.post('/api/address/create',passport.authenticate('jwt',{session:false}) , addressController.create);
    app.get('/api/address/findByUser/:id_user',  passport.authenticate('jwt', { session: false }), addressController.findByUser);
   
}
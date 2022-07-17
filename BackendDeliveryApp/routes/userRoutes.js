const usersController = require('../controllers/usersController');

module.exports = (app,upload) => {

    app.post('/api/users/create', usersController.register);
    app.post('/api/users/createWithImage', upload.array('image', 1), usersController.registerWithImage);
    app.post('/api/users/login', usersController.login);

    app.put('/api/users/update',upload.array('image', 1),usersController.updateWithImage);
    app.put('/api/users/updateWithoutImage',usersController.updateWithoutImage);

    

}
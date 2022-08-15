const mercadopago = require('mercadopago');
const Order = require('../models/order');
const OrderHasProducts = require('../models/order_has_products');

mercadopago.configure({
    sandbox: true,
    access_token: 'TEST-37026682270517-080718-eead0b0a531679922455e1e60eb500bb-140200290'
});

module.exports = {

    async createPayment(req, res) {
        
        

        let payment = req.body;

        console.log('PAYMENT: ', payment);

        const payment_data = {
          token: payment.token,
          issuer_id: payment.issuer_id,
          payment_method_id: payment.payment_method_id,
          transaction_amount: payment.transaction_amount,
          installments: payment.installments,
          payer: {
            email: payment.payer.email,
            identification: {
              type: payment.payer.identification.type,
              number: payment.payer.identification.number
            },
          },
        }
        

        const data = await mercadopago.payment.create(payment_data).catch((err) => {
            console.log('Error de mercado pago', err);
            return res.status(501).json({
                success: false,
                message: 'Error al crear el pago',
                error: err
            });
        });
        
        if (data.body !== null && data.body !== undefined) {
            const order = payment.order;

            Order.create(order, async (err, id) => {

                if (err) {
                    return res.status(501).json({
                        success: false,
                        message: 'Hubo un error al momento de crear la orden',
                        error: err
                    });
                }
    
                for (const product of order.products) {
                    await OrderHasProducts.create(id, product.id, product.quantity, (err, id_data) => {
                        if (err) {
                            return res.status(501).json({
                                success: false,
                                message: 'Hubo un error con la creacion de los productos en la orden',
                                error: err
                            });
                        }
                    });
                }
    
                return res.status(201).json({
                    success: true,
                    message: 'La orden se ha creado correctamente',
                    data: data.response
                });
    
            });
        }
        

    }

}
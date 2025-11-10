import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WalletPaymentPage extends StatefulWidget {
  final double amountToRecharge;

  const WalletPaymentPage({super.key, required this.amountToRecharge});

  @override
  State<WalletPaymentPage> createState() => _WalletPaymentPageState();
}

class _WalletPaymentPageState extends State<WalletPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String address = '';
  String paymentMethod = 'Efectivo';
  bool isQREnabled = false;
  String qrImageUrl = '';
  double totalOrder = 100.0;

  void _generateQRCode(double amount) async {
    String urlQr = 'https://pagosonlineqr.com/admin20/api/api.php';

    String idQr = '81';

    var expirationDate =
        DateTime.now().add(const Duration(days: 20)).toIso8601String();

    var response = await http.get(
      Uri.parse(
          '$urlQr?get_image_qr&currency=BOB&gloss=Punto de venta&amount=$amount&expirationDate=$expirationDate'),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == 0) {
        log(data['message']);
        setState(() {
          qrImageUrl = "data:image/jpeg;base64,${data['message']}";
          isQREnabled = true;
        });
      } else {
        // Manejar error
        log('Error: ${data['message']}');
      }
    } else {
      // Manejar error de red
      log('Error de red');
    }
  }

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (paymentMethod == 'Pagos con QR') {
        _generateQRCode(widget.amountToRecharge);
      } else {
        // Procesar orden con otro método de pago
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 10,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nombres'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor ingrese sus nombres';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      firstName = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Apellidos'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor ingrese sus apellidos';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      lastName = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Correo'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor ingrese su correo';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Telefono'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor ingrese su teléfono';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phone = value!;
                    },
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Dirección de envío'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor ingrese su dirección';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      address = value!;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: paymentMethod,
                    decoration:
                        const InputDecoration(labelText: 'Método de Pago'),
                    items: <String>['Efectivo', 'Pagos con QR']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        paymentMethod = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitOrder,
                    child: const Text('Ordenar'),
                  ),
                  const SizedBox(height: 20),
                  if (isQREnabled)
                    Column(
                      children: [
                        Image.memory(
                          base64Decode(qrImageUrl.split(',').last),
                          fit: BoxFit.cover,
                        ),
                        Text('Monto: $totalOrder Bs'),
                        const Text('Estado: Pendiente'),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

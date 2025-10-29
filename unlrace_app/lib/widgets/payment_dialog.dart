import 'package:flutter/material.dart';
import 'package:unl_race/global/global_var.dart';

import 'package:unl_race/methods/common_methods.dart';

class PaymentDialog extends StatefulWidget {
  final String fareAmount;
  final int selectedPaymentOption;
  const PaymentDialog({
    super.key,
    required this.fareAmount,
    required this.selectedPaymentOption,
  });

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  CommonMethods cMethods = CommonMethods();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.white,
      child: Container(
        margin: const EdgeInsets.all(5),
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 21),
            Text(
              widget.selectedPaymentOption == 0 ? 'PAGAR' : 'MONTO A DEBITAR',
              style: const TextStyle(
                fontFamily: "QuicksandSemiBold",
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 21),
            Text(
              "${widget.fareAmount} \$",
              style: const TextStyle(
                fontFamily: "QuicksandBold",
                color: Colors.green,
                fontSize: 36,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.selectedPaymentOption == 0
                    ? "Este es el monto a pagar ( \$ ${widget.fareAmount} ) al conductor"
                    : "Este es el monto que se debitará ( \$ ${widget.fareAmount} ) de su cuenta.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "QuicksandRegular",
                ),
              ),
            ),
            const SizedBox(height: 31),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, "paid");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text(
                widget.selectedPaymentOption == 0
                    ? "PAGAR Y FINALIZAR"
                    : "ACEPTAR",
                style: const TextStyle(
                  fontFamily: "QuicksandBold",
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 41),
          ],
        ),
      ),
    );
  }
}

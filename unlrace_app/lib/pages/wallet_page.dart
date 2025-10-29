import 'package:flutter/material.dart';
import 'package:unl_race/global/global_var.dart';
import 'package:unl_race/pages/wallet_history_page.dart';
import 'package:unl_race/pages/wallet_payment_page.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  TextEditingController amountTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double radius = MediaQuery.of(context).size.height * 0.4;
    double top = radius + 50;
    double left = radius - 50;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Stack(
                  children: [
                    Positioned(
                      top: -top,
                      left: -left,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor:
                            const Color.fromARGB(235, 134, 226, 137),
                        radius: radius,
                      ),
                    ),
                    Positioned(
                      top: -top + 30,
                      child: CircleAvatar(
                        backgroundColor:
                            const Color.fromARGB(235, 143, 239, 146),
                        radius: radius,
                      ),
                    ),
                    Center(
                      child: Text(
                        "Mi Wallet:  ${userWallet.toStringAsFixed(2)} Bs",
                        style: const TextStyle(
                            fontFamily: "QuicksandBold",
                            fontSize: 30,
                            color: Colors.white),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.6,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  showDragHandle: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DraggableScrollableSheet(
                                      initialChildSize: 1,
                                      minChildSize: 0.3,
                                      maxChildSize: 1,
                                      builder: (BuildContext context,
                                          ScrollController scrollController) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40),
                                          child: ListView(
                                            controller: scrollController,
                                            children: [
                                              const Center(
                                                child: Text(
                                                  "Ingrese el monto en dólares que desea recargar en su wallet.",
                                                  style: TextStyle(
                                                    fontFamily: "QuicksandBold",
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              const Center(
                                                child: Text(
                                                  "Monto a recargar",
                                                  style: TextStyle(
                                                    fontFamily: "QuicksandBold",
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 60),
                                                  child: TextField(
                                                    controller:
                                                        amountTextEditingController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          "QuicksandBold",
                                                      fontSize: 20,
                                                      color: Colors.green,
                                                    ),
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: "Bs0",
                                                      hintStyle: TextStyle(
                                                        fontFamily:
                                                            "QuicksandBold",
                                                        fontSize: 20,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 40),
                                                child: FilledButton(
                                                  onPressed:
                                                      amountTextEditingController
                                                                  .text !=
                                                              ""
                                                          ? double.parse(
                                                                      amountTextEditingController
                                                                          .text) >
                                                                  0
                                                              ? () {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (
                                                                        context,
                                                                      ) =>
                                                                          WalletPaymentPage(
                                                                        amountToRecharge:
                                                                            double.parse(
                                                                          amountTextEditingController
                                                                              .text,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                              : null
                                                          : null,
                                                  child: const Text(
                                                    "Continuar",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          "QuicksandBold",
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color?>(
                                        Colors.black),
                                textStyle:
                                    MaterialStateProperty.all<TextStyle?>(
                                  const TextStyle(
                                    fontFamily: "QuicksandBold,",
                                    color: Colors.black,
                                  ),
                                ),
                                shadowColor: MaterialStateProperty.all<Color?>(
                                    Colors.grey),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 230, 230, 230),
                                ),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                side: MaterialStateProperty.all<BorderSide>(
                                  const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.mobile_friendly,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "QR Pago",
                                    style: TextStyle(
                                      fontFamily: "QuicksandBold,",
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const WalletHistoryPage(),
                                ));
                          },
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color?>(Colors.white),
                            textStyle: MaterialStateProperty.all<TextStyle?>(
                              const TextStyle(
                                fontFamily: "QuicksandBold,",
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 233, 105, 148)),
                          ),
                          child: const Text(
                            "Historial",
                            style: TextStyle(fontFamily: "QuicksandMedium"),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Recargar _Wallet",
                            style: TextStyle(
                                fontFamily: "QuicksandBold",
                                fontSize: 65,
                                color: Color.fromARGB(255, 143, 143, 143)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

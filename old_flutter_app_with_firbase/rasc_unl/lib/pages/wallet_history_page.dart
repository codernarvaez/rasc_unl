import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class WalletHistoryPage extends StatefulWidget {
  const WalletHistoryPage({super.key});

  @override
  State<WalletHistoryPage> createState() => _WalletHistoryPageState();
}

class _WalletHistoryPageState extends State<WalletHistoryPage> {
  final walletPaymentHistoryOfCurrentUser =
      FirebaseDatabase.instance.ref().child("unl_raceWallet");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Historial de recarga de wallet",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "QuicksandBold",
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: walletPaymentHistoryOfCurrentUser.onValue,
        builder: (context, snapshotData) {
          if (snapshotData.hasError) {
            return const Center(
              child: Text(
                "Ha ocurrido un error.",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }

          if (!(snapshotData.hasData)) {
            return const Center(
              child: Text(
                "No hay datos todavía.",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            );
          }

          if ((!snapshotData.data!.snapshot.exists)) {
            return const Center(
              child: Text(
                "No hay datos todavía.",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            );
          }

          Map dataWalletPayments = snapshotData.data!.snapshot.value as Map;

          List<Map> walletHistoryList = [];

          dataWalletPayments.forEach(
              (key, value) => walletHistoryList.add({"key": key, ...value}));

          return ListView.builder(
            shrinkWrap: true,
            itemCount: walletHistoryList.length,
            itemBuilder: (context, index) {
              if (walletHistoryList[index]["userID"] ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyCustomCard(data: walletHistoryList[index]);
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }
}

class MyCustomCard extends StatelessWidget {
  final Map data;

  const MyCustomCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    const fontBold = TextStyle(fontFamily: 'QuicksandBold', fontSize: 18);
    const fontLight = TextStyle(fontFamily: 'QuicksandRegular', fontSize: 15);
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.23,
      child: Card(
        color: data["status"] == "ok"
            ? const Color.fromARGB(255, 226, 246, 227)
            : data["status"] == "fail"
                ? const Color.fromARGB(255, 250, 227, 229)
                : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(children: [
            Row(
              children: [
                Text(
                  "${data["paymentMethod"].toString().substring(0, 1).toUpperCase()}${data["paymentMethod"].toString().substring(1)}",
                  style: fontBold,
                ),
                const SizedBox(
                  width: 40,
                  child: Text(
                    " _Ref.",
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  data["lastDigits"],
                  style: fontBold,
                ),
              ],
            ),
            Positioned(
              left: 20,
              top: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${data["bankName"]}",
                    style: fontLight.copyWith(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${data["phone"]} - ${data["datePayment"]}",
                    style: fontLight.copyWith(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${data["amountInBs"]} Bs",
                    style: fontLight,
                  ),
                  Text(
                    "${data["amountToRecharge"]} Bs",
                    style: fontLight,
                  ),
                  Text(
                    'Estatus: ${data["status"]}',
                    style: fontLight,
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}

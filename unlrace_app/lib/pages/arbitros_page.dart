import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:unl_race/pages/edit_arbitro_page.dart';

import 'package:unl_race/pages/new_arbitro_page.dart';

class ArbitrosPage extends StatefulWidget {
  const ArbitrosPage({super.key});

  @override
  State<ArbitrosPage> createState() => _ArbitrosPageState();
}

class _ArbitrosPageState extends State<ArbitrosPage> {
  Query arbitrosList = FirebaseDatabase.instance
      .ref()
      .child("users")
      .orderByChild("role")
      .equalTo("arbitro");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Gestionar Arbitros",
          style: TextStyle(
            fontFamily: "QuicksandMedium",
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const NewArbitroPage();
                    },
                  ),
                );
              },
              icon: const Icon(Icons.add_circle_outline))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: StreamBuilder(
          stream: arbitrosList.onValue,
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

            if ((!snapshotData.hasData)) {
              return const Center(
                child: Text(
                  "No hay datos todavía.",
                  style: TextStyle(
                    color: Colors.white,
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

            Map data = snapshotData.data!.snapshot.value as Map;

            List dataList = [];

            data.forEach((key, value) => dataList.add({"key": key, ...value}));

            return ListView.builder(
              shrinkWrap: true,
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 10,
                  ),
                  child: Card(
                    color: Colors.white,
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.48,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      if (dataList[index]["blockStatus"] ==
                                          "no")
                                        const Icon(
                                          Icons.drag_indicator_rounded,
                                          color: Colors.green,
                                        ),
                                      if (dataList[index]["blockStatus"] ==
                                          "yes")
                                        const Icon(
                                          Icons.drag_indicator_rounded,
                                          color: Colors.red,
                                        ),
                                      Text(
                                        dataList[index]["nombres"],
                                        style: const TextStyle(
                                          fontFamily: "QuicksandBold",
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return EditArbitroPage(
                                          idUser: dataList[index]["key"],
                                          blockStatus: dataList[index]
                                              ["blockStatus"],
                                          nombres: dataList[index]["nombres"],
                                          idCompetition: dataList[index]
                                              ["idCompetition"],
                                          idTeam: dataList[index]["idTeam"],
                                          competition: dataList[index]
                                              ["competition"],
                                          team: dataList[index]["team"],
                                        );
                                      },
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.mode_edit_outline_outlined,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "Asignado a",
                            style: TextStyle(
                              fontFamily: "QuicksandMedium",
                            ),
                          ),
                          Container(
                            color: Colors.grey,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Competencia: ${dataList[index]["competition"]}",
                                    style: const TextStyle(
                                      fontFamily: "QuicksandMedium",
                                    ),
                                  ),
                                  Text(
                                    "Equipo: ${dataList[index]["team"]}",
                                    style: const TextStyle(
                                      fontFamily: "QuicksandMedium",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

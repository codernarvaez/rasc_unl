import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:unl_race/pages/list_members_page.dart';
import 'package:unl_race/pages/new_competition_page.dart';
import 'package:unl_race/pages/new_member_page.dart';
import 'package:unl_race/pages/new_team_page.dart';

class TeamsListPage extends StatefulWidget {
  final String idCompetition;
  final String name;
  const TeamsListPage(
      {super.key, required this.name, required this.idCompetition});

  @override
  State<TeamsListPage> createState() => _TeamsListPageState();
}

class _TeamsListPageState extends State<TeamsListPage> {
  DatabaseReference teamsList = FirebaseDatabase.instance.ref().child("teams");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Listado de equipos - ${widget.name}",
          style: const TextStyle(
            fontFamily: "QuicksandMedium",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: StreamBuilder(
          stream: teamsList
              .orderByChild("idCompetition")
              .equalTo(widget.idCompetition)
              .onValue,
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.48,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        if (dataList[index]["status"] ==
                                            "active")
                                          const Icon(
                                            Icons.drag_indicator_rounded,
                                            color: Colors.green,
                                          ),
                                        if (dataList[index]["status"] ==
                                            "inactive")
                                          const Icon(
                                            Icons.drag_indicator_rounded,
                                            color: Colors.red,
                                          ),
                                        Text(
                                          dataList[index]["name"],
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
                                Text(
                                  dataList[index]["category"],
                                  style: const TextStyle(
                                    fontFamily: "QuicksandBold",
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return NewTeamPage(
                                          idCompetition: dataList[index]
                                              ["idCompetition"],
                                          nameCompetition: '',
                                          isEditing: dataList[index]["key"],
                                          name: dataList[index]["name"],
                                          category: dataList[index]["category"],
                                          status: dataList[index]["status"],
                                          numberOfParticipants: dataList[index]
                                              ["participants"],
                                          teacher: dataList[index]["tutor"],
                                        );
                                      },
                                    ));
                                  },
                                  icon: const Icon(
                                    Icons.mode_edit_outline_outlined,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                                "Número de participantes: ${dataList[index]["participants"]}"),
                          ),
                          const SizedBox(
                            height: 20,
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

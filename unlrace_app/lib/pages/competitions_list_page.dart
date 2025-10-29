import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:unl_race/pages/list_teams_page.dart';
import 'package:unl_race/pages/new_competition_page.dart';
import 'package:unl_race/pages/new_team_page.dart';
import 'package:unl_race/pages/start_race_page.dart';

class CompetitionsListPage extends StatefulWidget {
  const CompetitionsListPage({super.key});

  @override
  State<CompetitionsListPage> createState() => _CompetitionsListPageState();
}

class _CompetitionsListPageState extends State<CompetitionsListPage> {
  DatabaseReference competitionsList =
      FirebaseDatabase.instance.ref().child("competitions");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Listado de competencias",
          style: TextStyle(
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
          stream: competitionsList.onValue,
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
                int countTeams = dataList[index]["countTeams"];

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
                                      if (dataList[index]["status"] == "on")
                                        const Icon(
                                          Icons.drag_indicator_rounded,
                                          color: Colors.green,
                                        ),
                                      if (dataList[index]["status"] == "off")
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
                                dataList[index]["date"],
                                style: const TextStyle(
                                  fontFamily: "QuicksandBold",
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return NewCompetitionPage(
                                        isEditing: dataList[index]["key"],
                                        name: dataList[index]["name"],
                                        date: dataList[index]["date"],
                                        status: dataList[index]["status"],
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
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Equipos registrados: ",
                                style: TextStyle(
                                  fontFamily: "QuicksandMedium",
                                ),
                              ),
                              Text(
                                " $countTeams ",
                                style: const TextStyle(
                                  fontFamily: "QuicksandMedium",
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: dataList[index]["status"] == "on"
                                      ? () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return NewTeamPage(
                                                idCompetition: dataList[index]
                                                    ["key"],
                                                nameCompetition: dataList[index]
                                                    ["name"],
                                              );
                                            },
                                          ));
                                        }
                                      : null,
                                  child: const Text(
                                    "Crear equipos",
                                    style: TextStyle(
                                      fontFamily: "QuicksandMedium",
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return TeamsListPage(
                                          idCompetition: dataList[index]["key"],
                                          name: dataList[index]["name"],
                                        );
                                      },
                                    ));
                                  },
                                  child: const Text(
                                    "Ver equipos",
                                    style: TextStyle(
                                      fontFamily: "QuicksandMedium",
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return Cronometro(
                                          name: dataList[index]["name"],
                                          idKey: dataList[index]["key"],
                                          status: dataList[index]["status"],
                                        );
                                      },
                                    ));
                                  },
                                  child: const Text(
                                    "Iniciar Competencia",
                                    style: TextStyle(
                                      fontFamily: "QuicksandMedium",
                                    ),
                                  ),
                                ),
                              ],
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

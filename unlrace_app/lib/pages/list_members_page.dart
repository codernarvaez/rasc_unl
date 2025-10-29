import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:unl_race/pages/new_member_page.dart';

class MembersListPage extends StatefulWidget {
  final String idTeam;
  final String name;

  const MembersListPage({super.key, required this.name, required this.idTeam});

  @override
  State<MembersListPage> createState() => _MembersListPageState();
}

class _MembersListPageState extends State<MembersListPage> {
  DatabaseReference membersList =
      FirebaseDatabase.instance.ref().child("members");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Listado de participantes - ${widget.name}",
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
          stream:
              membersList.orderByChild("idTeam").equalTo(widget.idTeam).onValue,
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
                                      MediaQuery.of(context).size.width * 0.70,
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
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return NewMemberPage(
                                          idTeam: dataList[index]["idTeam"],
                                          nameTeam: "",
                                          isEditing: dataList[index]["key"],
                                          name: dataList[index]["name"],
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

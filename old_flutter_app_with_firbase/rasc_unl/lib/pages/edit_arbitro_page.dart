import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:unl_race/authentication/login_screen.dart';
import 'package:unl_race/global/global_var.dart';
import 'package:unl_race/methods/common_methods.dart';
import 'package:unl_race/pages/arbitros_page.dart';
import 'package:unl_race/pages/home_page.dart';
import 'package:unl_race/widgets/loading_dialog.dart';

class EditArbitroPage extends StatefulWidget {
  final String idUser;
  final String nombres;
  final String idCompetition;
  final String competition;
  final String idTeam;
  final String team;
  final String blockStatus;
  const EditArbitroPage({
    super.key,
    required this.idUser,
    required this.nombres,
    required this.idCompetition,
    required this.competition,
    required this.idTeam,
    required this.team,
    required this.blockStatus,
  });

  @override
  State<EditArbitroPage> createState() => _NewArbitroPageState();
}

class _NewArbitroPageState extends State<EditArbitroPage> {
  TextEditingController userNameTextEditingController = TextEditingController();

  CommonMethods cMethods = CommonMethods();

  String? selectedCompetencia;
  String? selectedTeam;

  String? selectedCompetenciaName;
  String? selectedTeamName;

  List competencias = [];
  List equipos = [];

  bool status = false;

  showLoadingDialog() {
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Espere por favor'),
          ),
        );
      },
    );
  }

  checkIfNetworkIsAvailable() {
    cMethods.checkConnectivity(context);

    signFormValidation();
  }

  signFormValidation() {
    if (userNameTextEditingController.text.trim().isEmpty) {
      cMethods.displaySnackBar("Introduzca sus nombres completos", context);
    } else if (selectedCompetencia == null) {
      cMethods.displaySnackBar("Seleccione la carrera", context);
    } else if (selectedTeam == null) {
      cMethods.displaySnackBar("Seleccione el equipo.", context);
    } else {
      // register user
      editArbitro();
    }
  }

  editArbitro() async {
    showDialog(
      context: context,
      builder: (context) =>
          const LoadingDialog(messageText: "Editando arbitro..."),
      barrierDismissible: false,
    );

    try {
      if (!context.mounted) return;
      Navigator.pop(context);

      DatabaseReference usersRef =
          FirebaseDatabase.instance.ref().child("users").child(widget.idUser);

      Map<String, Object?> userDataMap = {
        "nombres": userNameTextEditingController.text.trim().toUpperCase(),
        "blockStatus": status == false ? "no" : "yes",
        "idCompetition": selectedCompetencia,
        "idTeam": selectedTeam,
        "competition": selectedCompetenciaName,
        "team": selectedTeamName,
      };

      usersRef.update(userDataMap);

      if (!mounted) return;

      showModalVerification();
    } catch (e) {
      Navigator.pop(context);
      return cMethods.displaySnackBar(e.toString(), context);
    }
  }

  showModalVerification() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Arbitro editado correctamente',
            style: TextStyle(
              fontFamily: "QuicksandMedium",
            ),
          ),
          content: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.2,
            child: const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Icon(
                      Icons.check,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text(
                'Finalizar',
                style: TextStyle(fontFamily: "QuicksandMedium"),
              ),
              onPressed: () {
                Navigator.pop(context);

                //  FirebaseAuth.instance.signOut();

                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) {
                    return const ArbitrosPage();
                  },
                ), (route) => false);
              },
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  Future fetchCompetencias() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('competitions');
    DataSnapshot snapshot = await ref.get();
    List competencias = [];

    Map data = snapshot.value as Map;

    data.forEach((key, value) => competencias.add({"key": key, ...value}));

    return competencias;
  }

  Future fetchEquipos(String idCompetition) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('teams');
    Query query = ref.orderByChild('idCompetition').equalTo(idCompetition);
    DataSnapshot snapshot = await query.get();
    List equipos = [];

    Map data = snapshot.value as Map;

    data.forEach((key, value) => equipos.add({"key": key, ...value}));

    return equipos;
  }

  @override
  void initState() {
    super.initState();
    userNameTextEditingController.text = widget.nombres;

    loadCompetencias();

    selectedCompetencia = widget.idCompetition;
    selectedCompetenciaName = widget.competition;

    selectedTeam = widget.idTeam;

    selectedTeamName = widget.team;

    status = widget.blockStatus == "no" ? false : true;

    loadEquipos(selectedCompetencia!);
  }

  void loadCompetencias() async {
    competencias = await fetchCompetencias();
    setState(() {});
  }

  void loadEquipos(String idCompetition) async {
    equipos = await fetchEquipos(idCompetition);
    selectedTeam = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final borde = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(50.0)),
      borderSide: BorderSide(
        color: secondary,
      ),
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Editar Arbitro",
            style: TextStyle(
              fontFamily: "QuicksandMedium",
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                // text fields + Button
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // NOMBRES
                      TextField(
                        controller: userNameTextEditingController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.red,
                          enabledBorder: borde,
                          border: borde,
                          focusedBorder: borde,
                          labelText: 'Nombre y apellido del arbitro',
                          labelStyle: TextStyle(
                            fontSize: 14,
                            color: color,
                            fontFamily: 'QuicksandRegular',
                          ),
                        ),
                        style: TextStyle(
                          color: color,
                          fontSize: 15,
                          fontFamily: 'QuicksandRegular',
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),

                      Row(
                        children: [
                          const Text(
                            "Desactivar arbitro?",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "QuicksandSemiBold",
                              color: Colors.black,
                            ),
                          ),
                          Switch(
                            value: status,
                            onChanged: (value) {
                              setState(() {
                                status = value;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 32,
                      ),

                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: DropdownButton<String>(
                          focusColor: Colors.black,
                          dropdownColor: Colors.white,
                          isDense: true,
                          isExpanded: true,
                          style: const TextStyle(
                            fontFamily: "QuicksandSemiBold",
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis,
                          ),
                          hint: const Text(
                            'Selecciona una competencia',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          value: selectedCompetencia,
                          onChanged: (String? newValue) {
                            int indice = competencias
                                .indexWhere((map) => map['key'] == newValue);

                            setState(() {
                              selectedCompetencia = newValue!;

                              selectedCompetenciaName =
                                  competencias[indice]["name"];

                              loadEquipos(selectedCompetencia!);
                            });
                          },
                          items: competencias.map((competencia) {
                            return DropdownMenuItem<String>(
                              value: competencia["key"],
                              child: Text(competencia["name"]),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(
                        height: 32,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: DropdownButton<String>(
                          hint: const Text(
                            'Selecciona un equipo',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          focusColor: Colors.black,
                          dropdownColor: Colors.white,
                          isDense: true,
                          isExpanded: true,
                          style: const TextStyle(
                            fontFamily: "QuicksandSemiBold",
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis,
                          ),
                          value: selectedTeam,
                          onChanged: (String? newValue) {
                            int indice = equipos
                                .indexWhere((map) => map['key'] == newValue);
                            setState(() {
                              selectedTeam = newValue!;
                              selectedTeamName = equipos[indice]["name"];
                            });
                          },
                          items: equipos.map((equipo) {
                            return DropdownMenuItem<String>(
                              value: equipo["key"],
                              child: Text(equipo["name"]),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(
                        height: 32,
                      ),

                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            checkIfNetworkIsAvailable();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 80)),
                          child: Text(
                            'Editar Arbitro',
                            style: TextStyle(
                              color: primary,
                              fontFamily: 'QuicksandBold',
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

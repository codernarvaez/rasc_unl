import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:unl_race/global/global_var.dart';
import 'package:unl_race/methods/common_methods.dart';
import 'package:unl_race/pages/arbitros_page.dart';
import 'package:unl_race/widgets/loading_dialog.dart';

class NewArbitroPage extends StatefulWidget {
  const NewArbitroPage({
    super.key,
  });

  @override
  State<NewArbitroPage> createState() => _NewArbitroPageState();
}

class _NewArbitroPageState extends State<NewArbitroPage> {
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  CommonMethods cMethods = CommonMethods();

  bool isPasswordVisible = true;

  String? selectedCompetencia;
  String? selectedTeam;

  String? selectedCompetenciaName;
  String? selectedTeamName;

  List competencias = [];
  List equipos = [];

  String? idUserFirebaseAdmin;

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
    } else if (!emailTextEditingController.text.contains("@")) {
      cMethods.displaySnackBar(
          "Por favor escriba un correo electrónico válido.", context);
    } else if (passwordTextEditingController.text.trim().length < 6) {
      cMethods.displaySnackBar(
          "su contraseña debe tener al menos 6 o más caracteres.", context);
    } else if (selectedCompetencia == null) {
      cMethods.displaySnackBar("Seleccione la carrera", context);
    } else if (selectedTeam == null) {
      cMethods.displaySnackBar("Seleccione el equipo.", context);
    } else {
      // register user
      registerNewUser();
    }
  }

  registerNewUser() async {
    showDialog(
      context: context,
      builder: (context) =>
          const LoadingDialog(messageText: "Registrando arbitro..."),
      barrierDismissible: false,
    );

    try {
      final User? userFirebase =
          (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      ))
              .user;

      if (!context.mounted) return;
      Navigator.pop(context);

      DatabaseReference usersRef = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(userFirebase!.uid);

      Map userDataMap = {
        "nombres": userNameTextEditingController.text.trim().toUpperCase(),
        "apellidos": "",
        "email": emailTextEditingController.text.trim(),
        "id": userFirebase.uid,
        "blockStatus": "no",
        "role": "arbitro",
        "idCompetition": selectedCompetencia,
        "idTeam": selectedTeam,
        "competition": selectedCompetenciaName,
        "team": selectedTeamName,
      };

      usersRef.set(userDataMap);

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
            'Arbitro registrado correctamente',
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
              onPressed: () async {
                try {
                  Navigator.pop(context);

                  await FirebaseAuth.instance.signOut();

                  (await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: pass,
                  ))
                      .user;

                  if (!context.mounted) return;

                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) {
                      return const ArbitrosPage();
                    },
                  ), (route) => false);
                } catch (e) {
                  cMethods.displaySnackBar(e.toString(), context);
                }
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
    loadCompetencias();
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
            "Nuevo Arbitro",
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

                      TextField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.red,
                          enabledBorder: borde,
                          border: borde,
                          focusedBorder: borde,
                          labelText: 'Email',
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
                      TextField(
                        controller: passwordTextEditingController,
                        keyboardType: TextInputType.text,
                        obscureText: isPasswordVisible,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.red,
                          enabledBorder: borde,
                          border: borde,
                          suffixIcon: IconButton(
                            onPressed: () {
                              isPasswordVisible = !isPasswordVisible;
                              setState(() {});
                            },
                            icon: isPasswordVisible
                                ? const Icon(Icons.remove_red_eye,
                                    color: Colors.white)
                                : const Icon(Icons.visibility_off,
                                    color: Colors.white),
                          ),
                          focusedBorder: borde,
                          labelText: 'Contraseña',
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
                            'Crear Arbitro',
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

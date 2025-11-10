import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unl_race/methods/common_methods.dart';
import 'package:unl_race/pages/home_page.dart';
import 'package:unl_race/widgets/loading_dialog.dart';

class NewTeamPage extends StatefulWidget {
  final String idCompetition;
  final String nameCompetition;
  final String? isEditing;
  final String? category;
  final String? name;
  final String? teacher;
  final String? status;
  final int? numberOfParticipants;

  const NewTeamPage({
    super.key,
    required this.idCompetition,
    required this.nameCompetition,
    this.category,
    this.name,
    this.status,
    this.isEditing,
    this.numberOfParticipants,
    this.teacher,
  });

  @override
  State<NewTeamPage> createState() => _NewTeamPageState();
}

class _NewTeamPageState extends State<NewTeamPage> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController teacherNameTextEditingController =
      TextEditingController();

  TextEditingController numberOfParticipantsTextEditingController =
      TextEditingController();

  DatabaseReference teamsRef = FirebaseDatabase.instance.ref().child("teams");

  int numberOfTeams = 1;
  String? categorySelected;

  final FocusNode focusNode = FocusNode();

  CommonMethods cMethods = CommonMethods();
  List<String> categories = [
    "Institucional",
    "Carrera de Pedagogía de la actividad Física y Deporte PAFD",
  ];

  bool status = false;

  String? checkFields() {
    // validar banco

    if (nameTextEditingController.text == "") {
      //cMethods.displaySnackBar("Introduzca el teléfono.", context);
      return null;
    }

    if (categorySelected == null) {
      //cMethods.displaySnackBar("Introduzca el teléfono.", context);
      return null;
    }

    return "";
  }

  editTeam() async {
    showDialog(
      context: context,
      builder: (context) => const LoadingDialog(messageText: "Procesando..."),
      barrierDismissible: false,
    );

    try {
      final Map<String, Object?> data = {
        "name": nameTextEditingController.text.trim(),
        "category": categorySelected,
        "status": status == false ? "active" : "inactive",
        "tutor": teacherNameTextEditingController.text,
        "participants":
            int.parse(numberOfParticipantsTextEditingController.text),
        "idUser": FirebaseAuth.instance.currentUser!.uid,
      };

      await teamsRef.child(widget.isEditing!).update(data);

      teamsRef.onDisconnect();

      nameTextEditingController.clear();

      showModal();
    } catch (e) {
      if (!context.mounted) return;
      cMethods.displaySnackBar(
          "Error inesperado. Intente de nuevo mas tarde.", context);
    }
  }

  saveNewTeam() async {
    showDialog(
      context: context,
      builder: (context) => const LoadingDialog(messageText: "Procesando..."),
      barrierDismissible: false,
    );

    try {
      final Map data = {
        "name": nameTextEditingController.text.trim(),
        "category": categorySelected,
        "status": "active",
        "tutor": teacherNameTextEditingController.text,
        "idUser": FirebaseAuth.instance.currentUser!.uid,
        "participants":
            int.parse(numberOfParticipantsTextEditingController.text),
        "idCompetition": widget.idCompetition,
        "nro": numberOfTeams,
      };

      await teamsRef.push().set(data);

      await FirebaseDatabase.instance
          .ref()
          .child("competitions")
          .child(widget.idCompetition)
          .update({"countTeams": numberOfTeams});

      teamsRef.onDisconnect();

      nameTextEditingController.clear();
      FocusScope.of(context).requestFocus(focusNode);
      showModal();
    } catch (e) {
      if (!context.mounted) return;
      cMethods.displaySnackBar(
          "Error inesperado. Intente de nuevo mas tarde.", context);
    }
  }

  showModal() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            widget.isEditing == null
                ? 'Equipo registrado correctamente'
                : 'Equipo editado correctamente',
            style: const TextStyle(
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
              child: Center(
                child: CircleAvatar(
                  radius: 40,
                  child: Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 50,
                  ),
                ),
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

                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) {
                    return const HomePage();
                  },
                ), (route) => false);
              },
            ),
            ElevatedButton(
              child: const Text(
                'Agregar otro equipo.',
                style: TextStyle(fontFamily: "QuicksandMedium"),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);

                setState(() {
                  nameTextEditingController.clear();
                  teacherNameTextEditingController.clear();
                  numberOfParticipantsTextEditingController.clear();

                  status = false;

                  categorySelected = null;

                  numberOfTeams = 1;

                  teamCounter();
                });

                /*
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) {
                    return const HomePage();
                  },
                ), (route) => false);

              */
              },
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  Future<void> teamCounter() async {
    try {
      DatabaseEvent snapshot = await teamsRef
          .orderByChild("idCompetition")
          .equalTo(widget.idCompetition)
          .once();

      Map<dynamic, dynamic> data =
          snapshot.snapshot.value as Map<dynamic, dynamic>;

      int cantidadEquipos = data.keys.length;

      setState(() {
        numberOfTeams = cantidadEquipos + 1;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    teamCounter();

    if (widget.isEditing != null) {
      nameTextEditingController.text = widget.name!;
      status = widget.status == "active" ? false : true;
      categorySelected = widget.category;
      numberOfParticipantsTextEditingController.text =
          widget.numberOfParticipants.toString();

      teacherNameTextEditingController.text = widget.teacher!;
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing == null
              ? "Nuevo Equipo - ${widget.nameCompetition}"
              : "Editar equipo",
          style: const TextStyle(
            fontFamily: "QuicksandMedium",
            fontSize: 16,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isEditing == null)
                Text(
                  "Nro $numberOfTeams",
                  style: const TextStyle(
                    fontFamily: "QuicksandBold",
                    fontSize: 22,
                  ),
                ),

              // INPUT TEAM
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.80,
                child: TextField(
                  controller: nameTextEditingController,
                  focusNode: focusNode,
                  style: const TextStyle(
                    fontFamily: "QuicksandRegular",
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Nombre equipo",
                    hintStyle: TextStyle(
                      fontFamily: "QuicksandRegular",
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 45,
              ),

              //SELECT CATEGORY
              SizedBox(
                width: double.infinity,
                height: 45,
                child: DropdownButton<String>(
                  value: categorySelected,
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
                    'Categoría',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        category,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? selectedCategory) {
                    categorySelected = selectedCategory;

                    setState(() {});
                  },
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              // INPUT TEAM TEACHER
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.80,
                child: TextField(
                  controller: teacherNameTextEditingController,
                  style: const TextStyle(
                    fontFamily: "QuicksandRegular",
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Docente tutor",
                    hintStyle: TextStyle(
                      fontFamily: "QuicksandRegular",
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              // INPUT NUMBER TEAM
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.80,
                child: TextField(
                  controller: numberOfParticipantsTextEditingController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontFamily: "QuicksandRegular",
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Número de participantes",
                    hintStyle: TextStyle(
                      fontFamily: "QuicksandRegular",
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 45,
              ),

              if (widget.isEditing != null)
                Row(
                  children: [
                    const Text(
                      "Desactivar equipo?",
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

              if (widget.isEditing != null)
                const SizedBox(
                  height: 45,
                ),

              //Buttons
              const SizedBox(
                height: 55,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: FilledButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                          Color.fromARGB(255, 216, 216, 216),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                          builder: (context) {
                            return const HomePage();
                          },
                        ), (route) => false);
                      },
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(
                          fontFamily: "QuicksandMedium",
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: FilledButton(
                      onPressed: checkFields() == null
                          ? null
                          : widget.isEditing == null
                              ? saveNewTeam
                              : editTeam,
                      child: const Text(
                        "Aceptar",
                        style: TextStyle(
                          fontFamily: "QuicksandMedium",
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

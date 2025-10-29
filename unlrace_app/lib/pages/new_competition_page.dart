import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unl_race/methods/common_methods.dart';
import 'package:unl_race/pages/home_page.dart';
import 'package:unl_race/widgets/loading_dialog.dart';

class NewCompetitionPage extends StatefulWidget {
  final String? isEditing;
  final String? name;
  final String? date;
  final String? status;
  const NewCompetitionPage(
      {super.key, this.isEditing, this.name, this.date, this.status});

  @override
  State<NewCompetitionPage> createState() => _NewCompetitionPageState();
}

class _NewCompetitionPageState extends State<NewCompetitionPage> {
  TextEditingController nameTextEditingController = TextEditingController();
  DatabaseReference competitionRef =
      FirebaseDatabase.instance.ref().child("competitions");

  CommonMethods cMethods = CommonMethods();

  DateTime? selectedDate;
  String? selectedDateFormmated;
  bool status = false;

Future<void> _selectDate() async {
  final DateTime now = DateTime.now();
  final DateTime first = DateTime(now.year, now.month, now.day);
  final DateTime last = DateTime(now.year + 1, 12, 31);

  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: now.isAfter(last) ? last : now, // 👈 evita error
    firstDate: first,
    lastDate: last,
  );

  if (picked != null) {
    selectedDate = picked;
    selectedDateFormmated = DateFormat('dd/MM/yyyy').format(picked);
    setState(() {});
  }
}

  String? checkFields() {
    // validar banco

    if (nameTextEditingController.text == "") {
      //cMethods.displaySnackBar("Introduzca el teléfono.", context);
      return null;
    }

    // validar fecha

    if (selectedDateFormmated == null) {
      //cMethods.displaySnackBar("Seleccione una fecha", context);
      return null;
    }

    return "";
  }

  editCompetition() async {
    showDialog(
      context: context,
      builder: (context) => const LoadingDialog(messageText: "Procesando..."),
      barrierDismissible: false,
    );

    try {
      final Map<String, Object?> data = {
        "name": nameTextEditingController.text.trim(),
        "date": selectedDateFormmated,
        "idUser": FirebaseAuth.instance.currentUser!.uid,
        "status": status ? "off" : "on",
        "start": "off"
      };

      await competitionRef.child(widget.isEditing!).update(data);

      nameTextEditingController.clear();
      selectedDateFormmated = null;

      showModal();
    } catch (e) {
      if (!context.mounted) return;
      cMethods.displaySnackBar(
          "Error inesperado. Intente de nuevo mas tarde.", context);
    }
  }

  saveNewCompetition() async {
    showDialog(
      context: context,
      builder: (context) => const LoadingDialog(messageText: "Procesando..."),
      barrierDismissible: false,
    );

    try {
      final Map data = {
        "name": nameTextEditingController.text.trim(),
        "date": selectedDateFormmated,
        "idUser": FirebaseAuth.instance.currentUser!.uid,
        "status": "on",
        "countTeams": 0
      };

      await competitionRef.push().set(data);

      competitionRef.onDisconnect();

      nameTextEditingController.clear();
      selectedDateFormmated = null;

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
                ? 'Competencia registrado correctamente'
                : "Competencia editada correctamente",
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
                'Aceptar',
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
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.isEditing != null) {
      nameTextEditingController.text = widget.name!;
      //selectedDate = widget.date!;

      selectedDateFormmated = widget.date!;

      status = widget.status! == "on" ? false : true;
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
              ? "Nueva Competicion"
              : "Editar Competicion ",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.80,
              child: TextField(
                controller: nameTextEditingController,
                style: const TextStyle(
                  fontFamily: "QuicksandRegular",
                  color: Colors.black,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  hintText: "Nombre competencia",
                  hintStyle: TextStyle(
                    fontFamily: "QuicksandRegular",
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.80,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.zero,
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue)),
                onPressed: _selectDate,
                icon: const Icon(
                  Icons.date_range,
                  size: 16,
                  color: Colors.white,
                ),
                label: Text(
                  selectedDateFormmated != null
                      ? selectedDateFormmated!
                      : 'Fecha competencia',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: "QuicksandSemiBold",
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            if (widget.isEditing != null)
              Row(
                children: [
                  const Text(
                    "Finalizar competencia?",
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
                height: 25,
              ),
            //Button

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
                            ? saveNewCompetition
                            : editCompetition,
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
    );
  }
}

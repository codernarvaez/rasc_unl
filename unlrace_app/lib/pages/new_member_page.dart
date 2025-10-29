import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unl_race/methods/common_methods.dart';
import 'package:unl_race/pages/home_page.dart';
import 'package:unl_race/widgets/loading_dialog.dart';

class NewMemberPage extends StatefulWidget {
  final String idTeam;
  final String nameTeam;
  final String? isEditing;
  final String? name;
  final String? status;
  const NewMemberPage({
    super.key,
    required this.idTeam,
    required this.nameTeam,
    this.isEditing,
    this.name,
    this.status,
  });

  @override
  State<NewMemberPage> createState() => _NewMemberPageState();
}

class _NewMemberPageState extends State<NewMemberPage> {
  TextEditingController nameTextEditingController = TextEditingController();

  DatabaseReference membersRef =
      FirebaseDatabase.instance.ref().child("members");

  int numberOfMembers = 1;

  CommonMethods cMethods = CommonMethods();
  bool status = false;

  editMember() async {
    if (nameTextEditingController.text == "") {
      cMethods.displaySnackBar("Introduzca el participante", context);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => const LoadingDialog(messageText: "Procesando..."),
      barrierDismissible: false,
    );

    try {
      final Map<String, Object?> data = {
        "name": nameTextEditingController.text.trim(),
        "status": status == false ? "active" : "inactive",
        "idUser": FirebaseAuth.instance.currentUser!.uid,
        "idTeam": widget.idTeam,
      };

      await membersRef.child(widget.isEditing!).update(data);

      nameTextEditingController.clear();

      showModal();
    } catch (e) {
      if (!context.mounted) return;
      cMethods.displaySnackBar(
          "Error inesperado. Intente de nuevo mas tarde.", context);
    }
  }

  saveNewMember() async {
    if (nameTextEditingController.text == "") {
      cMethods.displaySnackBar("Introduzca el participante", context);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => const LoadingDialog(messageText: "Procesando..."),
      barrierDismissible: false,
    );

    try {
      final Map data = {
        "name": nameTextEditingController.text.trim(),
        "status": "active",
        "idUser": FirebaseAuth.instance.currentUser!.uid,
        "idTeam": widget.idTeam,
      };

      await membersRef.push().set(data);

      await FirebaseDatabase.instance
          .ref()
          .child("teams")
          .child(widget.idTeam)
          .update({"members": numberOfMembers});

      membersRef.onDisconnect();

      nameTextEditingController.clear();

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
                ? 'Participante registrado correctamente'
                : "Participante editado correctamente",
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

  Future<void> memberCounter() async {
    try {
      DatabaseEvent snapshot =
          await membersRef.orderByChild("idTeam").equalTo(widget.idTeam).once();

      Map<dynamic, dynamic> data =
          snapshot.snapshot.value as Map<dynamic, dynamic>;

      int count = data.keys.length + 1;

      setState(() {
        numberOfMembers = count;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    memberCounter();

    if (widget.isEditing != null) {
      nameTextEditingController.text = widget.name!;
      status = widget.status! == "active" ? false : true;
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
              ? "Nuevo Participante - ${widget.nameTeam}"
              : "Editar participante",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isEditing == null)
              Text(
                "Nro $numberOfMembers",
                style: const TextStyle(
                  fontFamily: "QuicksandBold",
                  fontSize: 22,
                ),
              ),

            // INPUT
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
                  hintText: "Nombre participante",
                  hintStyle: TextStyle(
                    fontFamily: "QuicksandRegular",
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            if (widget.isEditing != null)
              Row(
                children: [
                  const Text(
                    "Desactivar participante?",
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
                    onPressed: () => widget.isEditing == null
                        ? saveNewMember()
                        : editMember(),
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

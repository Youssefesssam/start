import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:star_t/firebase/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:star_t/utilites/appColors.dart';
import 'answers.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  late Future<QueryDocumentSnapshot?> _taskFuture;
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the future once when the widget is created
    _taskFuture =
        FirebaseFirestore.instance.collection('task').limit(1).get().then((
            snapshot) {
          if (snapshot.docs.isNotEmpty) {
            return snapshot.docs.first; // Return the first task if it exists
          } else {
            return null; // Return null if no task exists
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QueryDocumentSnapshot?>(
      future: _taskFuture, // Use the pre-initialized future
      builder: (context, snapshot) {
        // If a task exists, load it into the controller
        if (snapshot.hasData && snapshot.data != null) {
          _taskController.text = snapshot.data!['task'];
        } else {
          _taskController.text = ''; // Empty field if no task exists
        }

        return  Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery
                  .of(context)
                  .size
                  .height * 0.9,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 160,right: 160),
                    height: 4,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Text(
                        "Write the taskoo",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Spacer(),
                      GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, Answers.routeName);
                          },
                          child: Icon(Icons.question_answer,size:35,color: AppColors.secColor,)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(

                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(-5, 0),
                        ),
                      ],
                    ),

                    child: Row(
                      children: [
                        Text(_taskController.text.isEmpty?'No Task yet':_taskController.text,style: TextStyle(fontSize: 25,color: Colors.teal,fontWeight: FontWeight.bold), ),
                        Spacer(),
                        InkWell(
                            onTap: (){
                              FirebaseUtils.deleteAnswers();

                              _taskController.clear();
                            },
                            child: Icon(Icons.delete_sweep_rounded,size: 30,color: Colors.red[400],))
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // حقل إدخال النص
                  TextField(
                    controller: _taskController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Task...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    style: const TextStyle(color: Colors.black87),
                    readOnly: false,
                    enabled: true,
                  ),
                  const SizedBox(height: 30),

                  // أزرار الإجراءات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 60,
                        width: 180,
                        child: SlideAction(
                          innerColor: Colors.white,
                          outerColor: Colors.red[600],
                          elevation: 10,
                          textColor: Colors.white,
                          sliderButtonIconSize: 10,
                          sliderButtonIconPadding: 12,
                          sliderButtonIcon: Icon(Icons.delete, size: 20, color: Colors.red),
                          submittedIcon: Icon(Icons.check, size: 30, color: Colors.white),
                          key: GlobalKey<SlideActionState>(),
                          onSubmit: () {
                            Future.delayed(const Duration(seconds: 3), () {
                              Navigator.pop(context);
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(width: 10,),
                              Text(
                                "Exit",  // تصحيح التسمية إلى Exit
                                style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      SizedBox(
                        height: 60,
                        width: 180,
                        child: SlideAction(
                          innerColor: Colors.white,
                          outerColor: Colors.teal,
                          elevation: 10,
                          textColor: Colors.white,
                          sliderButtonIconSize: 10,
                          sliderButtonIconPadding: 12,
                          sliderButtonIcon: Icon(Icons.send, size: 20, color: Colors.teal),
                          submittedIcon: Icon(Icons.check, size: 30, color: Colors.white),
                          key: GlobalKey<SlideActionState>(),
                          onSubmit: () {
                            Future.delayed(const Duration(seconds: 1), () {
                              FirebaseUtils.sendTask(
                                task: _taskController.text,
                                leader: 'tina',
                              );
                              Navigator.pop(context);
                            },);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(width: 10,),
                              Text(
                                "Share",
                                style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
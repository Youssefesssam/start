import 'package:flutter/material.dart';

class Team extends StatelessWidget {
  const Team({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9, // تحديد الحد الأقصى للإرتفاع
        ),
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Center(
                      child: const Text(
                        "Team",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Icon(Icons.arrow_right,color: Colors.teal,size: 40,)
                  ],

                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          decoration:
                          const BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                            BorderRadius.only(
                                bottomRight:
                                Radius.circular(
                                    20),
                                bottomLeft:
                                Radius.circular(
                                    20),
                                topLeft:
                                Radius.circular(
                                    20),
                                topRight:
                                Radius.circular(
                                    20)),),

                          child: InkWell(
                            onTap: (){},
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),

                        SizedBox(width: 15),
                        Text(
                          "Name team Leader",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.teal,
                          radius: 25,
                        ),
                        Row(
                          children: [

                            Text("seno",style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold,fontSize: 15),),

                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                top: 10,
                                left: 15,
                                right: 10,
                                bottom: 3),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight:
                                  Radius.circular(20),
                                  topLeft:
                                  Radius.circular(20),
                                  topRight:
                                  Radius.circular(20)),
                              color: Color(0x6fa6a3a3),
                            ),
                            child:   Text(
                              "youssef,tena,semon,mina,teto",
                              style: const TextStyle(
                                  fontSize: 18),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 5,
                                    right: 10,
                                    left: 15,
                                    bottom: 3),
                                padding: const EdgeInsets.all(5),
                                decoration:
                                const BoxDecoration(
                                  borderRadius:
                                  BorderRadius.only(
                                      bottomRight:
                                      Radius.circular(
                                          20),
                                      bottomLeft:
                                      Radius.circular(
                                          20),
                                      topLeft:
                                      Radius.circular(
                                          0),
                                      topRight:
                                      Radius.circular(
                                          20)),
                                  color: Colors.blueAccent,
                                ),
                                child: const Center(
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 15,
                                    )),
                              ),

                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration:
                      const BoxDecoration(borderRadius: BorderRadius.only(bottomRight: Radius.circular(100), bottomLeft: Radius.circular(100), topLeft: Radius.circular(100), topRight: Radius.circular(100)), color: Colors.red,
                      ),
                      child:Center(
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 15,
                          )),
                    ),
                  ],
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../../../utilites/appColors.dart';
import 'package:url_launcher/url_launcher.dart';

class AbsentData extends StatefulWidget {
  static const String routeName = "absentData";

  const AbsentData({super.key});

  @override
  State<AbsentData> createState() => _AbsentDataState();
}
void openWhatsApp(String whatsapp)async{
  await launchUrl(Uri.parse("https://wa.me/+2$whatsapp?text= اهلين"));
}
void openPhone(String phone)async{
  await launchUrl(Uri.parse("tel:$phone"));
}
void getLatLngFromAddress(String address) async {
  try {
    List<Location> locations = await locationFromAddress(address);
    double lat = locations.first.latitude;
    double lng = locations.first.longitude;

    // افتح Google Maps بالموقع ده
    final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");
    await launchUrl(url);
  } catch (e) {
    print("Error: $e");
  }
}
void openFacebook(String link) async {
  final url = Uri.parse(link);
  await launchUrl(url);
}
class _AbsentDataState extends State<AbsentData> {

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String profile = args["profile"];
    String name = args["name"];
    String email = args["email"];
    String phone = args["phone"];
    String address = args["address"];
    String whatsapp = args["whatsapp"];
    String facebook = args["facebook"];
    int lack = args["lack"];
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ✅ Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 0, bottom: 30, left: 16, right: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.appBarColor,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(profile),
                        backgroundColor: Colors.white,
                      ),
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                            child: Text(
                              "+$lack",
                              style:
                              TextStyle(fontSize: 15, color: AppColors.white),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.teal.shade100,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  GestureDetector(
                      onTap:(){
                        print("phone");
                        openPhone(phone);
                      }
                      ,  child: buildInfoCard(Icons.phone, "Phone", phone)),
                  InkWell(
                      onTap: (){
                        getLatLngFromAddress(address);
                        },
                      child: buildInfoCard(Icons.location_on, "Address", address)),
                  InkWell(
                      onTap: (){
                        print("whatsapp");
                        openWhatsApp(whatsapp);
                      },
                      child: buildInfoCard(Icons.phone_android, "WhatsApp", whatsapp)),
                  InkWell(
                      onTap: (){
                        openFacebook(facebook);
                        print(facebook);
                      },
                      child: buildInfoCard(Icons.facebook, "Facebook", facebook)),
                  buildInfoCard(Icons.plus_one, "Lack", "$lack"),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal[100],
          child: Icon(icon, color: Colors.teal[900]),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(value),
      ),
    );
  }
}
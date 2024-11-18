
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../../../../../utilites/appAssets.dart';
import '../designCard/designCard.dart';
import 'event/event.dart';


class SliderPic extends StatelessWidget {
  SliderPic({super.key});
  static const String routeName ="sliderPic";

  List<Widget> pic =[
    DesignCard(titleCard: "team" ,path: AppAssets.meeting, appearNatification: true, colorNatification: Colors.orange, numNatification: 2,),
    DesignCard(titleCard: "event",path: AppAssets.calendar, appearNatification: true, colorNatification: Colors.orange, numNatification: 6,),
    DesignCard(titleCard: "task" ,path: AppAssets.planning,appearNatification: true , colorNatification: Colors.orange, numNatification: 17),
  ];
  final CarouselController _carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          InkWell(
            onTap: () {
              //Navigator.pushNamed(context, EventScreen.routeName);
            },
            child: CarouselSlider(
                items: pic,
                options: CarouselOptions(
                  height: 190,
                  viewportFraction: .4,
                  initialPage: 0,
                  enableInfiniteScroll: true ,
                  autoPlay: false,
                  autoPlayInterval: const Duration(seconds:2),
                  autoPlayAnimationDuration: const Duration(seconds: 2),
                  autoPlayCurve: Curves.easeInOut,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  scrollDirection: Axis.horizontal,
                )
            ),
          ),
        ],
    );
  }
}

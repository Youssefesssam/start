
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../../../../../utilites/appAssets.dart';
import 'designCard/designCard.dart';
import 'event/event.dart';


class SliderPic extends StatelessWidget {
  SliderPic({super.key});
  static const String routeName ="sliderPic";

  List<Widget> pic =[
    DesignCard(titleCard: "event", color: Colors.black,path: AppAssets.banner,statue: false),
    DesignCard(titleCard: "task", color: Colors.black,path: AppAssets.check,statue: false),
    DesignCard(titleCard: "teem", color: Colors.black,path: AppAssets.teem,statue: false),

  ];
  final CarouselController _carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, EventScreen.routeName);
            },
            child: CarouselSlider(
                items: pic,
                options: CarouselOptions(
                  height: 200,
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

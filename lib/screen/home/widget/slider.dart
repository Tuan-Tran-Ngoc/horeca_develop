// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SliderView extends StatefulWidget {
  double width;
  double height;
  SliderView({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  State<SliderView> createState() => _SliderViewState();
}

class _SliderViewState extends State<SliderView> {
  CarouselController buttonCarouselController = CarouselController();

  List<String> child = [
    'assets/images/acecook1.jpg',
    'assets/images/acecook2.jpg',
    'assets/images/acecook3.jpg',
    'assets/images/acecook4.jpg',
    'assets/images/acecook5.jpg'
  ];

  int _current = 0;

  @override
  Widget build(BuildContext context) => Column(children: <Widget>[
        CarouselSlider(
          // options: CarouselOptions(height: 300.0),
          items: child.map((i) {
            return Container(
              width: widget.width,
              // decoration: BoxDecoration(color: Colors.amber),
              child: Image.asset(
                i,
                fit: BoxFit.fill,
              ),
            );
          }).toList(),
          carouselController: buttonCarouselController,
          options: CarouselOptions(
            height: widget.height,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1,
            aspectRatio: 1.0,
            initialPage: 2,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: child.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => buttonCarouselController.animateToPage(entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ]);
}

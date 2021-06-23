import 'package:flutter/material.dart';

import 'category.dart';
import 'unit.dart';

class CategoryRoute extends StatefulWidget {
  const CategoryRoute();

  @override
  _CategoryRouteState createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  static const _categoryNames = <String>[
    'Length',
    'Area',
    'Volume',
    'Mass',
    'Time',
    'Digital Storage',
    'Energy',
    'Currency',
  ];

  static const _baseIcons = <IconData>[
    Icons.tapas_outlined,
    Icons.edgesensor_high_sharp,
    Icons.hdr_off,
    Icons.two_k_rounded,
    Icons.alarm_add_sharp,
    Icons.construction,
    Icons.gps_off_outlined,
    Icons.menu_sharp,
  ];

  static const _baseColors = <Color>[
    Colors.teal,
    Colors.orange,
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.yellow,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.red,
  ];

  Widget _buildCategoryWidget() {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return ListView.builder(
            itemCount: _categoryNames.length,
            itemBuilder: (BuildContext context, int index) {
              return Category(
                  _categoryNames[index], _baseIcons[index], _baseColors[index]);
            },
          );
        } else {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.0,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: _categoryNames.length,
            itemBuilder: (BuildContext context, int index) {
              return Category(
                  _categoryNames[index], _baseIcons[index], _baseColors[index]);
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final listView = Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: _buildCategoryWidget(),
    );

    final appBar = AppBar(
      title: Text(
        "Unit Converter",
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      backgroundColor: Colors.green[100],
    );

    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }
}

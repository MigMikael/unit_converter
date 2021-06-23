import 'package:flutter/material.dart';
import 'converter_route.dart';

class Category extends StatelessWidget {
  final String _name;
  final IconData _icon;
  final Color _color;

  Category(this._name, this._icon, this._color);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 100.0,
        padding: const EdgeInsets.all(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          highlightColor: Colors.orange,
          splashColor: Colors.red,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConverterRoute(_name, _color)),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(
                  _icon,
                  color: _color,
                  size: 60,
                ),
              ),
              Center(
                child: Text(
                  _name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 24, color: _color),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

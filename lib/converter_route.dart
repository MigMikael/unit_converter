import 'dart:convert';

import 'package:flutter/material.dart';
import 'unit.dart';

class ConverterRoute extends StatefulWidget {
  final String _title;
  final Color _color;

  ConverterRoute(this._title, this._color);

  @override
  _ConverterRouteState createState() => _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterRoute> {
  Unit _fromValue = Unit(name: '', conversion: 1);
  Unit _toValue = Unit(name: '', conversion: 1);
  double _inputValue = 0.0;
  String _convertedValue = '';
  List<DropdownMenuItem> _unitMenuItems = [];

  @override
  void initState() {
    super.initState();
    _initUnits();
    setState(() {
      _inputValue = 0.0;
      _convertedValue = '';
    });
  }

  void _initUnits() async {
    var newItems = <DropdownMenuItem>[];
    var units = await _retrieveUnitFromJson(widget._title);
    for (var unit in units) {
      newItems.add(DropdownMenuItem(
        value: unit.name,
        child: Container(
          child: Text(
            unit.name,
            softWrap: true,
          ),
        ),
      ));
    }

    setState(() {
      _unitMenuItems = newItems;
      _fromValue = units[0];
      _toValue = units[1];
    });

    if (_inputValue != null) {
      _updateConversion();
    }
  }

  void _updateInputValue(String? input) {
    setState(() {
      if (input == null || input.isEmpty) {
        _convertedValue = '';
      } else {
        final inputDouble = double.parse(input);
        _inputValue = inputDouble;
        _updateConversion();
      }
    });
  }

  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  void _updateConversion() {
    print("\n");
    print(_inputValue);
    print('${_fromValue.name} ${_fromValue.conversion}');

    print('${_toValue.name} ${_toValue.conversion}');
    setState(() {
      _convertedValue =
          _format(_inputValue * (_toValue.conversion / _fromValue.conversion));
      print('$_convertedValue');
    });
  }

  Future<Unit> _getUnit(String unitName) async {
    Unit temp = Unit(name: unitName, conversion: 5);
    var units = await _retrieveUnitFromJson(widget._title);
    units.forEach((element) { 
      if (element.name == unitName) {
        temp = element;
      }
    });
    return temp;
  }

  void _updateFormConversion(dynamic unitName) async {
    var unit = await _getUnit(unitName);
    setState(() {
      _fromValue = unit;
    });
    if (_inputValue != null) {
      _updateConversion();
    }
  }

  void _updateToConversion(dynamic unitName) async {
    var unit = await _getUnit(unitName);
    setState(() {
      _toValue = unit;
    });
    if (_inputValue != null) {
      _updateConversion();
    }
  }

  Future<List<Unit>> _retrieveUnitFromJson(String categoryName) async {
    final json = DefaultAssetBundle.of(context)
        .loadString('assets/data/regular_units.json');
    final data = JsonDecoder().convert(await json);
    if (data is! Map) {
      throw ('Data retrieved from API is not a Map');
    }

    List<Unit> units = [];
    data.keys.forEach((key) {
      if (key == categoryName) {
        var temp =
            data[key].map<Unit>((dynamic data) => Unit.fromJson(data)).toList();
        units = temp;
      }
    });
    return units;
  }

  Widget _createDropDown(String currentValue, ValueChanged<dynamic> onChange) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.grey[500],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400, width: 1.0)),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            value: currentValue,
            onChanged: onChange,
            items: _unitMenuItems,
          ),
        ),
      ),
    );
  }

  Widget _createInputCard() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Material(
        elevation: 5,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Input",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                onChanged: _updateInputValue,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
              ),
              _createDropDown(_fromValue.name, _updateFormConversion)
            ],
          ),
        ),
      ),
    );
  }

  Widget _createOutputCard() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Material(
        elevation: 5,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Output',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(_convertedValue),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
              ),
              _createDropDown(_toValue.name, _updateToConversion)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget._title),
          backgroundColor: widget._color,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _createInputCard(),
              Icon(Icons.swap_vert, size: 40),
              _createOutputCard(),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                // child: Column(
                //   children: [
                //     Text(_inputValue.toString()),
                //     Text(_fromValue.name),
                //     Text(_convertedValue.toString()),
                //     Text(_toValue.name),
                //   ],
                // ),
              )
            ],
          ),
        ));
  }
}

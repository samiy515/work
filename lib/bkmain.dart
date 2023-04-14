import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:math' as Math;

/*void main() {
  runApp(const MyApp());
}*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: '電卓'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum CALC_TYPE { add, sub, multi, div } //CALC_TYPE型を作った

class _MyHomePageState extends State<MyHomePage> {
  double _setNumber = 0;
  double _firstNum = 0; //数字を保持
  double _showNumber=0;
  CALC_TYPE? _calcType;
  int _displayPow = 0;
  bool _decimalFlag = false;
  String _E="Error";

  void _setNum(double num) {
    _displayPow = 0;
    if (_showNumber == _setNumber) {//①表示の数と保持の数が一緒
      if (100000000000 > _showNumber) {//②表示が千億未満
        setState(() {
          if (!_decimalFlag) {//③小数じゃない時=フラグがfalse
            _showNumber = _showNumber * 10 + num;
          } else {//③小数のとき
            int count = 1;
            for (int i = 0;
                _showNumber * Math.pow(10, i) !=
                    (_showNumber * Math.pow(10, i)).ceil();
                i++) {
              count++;
            }
            _showNumber = double.parse(
                (_showNumber + (num / Math.pow(10, count)))
                    .toStringAsFixed(count));
            _checkDecimal();
          }
          _setNumber = _showNumber;
        });
      }
    } else {//①表示≠保持　②表示の数が千億以上　計算した後にそのまま計算
      setState(() {
        _showNumber = num;
        _setNumber = _showNumber;
        _calcType = null;
      });
    }
  }
void _error(){
    setState(() {
      _showNumber="Error" as double;
    });
}
  void _clearNum() {
    //数字クリア（Cボタンの機能）
    setState(() {
      _showNumber=0 ;
      _setNumber = 0 ;
      _firstNum = 0;
      _calcType = null;
      _displayPow=0;
      _decimalFlag=false;
    });
  } //保持している数字リセット

  void _calcBtnPressed(CALC_TYPE type) {
    _setNumber=_showNumber;
      _firstNum = _setNumber;
      _setNumber = 0;
      _showNumber = 0;
      _calcType = type;
      _decimalFlag=false;
  } //演算子ボタン押した時

  void _calcAdd() {
    setState(() {
      _showNumber = _firstNum + _setNumber;
      _checkDecimal();
      _firstNum = _showNumber;
    });
  } //足し算

  void _calcSub() {
    setState(() {
      _showNumber = _firstNum - _setNumber;
      _checkDecimal();
      _firstNum = _showNumber;
    });
  } //引き算

  void _calcMulti() {
    setState(() {
      _showNumber = _firstNum * _setNumber;
      _checkDecimal();
      _firstNum = _showNumber;
    });
  } //かけ算

  void _calcDiv() {
    setState(() {
      _showNumber = _firstNum / _setNumber;
      _checkDecimal();
      _firstNum = _showNumber;
    });
  } //割り算

  /*void _Error(){
    setState(() {
      _showNumber.toString()= "ERROR";

    });
  }*/

  void _invertedNum(){
    setState(() {
    _showNumber=-_showNumber;
    _setNumber=-_setNumber;
    });
  }//+と-を反転


  void _checkDecimal() {
    double checkNum = _showNumber;

    if (10000000000 < _showNumber || _showNumber == _showNumber.toInt() //整数である
        ) {
      int count;
      for (int i = 0; 10000000000 < checkNum / Math.pow(10, i); i++) {
        count = i;
        checkNum = checkNum / 10;
      }
      setState(() {
        _showNumber = checkNum;
      });
    } else {
      int count = 0;
      for (int i = 0; i < _showNumber / Math.pow(10, i); i++) {
        count = i;
      }
      int displayCount = 10 - count;
      _showNumber = double.parse(_showNumber.toStringAsFixed(displayCount));
    }
  } //小数点の桁制御

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: 20,
                  child: _displayPow > 0
                      ? Text(
                          "10" + "${_displayPow.toString()}",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )
                      : Container(),
                ),
                Text(
                  _showNumber == _showNumber.toInt() //ダブル型だけどイント型でも同じ？
                      ? _showNumber.toInt().toString() //〇なら整数
                      : _showNumber.toString(), //×なら小数
                  style: TextStyle(
                    fontSize: 60,
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    _error();
                                    _showNumber.toString();
                                  },
                                  child: Text(
                                    "空",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 60,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    _clearNum();
                                  },
                                  child: Text(
                                    "CE",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 60,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: TextButton(
                                onPressed: () {
                                  _clearNum();
                                },
                                child: Text(
                                  "C",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 60,
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: TextButton(
                                onPressed: () {
                                  _calcBtnPressed(CALC_TYPE.div);
                                },
                                child: Text(
                                  "÷",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 60,
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ), //空の行

                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: TextButton(
                                onPressed: () {
                                  _setNum(7);
                                },
                                child: Text(
                                  "7",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 60,
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: TextButton(
                                onPressed: () {
                                  _setNum(8);
                                },
                                child: Text(
                                  "8",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 60,
                                  ),
                                ),
                              )),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    _setNum(9);
                                  },
                                  child: Text(
                                    "9",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 60,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: TextButton(
                                onPressed: () {
                                  _calcBtnPressed(CALC_TYPE.multi);
                                },
                                child: Text(
                                  "×",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 60,
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ), //7の行

                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: TextButton(
                                onPressed: () {
                                  _setNum(4);
                                },
                                child: Text(
                                  "4",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 60,
                                  ),
                                ),
                              )),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    _setNum(5);
                                  },
                                  child: Text(
                                    "5",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 60,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    _setNum(6);
                                  },
                                  child: Text(
                                    "6",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 60,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: TextButton(
                                onPressed: () {
                                  _calcBtnPressed(CALC_TYPE.sub);
                                },
                                child: Text(
                                  "-",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 60,
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ), //4の行

                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextButton(
                                    onPressed: () {
                                      _setNum(1);
                                    },
                                    child: Text(
                                      "1",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 60,
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    _setNum(2);
                                  },
                                  child: Text(
                                    "2",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 60,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: TextButton(
                                onPressed: () {
                                  _setNum(3);
                                },
                                child: Text(
                                  "3",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 60,
                                  ),
                                ),
                              )),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    _calcBtnPressed(CALC_TYPE.add);
                                  },
                                  child: Text(
                                    "+",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 60,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ), //1の行

                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    _invertedNum();
                                  },
                                  child: Text(
                                    "+/-",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 60,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    _setNum(0);
                                  },
                                  child: Text(
                                    "0",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 60,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    _decimalFlag=true;
                                  },
                                  child: Text(
                                    ".",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 60,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    switch (_calcType) {
                                      case CALC_TYPE.add:
                                        _calcAdd();
                                        break;

                                      case CALC_TYPE.sub:
                                        _calcSub();
                                        break;

                                      case CALC_TYPE.multi:
                                        _calcMulti();
                                        break;

                                      case CALC_TYPE.div:
                                        if(_setNumber==0) {
                                          _showNumber.toString();
                                          //_showNumber=double.parse('Error');
                                        }
                                        else{
                                          _calcDiv();
                                        }
                                        break;

                                      default:
                                        break;
                                    }
                                  },
                                  child: Text(
                                    "＝",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 60,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ), //.の行
                      ],
                    ),
                  ),
                ),
              ]),
        ));
  }
}

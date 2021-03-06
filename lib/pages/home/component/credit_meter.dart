import 'package:flutter/material.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CreditMeterWidget extends StatefulWidget {
  final double creditScore;

  const CreditMeterWidget({Key key, this.creditScore}) : super(key: key);
  @override
  _CreditMeterWidgetState createState() => _CreditMeterWidgetState();
}

class _CreditMeterWidgetState extends State<CreditMeterWidget> {
  final Color _pointerColor = const Color(0xFF494CA2);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _getRadialNonLinearLabel(),
    );
  }

  /// Returns the non-linear axis label gauge
  SfRadialGauge _getRadialNonLinearLabel() {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      animationDuration: 2500,
      axes: <RadialAxis>[
        RadialAxis(
            labelOffset: 20,
            axisLineStyle: AxisLineStyle(
                thicknessUnit: GaugeSizeUnit.factor, thickness: 0.15),
            radiusFactor: 0.9,
            minimum: 0,
            showTicks: false,
            maximum: 900,
            axisLabelStyle: GaugeTextStyle(fontSize: 12),
            // Added custom axis renderer that extended from RadialAxisRenderer
            onCreateAxisRenderer: handleCreateAxisRenderer,
            pointers: <GaugePointer>[
              NeedlePointer(
                  enableAnimation: true,
                  gradient: const LinearGradient(colors: <Color>[
                    Color.fromRGBO(203, 126, 223, 0.1),
                    Color(0xFFCB7EDF)
                  ], stops: <double>[
                    0.25,
                    0.90
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                  animationType: AnimationType.easeOutBack,
                  value: widget.creditScore,
                  lengthUnit: GaugeSizeUnit.factor,
                  animationDuration: 1300,
                  needleStartWidth: 3,
                  needleEndWidth: 6,
                  //enableDragging: true,
                  onValueChanged: (value) {
                    print("change value is $value");
                  },
                  needleLength: 0.8,
                  knobStyle: KnobStyle(
                    knobRadius: 0,
                  )),
              RangePointer(
                  value: 900,
                  width: 0.15,
                  sizeUnit: GaugeSizeUnit.factor,
                  //enableDragging: true,
                  color: _pointerColor,
                  animationDuration: 1300,
                  animationType: AnimationType.easeOutBack,
                  // Sweep gradient not supported in web.
                  gradient: const SweepGradient(colors: <Color>[
                    Color(0xFFf75959),
                    Color(0xFFf0b530),
                    Color(0xFF3ea884),
                    Color(0xFF1a7e52)
                  ], stops: <double>[
                    0.25,
                    0.50,
                    0.75,
                    1.0
                  ]),
                  enableAnimation: true)
            ])
      ],
    );
  }

  GaugeAxisRenderer handleCreateAxisRenderer() {
    final _CustomAxisRenderer _customAxisRenderer = _CustomAxisRenderer();
    return _customAxisRenderer;
  }
}

class _CustomAxisRenderer extends RadialAxisRenderer {
  _CustomAxisRenderer() : super();

  /// Generated the 9 non-linear interval labels from 0 to 150
  /// instead of actual generated labels.
  @override
  List<CircularAxisLabel> generateVisibleLabels() {
    final List<CircularAxisLabel> _visibleLabels = <CircularAxisLabel>[];
    for (num i = 0; i < 8; i++) {
      final double _value = _calculateLabelValue(i);
      final CircularAxisLabel label = CircularAxisLabel(
          this.axis.axisLabelStyle, _value.toInt().toString(), i, false);
      label.value = _value;
      _visibleLabels.add(label);
    }

    return _visibleLabels;
  }

  /// Returns the factor(0 to 1) from value to place the labels in an axis.
  @override
  double valueToFactor(double value) {
    myPrint("value is $value");
    if (value >= 0 && value <= 300) {
      print("if <300 value is ${(value * 0.145) / 300}");
      return (value * 0.145) / 300;
      //return 0.0;
    } else if (value > 300 && value <= 400) {
      //  print("value is ${(((value - 2) * 0.125) / (5 - 2)) + (1 * 0.125)}");

      print(
          "if <= 400 ${(((value - 300) * 0.145) / (400 - 300)) + (1 * 0.145)}");
      return (((value - 300) * 0.145) / (400 - 300)) + (1 * 0.145);
      // return (value * 0.125) / 400;
    } else if (value > 400 && value <= 500) {
      //print("value is ${(((value - 5) * 0.125) / (10 - 5)) + (2 * 0.125)}");
      //return (((value - 400) * 0.125) / (500 - 400)) + (2 * 0.125);
      print(
          "if <= 500 ${(((value - 400) * 0.145) / (500 - 400)) + (2 * 0.145)}");
      return (((value - 400) * 0.145) / (500 - 400)) + (2 * 0.145);
    } else if (value > 500 && value <= 600) {
      // print("value is ${(((value - 10) * 0.125) / (20 - 10)) + (3 * 0.125)}");
      //return (((value - 500) * 0.125) / (600 - 500)) + (3 * 0.125);
      print(
          "if <= 600 ${(((value - 500) * 0.145) / (600 - 500)) + (3 * 0.145)}");
      return (((value - 500) * 0.145) / (600 - 500)) + (3 * 0.145);
    } else if (value > 600 && value <= 700) {
      //  print("value is ${(((value - 20) * 0.125) / (30 - 20)) + (4 * 0.125)}");
      // return (((value - 600) * 0.125) / (700 - 600)) + (4 * 0.125);
      print(
          "if <= 700 ${(((value - 600) * 0.145) / (700 - 600)) + (4 * 0.145)}");
      return (((value - 600) * 0.145) / (700 - 600)) + (4 * 0.145);
    } else if (value > 700 && value <= 800) {
      // print("value is ${(((value - 30) * 0.125) / (50 - 30)) + (5 * 0.125)}");
      //  return (((value - 700) * 0.125) / (800 - 700)) + (5 * 0.125);
      print(
          "if <= 800 ${(((value - 700) * 0.145) / (800 - 700)) + (5 * 0.145)}");
      return (((value - 700) * 0.145) / (800 - 700)) + (5 * 0.145);
    } else if (value > 800 && value <= 900) {
      // print("value is ${(((value - 50) * 0.125) / (100 - 50)) + (6 * 0.125)}");
      //return (((value - 50) * 0.125) / (100 - 800)) + (6 * 0.125);
      print(
          "if <= 900 ${(((value - 800) * 0.145) / (900 - 800)) + (6 * 0.145)}");
      return (((value - 800) * 0.145) / (900 - 800)) + (6 * 0.145);
    } else {
      // print("value is 1}");
      return 1;
    }
  }

  /// To return the label value based on interval
  double _calculateLabelValue(num value) {
    if (value == 0) {
      return 0;
    } else if (value == 1) {
      return 300;
    } else if (value == 2) {
      return 400;
    } else if (value == 3) {
      return 500;
    } else if (value == 4) {
      return 600;
    } else if (value == 5) {
      return 700;
    } else if (value == 6) {
      return 800;
    } else {
      return 900;
    }
  }
}

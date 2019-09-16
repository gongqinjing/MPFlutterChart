import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mp_flutter_chart/chart/mp/chart/bar_chart.dart';
import 'package:mp_flutter_chart/chart/mp/core/data/bar_data.dart';
import 'package:mp_flutter_chart/chart/mp/core/data_set/bar_data_set.dart';
import 'package:mp_flutter_chart/chart/mp/core/description.dart';
import 'package:mp_flutter_chart/chart/mp/core/entry/bar_entry.dart';
import 'package:mp_flutter_chart/chart/mp/core/enums/legend_form.dart';
import 'package:mp_flutter_chart/chart/mp/core/enums/legend_horizontal_alignment.dart';
import 'package:mp_flutter_chart/chart/mp/core/enums/legend_orientation.dart';
import 'package:mp_flutter_chart/chart/mp/core/enums/legend_vertical_alignment.dart';
import 'package:mp_flutter_chart/chart/mp/core/utils/color_utils.dart';
import 'package:mp_flutter_chart/demo/action_state.dart';
import 'package:mp_flutter_chart/demo/util.dart';

class BarChartSine extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BarChartSineState();
  }
}

class BarChartSineState extends BarActionState<BarChartSine> {
  List<BarEntry> _data;
  var random = Random(1);
  int _count = 150;

  @override
  void initState() {
    Util.loadAsset("othersine.txt").then((value) {
      _data = List();
      List<String> lines = value.split("\n");
      for (int i = 0; i < lines.length; i++) {
        var datas = lines[i].split("#");
        var x = double.parse(datas[1]);
        var y = double.parse(datas[0]);
        _data.add(BarEntry(x: x, y: y));
      }
      _initBarData(_count);
      setState(() {});
    });

    _initBarData(_count);
    super.initState();
  }

  @override
  String getTitle() => "Bar Chart Sine";

  @override
  void chartInit() {
    _initBarChart();
  }

  @override
  Widget getBody() {
    return Stack(
      children: <Widget>[
        Positioned(
          right: 0,
          left: 0,
          top: 0,
          bottom: 100,
          child: barChart == null
              ? Center(child: Text("no data"))
              : barChart,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Center(
                        child: Slider(
                            value: _count.toDouble(),
                            min: 0,
                            max: 1500,
                            onChanged: (value) {
                              _count = value.toInt();
                              _initBarData(_count);
                              setState(() {});
                            })),
                  ),
                  Container(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Text(
                        "$_count",
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorUtils.BLACK,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  void _initBarData(int count) {
    if (_data == null) return;

    List<BarEntry> entries = List();
    for (int i = 0; i < count; i++) {
      entries.add(_data[i]);
    }

    BarDataSet set = BarDataSet(entries, "Sinus Function");
    set.setColor1(Color.fromARGB(255, 240, 120, 124));

    barData = BarData(List()..add(set));
    barData.setValueTextSize(10);
//    barData.setValueTypeface(tfLight);
    barData.setDrawValues(false);
    barData.setBarWidth(0.8);
  }

  void _initBarChart() {
    if (barData == null) return;

    var desc = Description();
    desc.setEnabled(false);
    barChart = BarChart(barData, (painter) {
      painter
        ..setDrawBarShadow(false)
        ..setDrawValueAboveBar(true);

      painter.mXAxis.setEnabled(false);

      painter.mAxisLeft
        ..setLabelCount2(6, false)
//        ..setTypeface(tf)
        ..setAxisMaximum(2.5)
        ..setAxisMinimum(-2.5)
        ..setGranularityEnabled(true)
        ..setGranularity(0.1);

      painter.mAxisRight
        ..setDrawGridLines(false)
//      ..setTypeface(tf)
        ..setLabelCount2(6, false)
        ..setAxisMinimum(-2.5)
        ..setAxisMaximum(2.5)
        ..setGranularity(0.1);

      painter.mLegend
        ..setVerticalAlignment(LegendVerticalAlignment.BOTTOM)
        ..setHorizontalAlignment(LegendHorizontalAlignment.LEFT)
        ..setOrientation(LegendOrientation.HORIZONTAL)
        ..setDrawInside(false)
        ..setForm(LegendForm.SQUARE)
        ..setFormSize(9)
        ..setTextSize(11)
        ..setXEntrySpace(4);

      painter.mAnimator.animateXY1(1500, 1500);
    },
        touchEnabled: true,
        drawGridBackground: false,
        dragXEnabled: true,
        dragYEnabled: true,
        scaleXEnabled: true,
        scaleYEnabled: true,
        pinchZoomEnabled: false,
        maxVisibleCount: 60,
        desc: desc);
  }
}

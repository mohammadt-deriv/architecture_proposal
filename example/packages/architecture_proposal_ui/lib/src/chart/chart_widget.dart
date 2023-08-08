import 'dart:math';

import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';
import 'package:flutter/material.dart';

const int yAxisCount = 5;
const int xAxisCount = 5;

class BasicChart extends StatelessWidget {
  const BasicChart({
    required this.ticks,
    Key? key,
    this.chartColor = Colors.orange,
  }) : super(key: key);

  final List<Tick> ticks;
  final Color chartColor;

  @override
  Widget build(BuildContext context) => ticks.length < 3
      ? const Center(child: CircularProgressIndicator())
      : Padding(
          padding: const EdgeInsets.only(right: 48),
          child: CustomPaint(
            painter: _BasicChartPainter(ticks, chartColor),
          ),
        );
}

class _BasicChartPainter extends CustomPainter {
  _BasicChartPainter(this.data, this.chartColor);

  final List<Tick> data;
  final Color chartColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double minX = data
        .reduce((Tick value, Tick element) =>
            value.epoch < element.epoch ? value : element)
        .epoch
        .toDouble();
    final double maxX = data
        .reduce((Tick value, Tick element) =>
            value.epoch > element.epoch ? value : element)
        .epoch
        .toDouble();
    final double minY = data
        .reduce((Tick value, Tick element) =>
            value.quote < element.quote ? value : element)
        .quote
        .toDouble();
    final double maxY = data
        .reduce((Tick value, Tick element) =>
            value.quote > element.quote ? value : element)
        .quote
        .toDouble();

    _drawAxes(canvas, size);
    _drawGrids(canvas, size);

    _drawChart(canvas, size, minX, maxX, minY, maxY);

    _drawLabels(canvas, size, minX, maxX, minY, maxY);
    _drawCurrentValue(canvas, size, minX, maxX, minY, maxY);
    _drawCurrentPoint(canvas, size, minX, maxX, minY, maxY);
  }

  void _drawAxes(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final Paint axisPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0;

    canvas
      ..drawLine(Offset(width, height), Offset(0, height), axisPaint)
      ..drawLine(Offset(width, 0), Offset(width, height), axisPaint);
  }

  void _drawGrids(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final Paint gridsPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 1.0;

    final double xGridInterval = width / (xAxisCount - 1);
    final double yGridInterval = height / yAxisCount;

    for (int i = 0; i < xAxisCount; i++) {
      final double x = i * xGridInterval;

      canvas.drawLine(Offset(x, 0), Offset(x, height), gridsPaint);
    }

    for (int i = 0; i <= yAxisCount; i++) {
      final double y = height - i * yGridInterval;

      canvas.drawLine(Offset(0, y), Offset(width, y), gridsPaint);
    }
  }

  void _drawChart(
    Canvas canvas,
    Size size,
    double minX,
    double maxX,
    double minY,
    double maxY,
  ) {
    final double width = size.width;
    final double height = size.height;

    final Paint pathPaint = Paint()
      ..color = chartColor.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final Paint areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          chartColor.withOpacity(0.3),
          chartColor.withOpacity(0.2),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTRB(0, 0, width, height));

    final Path path = Path();

    for (int i = 0; i < data.length; i++) {
      final Tick entity = data[i];

      final double x =
          width * ((entity.epoch.toDouble() - minX) / (maxX - minX));
      final double y = height * (1 - ((entity.quote - minY) / (maxY - minY)));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, pathPaint);

    final Path areaPath = Path.from(path)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    canvas.drawPath(areaPath, areaPaint);
  }

  void _drawLabels(
    Canvas canvas,
    Size size,
    double minX,
    double maxX,
    double minY,
    double maxY,
  ) {
    final double width = size.width;
    final double height = size.height;

    const TextStyle labelStyle = TextStyle(color: Colors.white, fontSize: 10);

    final double yAxisX = width - 1;

    final double yLabelInterval = (maxY - minY) / yAxisCount;

    for (int i = 0; i <= yAxisCount; i++) {
      final double labelValue = minY + (yLabelInterval * i);
      final String labelText = labelValue.toStringAsFixed(data.first.pipSize);

      final TextSpan labelSpan = TextSpan(
        text: labelText,
        style: labelStyle,
      );

      final TextPainter labelPainter = TextPainter(
        text: labelSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      final double labelX = yAxisX + labelPainter.width / 4;
      final double labelY =
          height - (i * (height / yAxisCount)) - (labelPainter.height / 2);

      labelPainter.paint(canvas, Offset(labelX, labelY));
    }

    final List<double> xLabels = <double>[];
    final double xLabelInterval = (maxX - minX) / (xAxisCount - 1);

    for (int i = 0; i < xAxisCount; i++) {
      final double labelValue = minX + (xLabelInterval * i);
      xLabels.add(labelValue);
    }

    const TextStyle xLabelStyle = TextStyle(
      color: Colors.white,
      fontSize: 10,
    );

    final double xGridInterval = width / (xAxisCount - 1);

    for (int i = 0; i < xLabels.length; i++) {
      final double labelValue = xLabels[i];
      final String labelText = labelValue.toInt().getFormattedTime;

      final TextSpan labelSpan = TextSpan(
        text: labelText,
        style: xLabelStyle,
      );

      final TextPainter labelPainter = TextPainter(
        text: labelSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      final double labelX = i * xGridInterval - labelPainter.width / 2;
      final double labelY = height + 4;

      canvas
        ..save()
        ..translate(labelX, labelY)
        ..rotate(pi / 8);

      labelPainter.paint(canvas, Offset.zero);

      canvas.restore();
    }
  }

  void _drawCurrentValue(
    Canvas canvas,
    Size size,
    double minX,
    double maxX,
    double minY,
    double maxY,
  ) {
    final double width = size.width;
    final double height = size.height;

    const TextStyle valueStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

    final TextSpan currentSpan = TextSpan(
      text: data.last.quote.toStringAsFixed(data.first.pipSize),
      style: valueStyle,
    );

    final TextPainter currentPainter = TextPainter(
      text: currentSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    const double valuePadding = 4;

    final double currentValueY =
        height * (1 - ((data.last.quote - minY) / (maxY - minY)));
    final double currentValueX = width - currentPainter.width - valuePadding;

    if (currentValueX.isNaN ||
        currentValueY.isNaN ||
        currentPainter.height.isNaN) return;
    currentPainter.paint(
      canvas,
      Offset(currentValueX, currentValueY - currentPainter.height),
    );
  }

  void _drawCurrentPoint(
    Canvas canvas,
    Size size,
    double minX,
    double maxX,
    double minY,
    double maxY,
  ) {
    final double width = size.width;
    final double height = size.height;

    final Paint currentPointPaint = Paint()
      ..color = chartColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    final double currentPointX =
        width * ((data.last.epoch.toDouble() - minX) / (maxX - minX));
    final double currentPointY =
        height * (1 - ((data.last.quote - minY) / (maxY - minY)));

    canvas.drawCircle(
      Offset(currentPointX, currentPointY),
      4,
      currentPointPaint,
    );
  }

  @override
  bool shouldRepaint(_BasicChartPainter oldDelegate) =>
      oldDelegate.data != data;
}

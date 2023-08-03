import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';
import 'package:architecture_proposal_ui/src/chart/chart_widget.dart';
import 'package:architecture_proposal_ui/src/market_price/tick_stream_widget/tick_stream_builder.dart';
import 'package:flutter/material.dart';

class ChartLayout extends StatelessWidget {
  const ChartLayout({required this.tickStreamManager, super.key});

  final TickStreamManager tickStreamManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: TickStreamBuilder(
          manager: tickStreamManager,
          builder: (context, state) => SizedBox(
            width: double.infinity,
            height: 128,
            child: BasicChart(ticks: state.getTicks),
          ),
        ),
      ),
    );
  }
}

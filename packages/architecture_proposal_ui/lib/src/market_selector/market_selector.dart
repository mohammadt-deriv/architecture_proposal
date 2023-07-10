import 'package:architecture_proposal_ui/src/market_selector/market_selector_cubit.dart';
import 'package:architecture_proposal_ui/src/market_selector/market_selector_state.dart';
import 'package:flutter/material.dart';

import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarketSelector extends StatefulWidget {
  const MarketSelector({
    required this.activeSymbolsFetcher,
    required this.onActiveSymbolChanged,
    super.key,
  });

  final ActiveSymbolsFetcher activeSymbolsFetcher;
  final void Function(ActiveSymbol symbol) onActiveSymbolChanged;

  @override
  State<MarketSelector> createState() => _MarketSelectorState();
}

class _MarketSelectorState extends State<MarketSelector> {
  late final MarketSelectorCubit _cubit;

  @override
  void initState() {
    _cubit = MarketSelectorCubit(fetcher: widget.activeSymbolsFetcher)
      ..onInit();

    super.initState();
  }

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: BlocConsumer<MarketSelectorCubit, MarketSelectorState>(
          bloc: _cubit,
          listener: _onNewState,
          builder: (context, state) => state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : DropdownButton<ActiveSymbol>(
                  isExpanded: true,
                  underline: Container(),
                  value: state.selectedSymbol,
                  items: state.activeSymbols
                      .map(
                        (ActiveSymbol activeSymbol) =>
                            DropdownMenuItem<ActiveSymbol>(
                          value: activeSymbol,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              activeSymbol.symbolDisplayName,
                              style: TextStyle(
                                fontWeight: activeSymbol == state.selectedSymbol
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: _cubit.onSymbolSelected,
                ),
        ),
      );

  void _onNewState(BuildContext context, MarketSelectorState state) {
    if (state is MarketSelectorSelectedState) {
      widget.onActiveSymbolChanged(state.selectedActiveSymbol);
    }

    if (state is MarketSelectorErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage),
        ),
      );
    }
  }
}

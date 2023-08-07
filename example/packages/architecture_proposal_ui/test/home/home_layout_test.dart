import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';
import 'package:architecture_proposal_ui/architecture_proposal_ui.dart';
import 'package:architecture_proposal_ui/src/market_selector/market_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ActiveSymbolFetcherMock extends Mock implements ActiveSymbolsFetcher {}

class TickStreamManagerMock extends Mock implements TickStreamManager {}

class AuthManagerMock extends Mock implements AuthManager {}

class ActiveSymbolFake extends Fake implements ActiveSymbol {}

void main() {
  group('HomeLayout ', () {
    late ActiveSymbolFetcherMock activeSymbolsFetcher;
    late TickStreamManagerMock tickStreamManager;
    late AuthManagerMock authManager;

    setUp(() {
      activeSymbolsFetcher = ActiveSymbolFetcherMock();
      tickStreamManager = TickStreamManagerMock();
      authManager = AuthManagerMock();

      registerFallbackValue(ActiveSymbolFake());

      when(() => activeSymbolsFetcher.fetchAllSymbols())
          .thenAnswer((_) => Future.value([
                ActiveSymbol(
                  symbol: 'symbol',
                  market: 'market',
                  marketDisplayName: 'marketDisplayName',
                  symbolDisplayName: 'symbolDisplayName',
                )
              ]));

      when(() => tickStreamManager.currentState)
          .thenReturn(TickStreamInitialState());
      when(() => tickStreamManager.stateSteam)
          .thenAnswer((_) => Stream.value(TickStreamInitialState()));
      when(() => tickStreamManager.tickStream)
          .thenAnswer((_) => Stream.value([]));

      final user = User(email: 'email');
      when(() => authManager.currentUser).thenReturn(user);
      when(() => authManager.currentState).thenReturn(AuthLoggedInState(user));
      when(() => authManager.authStateStream)
          .thenAnswer((_) => Stream.value(AuthLoggedInState(user)));
    });

    testWidgets('should layout all necessary widgets at initial state',
        (widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(
          home: HomeLayout(
            activeSymbolsFetcher: activeSymbolsFetcher,
            tickStreamManager: tickStreamManager,
            authManager: authManager,
            onLoggedOut: () {},
            onError: (error) {},
            chartFeatureEnabled: true,
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Logged in as: email'), findsOneWidget);

      expect(find.byType(MarketSelector), findsOneWidget);
      expect(find.byType(MarketPriceViewer), findsOneWidget);
      expect(find.text('Show Chart'), findsOneWidget);
    });
    testWidgets('Should be able to select market and see its price',
        (widgetTester) async {
      final loadedState = TickStreamLoadedState(
          tickSubscriptionId: '',
          state: TickState.none,
          ticks: [
            Tick(
              id: 'id',
              epoch: DateTime.now().millisecondsSinceEpoch,
              quote: 20,
              symbol: 'symbol',
              pipSize: 1,
            )
          ]);

      final stateStream = Stream.value(loadedState).asBroadcastStream();
      when(() => tickStreamManager.currentState).thenReturn(loadedState);
      when(() => tickStreamManager.stateSteam).thenAnswer((_) => stateStream);
      when(() => tickStreamManager.tickStream).thenAnswer(
          (_) => stateStream.map((event) => event.ticks).asBroadcastStream());

      await widgetTester.pumpWidget(
        MaterialApp(
          home: HomeLayout(
            activeSymbolsFetcher: activeSymbolsFetcher,
            tickStreamManager: tickStreamManager,
            authManager: authManager,
            onLoggedOut: () {},
            onError: (error) {},
            chartFeatureEnabled: true,
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      expect(find.text('Please select an active symbol.'), findsOneWidget);

      await widgetTester.tap(find.byType(MarketSelector));
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.text('symbolDisplayName'));
      await widgetTester.pumpAndSettle();

      expect(find.text('Please select an active symbol.'), findsNothing);
      expect(find.text('symbolDisplayName'), findsWidgets);

      verify(() => tickStreamManager.loadTickStream(any())).called(1);

      expect(find.text('20.0'), findsOneWidget);
    });
  });
}

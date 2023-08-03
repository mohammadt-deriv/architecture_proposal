import 'package:architecture_proposal_data/architecture_proposal_data.dart';
import 'package:architecture_proposal_ui/architecture_proposal_ui.dart';
import 'package:flutter/material.dart';

import 'package:architecture_proposal/router.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) => SplashLayout(
        authManager: context.read<AuthCubit>(),
        onUserExist: (user) => context.goHome(),
        onNewUser: () => context.goAuth(),
      );
}

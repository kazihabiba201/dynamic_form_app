

import 'package:dynamic_form_app/core/routes/routes.dart';
import 'package:dynamic_form_app/presentation/screens/form_list_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RoutePaths.FORMLIST,
  routes: [
    GoRoute(
      path: RoutePaths.FORMLIST,
      name: RouteName.FORMLIST,
      builder: (context, state) => const FormListScreen(),
    ),

  ],
);

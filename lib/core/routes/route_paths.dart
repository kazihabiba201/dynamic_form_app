import 'package:dynamic_form_app/core/routes/routes.dart';
import 'package:dynamic_form_app/presentation/screens/form_list_screen.dart';
import 'package:dynamic_form_app/presentation/screens/form_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RoutePaths.formList,
  routes: [
    GoRoute(path: RoutePaths.formList, name: RouteName.formList, builder: (context, state) => const FormListScreen()),

    GoRoute(path: RoutePaths.fORM, name: RouteName.fORM, builder: (context, state) => const FormScreen()),
  ],
);

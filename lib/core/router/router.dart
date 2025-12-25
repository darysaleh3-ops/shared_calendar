import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/auth_controller.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/groups/presentation/group_list_screen.dart';
import '../../features/calendar/presentation/calendar_screen.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(RouterRef ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/groups',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isAuthRoute =
          state.uri.path == '/login' || state.uri.path == '/register';

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/groups';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/groups',
        builder: (context, state) => const GroupListScreen(),
        routes: [
          GoRoute(
            path: ':groupId/calendar',
            builder: (context, state) {
              final groupId = state.pathParameters['groupId']!;
              return CalendarScreen(groupId: groupId);
            },
          ),
        ],
      ),
    ],
  );
}

import 'package:clockify_miniproject/core/router/router_constants.dart';
import 'package:clockify_miniproject/features/activity/data/models/activity_hive_model.dart';
import 'package:clockify_miniproject/features/activity/presentation/screen/history_screen.dart';
import 'package:clockify_miniproject/features/activity/presentation/screen/timer_screen.dart';
import 'package:clockify_miniproject/features/auth/presentation/login_screen.dart';
import 'package:clockify_miniproject/features/auth/presentation/password_screen.dart';
import 'package:clockify_miniproject/features/auth/presentation/register_screen.dart';
import 'package:clockify_miniproject/features/detail/presentation/screen/detail_screen.dart';
import 'package:clockify_miniproject/features/loading/presentation/loading_screen.dart';
import 'package:clockify_miniproject/features/loading/presentation/loading_to_content_screen.dart';
import 'package:go_router/go_router.dart';

late GoRouter _router;
GoRouter get router => _router;

setupRouter({required String initialRoute}){
  _router = GoRouter(
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        path:'/',
        name: routes.loading,
        builder: (context, state) => const LoadingScreen()
      ),
      GoRoute(
        path:'/loading_content',
        name: routes.loadingToContent,
        builder: (context, state) => LoadingContentScreen(
          credentials : state.extra as Map<String, String>
        )
      ),
      GoRoute(
        path: '/login',
        name: routes.login,
        builder: (context, state) => const LoginScreen()
      ),
      GoRoute(
        path: '/register',
        name: routes.register,
        builder: (context, state) => const RegisterScreen()
      ),
      GoRoute(
        path: '/password',
        name: routes.password,
        builder: (context, state) => PasswordScreen(
          email: state.extra as String,
        )
      ),
      GoRoute(
        path: '/timer',
        name : routes.timer,
        builder: (context, state) => ContentScreen()
      ),
      GoRoute(
        path: '/activity',
        name : routes.activity,
        builder: (context, state) => ActivityScreen()
      ),
      GoRoute(
        path: '/detail',
        name: routes.detail,
        builder: (context, state) => DetailScreen(
          activity: state.extra as ActivityHive,
        )
      )
    ],

  );
}
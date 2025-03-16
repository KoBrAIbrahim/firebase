import 'package:app/pages/LiveProductFeed.dart';
import 'package:app/pages/product_list_page.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/add_product_page.dart';

class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => LoginPage()),
        GoRoute(path: '/register', builder: (context, state) => RegisterPage()),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => DashboardPage(),
        ),
        GoRoute(
          path: '/add-product',
          builder: (context, state) => AddProductPage(),
        ),
        GoRoute(
          path: '/products',
          builder: (context, state) => const ProductListPage(),
        ),
        GoRoute(
          path: '/live-feed',
          builder: (context, state) => const LiveProductFeedPage(),
        ),
      ],
      redirect: (context, state) {
        final user = Provider.of<UserProvider>(context, listen: false).user;
        final isLoggingIn =
            state.matchedLocation == '/' ||
            state.matchedLocation == '/register';

        if (user == null && !isLoggingIn) return '/';
        if (user != null && isLoggingIn) return '/dashboard';
        return null;
      },
    );
  }
}
/*




*/
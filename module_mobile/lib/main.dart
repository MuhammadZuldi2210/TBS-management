// flutter material
import 'package:flutter/material.dart';

// provider
import 'package:provider/provider.dart';

// app
import 'app/app.dart';

// dio client
import 'core/api/dio_client.dart';

// auth provider
import 'features/auth/viewmodels/auth_provider.dart';

// admin provider
import 'features/admin_management/viewmodels/admin_provider.dart';

// import dashboard provider
import 'features/dashboard/super_admin/viewmodels/dashboard_provider.dart';

// import dashboard provider admin
import 'features/dashboard/admin_user/viewmodels/dashboard_provider.dart';

// import dashboard provider reseller
import 'features/dashboard/reseller/viewmodels/dashboard_provider.dart';

// import user management provider
import 'features/user_management/viewmodels/user_management_provider.dart';

// import profile provider
import 'features/profile/viewmodels/profile_provider.dart';

// transaction provider
import 'features/transaction/viewmodels/transaction_provider.dart';

// reseller provider
import 'features/reseller_management/viewmodels/reseller_provider.dart';

// notification provider
import 'features/notification/viewmodels/notification_provider.dart';

// coin provider
import 'features/coin/viewmodels/coin_provider.dart';

void main() {
  // init dio interceptor
  DioClient.init();

  runApp(
    MultiProvider(
      providers: [
        // auth provider
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // admin provider
        ChangeNotifierProvider(create: (_) => AdminProvider()),

        // dashboard super admin
        ChangeNotifierProvider(create: (_) => DashboardProvider()),

        // dashboard admin
        ChangeNotifierProvider(create: (_) => AdminDashboardProvider()),

        // dashboard reseller
        ChangeNotifierProvider(create: (_) => ResellerDashboardProvider()),

        // user management provider
        ChangeNotifierProvider(create: (_) => UserManagementProvider()),

        // reseller provider
        ChangeNotifierProvider(create: (_) => ResellerProvider()),

        // profile provider
        ChangeNotifierProvider(create: (_) => ProfileProvider()),

        // transaction provider
        ChangeNotifierProvider(create: (_) => TransactionProvider()),

        // notification provider
        ChangeNotifierProvider(create: (_) => NotificationProvider()),

        // coin provider
        ChangeNotifierProvider(create: (_) => CoinProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

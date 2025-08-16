import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../../../theme/app_theme.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;
  final String redirectRoute;

  const AuthGuard({
    super.key,
    required this.child,
    this.redirectRoute = '/login',
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, _) {
        // Check if user is logged in
        if (authController.token == null) {
          // User not logged in, redirect to login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              redirectRoute,
              (route) => false,
            );
          });
          
          // Show loading screen while redirecting
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: AppSpacing.md),
                    Text(
                      'Checking authentication...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // User is logged in, show protected content
        return child;
      },
    );
  }
}

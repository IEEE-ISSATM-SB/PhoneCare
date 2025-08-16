import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../../../theme/app_theme.dart';

class DebugAuthScreen extends StatefulWidget {
  const DebugAuthScreen({super.key});

  @override
  State<DebugAuthScreen> createState() => _DebugAuthScreenState();
}

class _DebugAuthScreenState extends State<DebugAuthScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  String _debugOutput = '';
  bool _isTesting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _addDebugOutput(String message) {
    setState(() {
      _debugOutput += '${DateTime.now().toString().substring(11, 19)}: $message\n';
    });
  }

  Future<void> _testRegistration() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _addDebugOutput('❌ Please fill in all fields for registration test');
      return;
    }

    setState(() {
      _isTesting = true;
    });

    _addDebugOutput('🔄 Testing registration...');
    _addDebugOutput('   Name: ${_nameController.text}');
    _addDebugOutput('   Email: ${_emailController.text}');
    _addDebugOutput('   Password: ${_passwordController.text}');

    try {
      final success = await context.read<AuthController>().register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success) {
        _addDebugOutput('✅ Registration successful!');
      } else {
        _addDebugOutput('❌ Registration failed');
      }
    } catch (e) {
      _addDebugOutput('❌ Registration error: ${e.toString()}');
    }

    setState(() {
      _isTesting = false;
    });
  }

  Future<void> _testLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _addDebugOutput('❌ Please fill in email and password for login test');
      return;
    }

    setState(() {
      _isTesting = true;
    });

    _addDebugOutput('🔄 Testing login...');
    _addDebugOutput('   Email: ${_emailController.text}');
    _addDebugOutput('   Password: ${_passwordController.text}');

    try {
      final success = await context.read<AuthController>().login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success) {
        _addDebugOutput('✅ Login successful!');
      } else {
        _addDebugOutput('❌ Login failed');
      }
    } catch (e) {
      _addDebugOutput('❌ Login error: ${e.toString()}');
    }

    setState(() {
      _isTesting = false;
    });
  }

  void _clearDebugOutput() {
    setState(() {
      _debugOutput = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Authentication'),
        backgroundColor: AppTheme.warningColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearDebugOutput,
            tooltip: 'Clear Debug Output',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundColor,
              AppTheme.surfaceColor,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Test Form
              _buildTestForm(),
              
              const SizedBox(height: AppSpacing.lg),
              
              // Debug Output
              _buildDebugOutput(),
              
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test Credentials',
              style: AppTextStyles.heading3,
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
                hintText: 'Enter test name',
              ),
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Email Field
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                hintText: 'Enter test email',
              ),
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Password Field
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                hintText: 'Enter test password',
              ),
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Confirm Password Field
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: Icon(Icons.lock),
                hintText: 'Confirm test password',
              ),
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Test Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isTesting ? null : _testRegistration,
                    style: AppButtonStyles.successButton,
                    child: _isTesting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Test Registration'),
                  ),
                ),
                
                const SizedBox(width: AppSpacing.md),
                
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isTesting ? null : _testLogin,
                    style: AppButtonStyles.primaryButton,
                    child: _isTesting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Test Login'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Quick Fill Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _nameController.text = 'Test User';
                      _emailController.text = 'test@example.com';
                      _passwordController.text = 'password123';
                      _confirmPasswordController.text = 'password123';
                      _addDebugOutput('📝 Filled with test data');
                    },
                    child: const Text('Fill Test Data'),
                  ),
                ),
                
                const SizedBox(width: AppSpacing.md),
                
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _nameController.clear();
                      _emailController.clear();
                      _passwordController.clear();
                      _confirmPasswordController.clear();
                      _addDebugOutput('🗑️ Cleared all fields');
                    },
                    child: const Text('Clear All'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebugOutput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Debug Output',
                  style: AppTextStyles.heading3,
                ),
                const Spacer(),
                Text(
                  '${_debugOutput.split('\n').length - 1} messages',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            Container(
              width: double.infinity,
              height: 300,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                border: Border.all(color: AppTheme.dividerColor),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _debugOutput.isEmpty ? 'No debug output yet...' : _debugOutput,
                  style: const TextStyle(
                    color: Colors.green,
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Error Display
            Consumer<AuthController>(
              builder: (context, authController, child) {
                if (authController.error != null) {
                  return Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      border: Border.all(
                        color: AppTheme.errorColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppTheme.errorColor,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            authController.error!,
                            style: TextStyle(
                              color: AppTheme.errorColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}


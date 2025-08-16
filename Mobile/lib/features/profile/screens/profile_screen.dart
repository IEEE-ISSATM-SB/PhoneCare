import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/profile_controller.dart';
import '../../../theme/app_theme.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _showPasswordFields = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileController>().initializeProfile();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await context.read<ProfileController>().updateProfile(
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New passwords do not match!'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    final success = await context.read<ProfileController>().changePassword(
      _currentPasswordController.text,
      _newPasswordController.text,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password changed successfully!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
      _showPasswordFields = false;
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ProfileController>().refreshProfile(),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                context.read<AuthController>().logout(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AppTheme.errorColor),
                    SizedBox(width: AppSpacing.sm),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
            child: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Consumer<ProfileController>(
        builder: (context, profileController, child) {
          if (profileController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Initialize form fields with current profile data
          if (profileController.userProfile != null) {
            _nameController.text = profileController.userProfile!['name'] ?? '';
            _phoneController.text = profileController.userProfile!['phoneNumber'] ?? '';
          }

          return RefreshIndicator(
            onRefresh: () => profileController.refreshProfile(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Picture Section
                    _buildProfilePictureSection(profileController),
                    
                    const SizedBox(height: AppSpacing.lg),
                    
                    // Error Message
                    if (profileController.error != null)
                      _buildErrorCard(profileController),
                    
                    const SizedBox(height: AppSpacing.md),
                    
                    // Profile Information Section
                    _buildProfileInfoSection(profileController),
                    
                    const SizedBox(height: AppSpacing.lg),
                    
                    // Password Change Section
                    _buildPasswordChangeSection(profileController),
                    
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfilePictureSection(ProfileController profileController) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // Profile Picture
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryColor,
                  width: 4,
                ),
              ),
              child: ClipOval(
                child: profileController.profilePictureUrl != null
                    ? Image.network(
                        profileController.profilePictureUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildDefaultAvatar(),
                      )
                    : _buildDefaultAvatar(),
              ),
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Profile Picture Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // TODO: Implement image picker when dependency is added
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Image picker coming soon!'),
                        backgroundColor: AppTheme.warningColor,
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Change Photo'),
                ),
                if (profileController.profilePictureUrl != null)
                  TextButton.icon(
                    onPressed: () async {
                      final success = await profileController.deleteProfilePicture();
                      if (success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile picture removed'),
                            backgroundColor: AppTheme.warningColor,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Remove'),
                    style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppTheme.primaryColor.withOpacity(0.1),
      child: Icon(
        Icons.person,
        size: 60,
        color: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildErrorCard(ProfileController profileController) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: AppTheme.errorColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppTheme.errorColor),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              profileController.error!,
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: AppTheme.errorColor),
            onPressed: profileController.clearError,
            iconSize: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoSection(ProfileController profileController) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: AppSpacing.md),
            
            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person),
                hintText: 'Enter your full name',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                if (value.trim().length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Phone Number Field
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
                hintText: 'Enter your phone number',
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (value.length < 10) {
                    return 'Please enter a valid phone number';
                  }
                }
                return null;
              },
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Update Profile Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: profileController.isUpdating ? null : _updateProfile,
                style: AppButtonStyles.primaryButton,
                child: profileController.isUpdating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Update Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordChangeSection(ProfileController profileController) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Change Password',
                  style: AppTextStyles.heading3,
                ),
                const Spacer(),
                Switch(
                  value: _showPasswordFields,
                  onChanged: (value) {
                    setState(() {
                      _showPasswordFields = value;
                      if (!value) {
                        _currentPasswordController.clear();
                        _newPasswordController.clear();
                        _confirmPasswordController.clear();
                      }
                    });
                  },
                ),
              ],
            ),
            
            if (_showPasswordFields) ...[
              const SizedBox(height: AppSpacing.md),
              
              // Current Password Field
              TextFormField(
                controller: _currentPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Enter your current password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              // New Password Field
              TextFormField(
                controller: _newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  hintText: 'Enter your new password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              // Confirm Password Field
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  hintText: 'Confirm your new password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              // Change Password Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: profileController.isUpdating ? null : _changePassword,
                  style: AppButtonStyles.successButton,
                  child: profileController.isUpdating
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Change Password'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

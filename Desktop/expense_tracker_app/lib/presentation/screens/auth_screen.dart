import 'package:expense_tracker_app/core/widgets/constants/controller.dart';
import 'package:expense_tracker_app/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart'; // Import the home screen

class AuthScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text('Authentication'),
            backgroundColor: theme.primaryColor,
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        filled: true,
                        fillColor: theme.cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon:
                            Icon(Icons.email, color: theme.iconTheme.color),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: theme.cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon:
                            Icon(Icons.lock, color: theme.iconTheme.color),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Conditional buttons (Login/Logout)
                    if (userProvider.isLoggedIn)
                      ElevatedButton(
                        onPressed: () async {
                          await userProvider.logout(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Logged out successfully')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              theme.colorScheme.error, // Use theme error color
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 40),
                        ),
                        child:
                            Text('Logout', style: theme.textTheme.labelLarge),
                      )
                    else ...[
                      // Login Button
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String email = emailController.text;
                            String password = passwordController.text;

                            await userProvider.login(email, password);
                            if (userProvider.isLoggedIn) {
                              // Navigate to the home screen on successful login
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()),
                              );
                            } else {
                              // Show error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(userProvider.statusMessage)),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              theme.primaryColor,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 40),
                        ),
                        child: Text('Login', style: theme.textTheme.labelLarge),
                      ),
                      const SizedBox(height: 10),

                      // Register Button
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String email = emailController.text;
                            String password = passwordController.text;

                            await userProvider.register(email, password);
                            if (userProvider.statusMessage ==
                                'Registration successful!') {
                              // Optionally navigate to the login screen after successful registration
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Registration Successful!')),
                              );
                            } else {
                              // Show error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(userProvider.statusMessage)),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.secondary,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 40),
                        ),
                        child:
                            Text('Register', style: theme.textTheme.labelLarge),
                      ),
                    ],

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

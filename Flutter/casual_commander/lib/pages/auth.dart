import 'package:flutter/material.dart';
import 'deck_manager.dart';

Future<bool> showAuthDialog(BuildContext context) async {
  final manager = DeckManager.instance;

  return await showDialog<bool>(
        context: context,
        builder: (context) {
          if (manager.currentUserEmail != null) {
            final email = manager.currentUserEmail!;
            return AlertDialog(
              title: const Text('User'),
              content: Text('Signed in as: $email'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Close'),
                ),
                TextButton(
                  onPressed: () async {
                    await manager.signOut();
                    Navigator.pop(context, true);
                  },
                  child: const Text('Sign out'),
                ),
              ],
            );
          }

          final emailController = TextEditingController();
          final passwordController = TextEditingController();
          bool isSignIn = true;
          String? error;

          return StatefulBuilder(builder: (context, setState) {
            Future<void> tryAuth() async {
              final email = emailController.text.trim();
              final pw = passwordController.text;
              bool ok = false;
              if (isSignIn) {
                ok = await manager.signIn(email, pw);
              } else {
                ok = await manager.signUp(email, pw);
              }
              if (ok) {
                Navigator.pop(context, true);
              } else {
                setState(() {
                  error = isSignIn ? 'Sign in failed' : 'Sign up failed';
                });
              }
            }

            return AlertDialog(
              title: Text(isSignIn ? 'Sign In' : 'Sign Up'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(hintText: 'Email'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(hintText: 'Password'),
                    ),
                    const SizedBox(height: 8),
                    if (error != null)
                      Text(error!, style: const TextStyle(color: Colors.red)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isSignIn = !isSignIn;
                              error = null;
                            });
                          },
                          child: Text(isSignIn ? 'Create account' : 'Have an account?'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: tryAuth,
                          child: Text(isSignIn ? 'Sign In' : 'Sign Up'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        },
      ) ??
      false;
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/async_value_widget.dart';
import '../../../auth/domain/entities/waiter.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _restaurantController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _restaurantController,
              decoration:
                  const InputDecoration(labelText: 'Restaurant (optional)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(authProvider.notifier).signIn(
                      _usernameController.text,
                      _passwordController.text,
                      _restaurantController.text.isEmpty
                          ? null
                          : _restaurantController.text,
                    );
              },
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 20),
            AsyncValueWidget<Waiter?>(
              value: authState,
              data: (waiter) => waiter != null
                  ? Text('Welcome, ${waiter.username}!')
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

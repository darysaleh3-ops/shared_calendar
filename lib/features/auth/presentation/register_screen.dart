import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_controller.dart';
import '../../../l10n/manual_localizations.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.registerTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.nameLabel),
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)!.enterNameError
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.emailLabel),
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)!.enterEmailError
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.passwordLabel),
                obscureText: true,
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)!.enterPasswordError
                    : null,
              ),
              const SizedBox(height: 24),
              if (state.isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ref.read(authControllerProvider.notifier).register(
                            _emailController.text,
                            _passwordController.text,
                            _nameController.text,
                          );
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.registerButton),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

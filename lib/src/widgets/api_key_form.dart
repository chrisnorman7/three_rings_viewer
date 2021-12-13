/// Provides the [ApiKeyForm].
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../intents.dart';
import '../json/preferences.dart';
import 'home_page.dart';

/// A form for entering an API key.
class ApiKeyForm extends StatefulWidget {
  /// Create an instance.
  const ApiKeyForm({Key? key}) : super(key: key);

  /// The route name.
  static const routeName = '/api_key';

  /// Create state for this widget.
  @override
  _ApiKeyFormState createState() => _ApiKeyFormState();
}

/// State for [ApiKeyForm].
class _ApiKeyFormState extends State<ApiKeyForm> {
  /// The form key.
  late final GlobalKey<FormState> _formKey;

  /// The controller for the API key text field.
  late final TextEditingController _apiKeyController;

  /// Initialise stuff.
  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _apiKeyController = TextEditingController();
  }

  /// Destroy the controller.
  @override
  void dispose() {
    super.dispose();
    _apiKeyController.dispose();
  }

  /// Build a widget.
  @override
  Widget build(BuildContext context) {
    final preferences =
        ModalRoute.of(context)!.settings.arguments as Preferences;
    _apiKeyController.text = preferences.apiKey ?? '';
    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.escape): CancelIntent()
      },
      child: Actions(
        actions: {
          CancelIntent: CallbackAction(
            onInvoke: (intent) => cancel(),
          )
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.cancel_rounded),
              onPressed: cancel,
              tooltip: 'Cancel',
            ),
            title: const Text('API Key'),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    preferences.apiKey = _apiKeyController.text;
                    await preferences
                        .save(await SharedPreferences.getInstance());
                    Navigator.of(context)
                        .pushReplacementNamed(HomePage.routeName);
                  }
                },
                tooltip: 'Save',
              )
            ],
          ),
          body: Form(
            key: _formKey,
            child: Center(
              child: TextFormField(
                autocorrect: false,
                autofocus: true,
                controller: _apiKeyController,
                decoration: const InputDecoration(labelText: 'API Key'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Cancel this window.
  void cancel() =>
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
}

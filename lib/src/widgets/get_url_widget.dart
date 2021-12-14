/// Provides the [GetUrlWidget] class.
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// A widget that will get a URL.
class GetUrlWidget extends StatefulWidget {
  /// Create an instance.
  const GetUrlWidget({required this.future, required this.onLoad, Key? key})
      : super(key: key);

  /// The future to be used by the state.
  final Future<Response<Map<String, dynamic>>> future;

  /// What to do with the loaded JSON.
  final Widget Function(Map<String, dynamic>? json) onLoad;

  /// Create state for this widget.
  @override
  _GetUrlWidgetState createState() => _GetUrlWidgetState();
}

/// State for [GetUrlWidget].
class _GetUrlWidgetState extends State<GetUrlWidget> {
  /// Build a widget.
  @override
  Widget build(BuildContext context) =>
      FutureBuilder<Response<Map<String, dynamic>>>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.requireData;
            return widget.onLoad(data.data);
          } else if (snapshot.hasError) {
            return ListView(
              children: [
                FocusableActionDetector(
                  child: ListTile(
                    title: const Text('Error'),
                    subtitle: Text(snapshot.error.toString()),
                  ),
                ),
                FocusableActionDetector(
                  child: ListTile(
                    title: const Text('Stacktrace'),
                    subtitle: Text(snapshot.stackTrace.toString()),
                  ),
                )
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'Loading...',
              ),
            );
          }
        },
        future: widget.future,
      );
}

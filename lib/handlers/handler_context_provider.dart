import 'package:flutter/widgets.dart';

/// **EXPLANATION**:
/// - [HandlerContextProvider] is a mixin that facilitates accessing the [BuildContext] within a class that extends [StatefulWidget].
///
/// - It includes a method `getBuildContext()` that returns the current [BuildContext].
///
/// - This mixin is intended to be used with classes that extend [StatefulWidget] to provide easy access to the [BuildContext].
///
/// Mixin that provides a way to access the [BuildContext] within a [StatefulWidget].
mixin HandlerContextProvider<T extends StatefulWidget> on State<T> {
  // Get the current BuildContext
  BuildContext? getBuildContext() {
    return context;
  }
}

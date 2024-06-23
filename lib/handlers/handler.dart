import 'handler_context_provider.dart';

/// **Explanation:**

/// - [Handler] is an abstract class designed to be a base for various handlers in the application.
///
/// - It includes methods for initialization (`init`) and disposal (`dispose`).
///
/// - The `init` method is used to set the `contextProvider`, allowing handlers to access the current `BuildContext`.
///
/// - The `dispose` method clears the `contextProvider` when the handler is being disposed.
/// Abstract class that serves as a base for different handlers in the application.
abstract class Handler {
  HandlerContextProvider? contextProvider;

  // Initialize the handler with the context provider
  void init(HandlerContextProvider contextProvider) {
    this.contextProvider = contextProvider;
  }

  // Dispose of the handler
  void dispose() {
    contextProvider = null;
  }
}

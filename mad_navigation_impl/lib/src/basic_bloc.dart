import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

/// A type alias for async event handlers in [BasicBloc].
///
/// Represents a function that takes an event of type [Event] and returns
/// a stream of states of type [State].
typedef AsyncEventHandler<Event, State> = Stream<State> Function(Event event);

/// A base class for BLoC instances that provides common functionality and utilities.
///
/// This class extends [Bloc] from the `bloc` package and adds support for:
/// - Async event handling with [onAsync]
/// - Automatic stream seeding with [streamSeeded]
/// - Type-safe event handler registration
///
/// ```
/// abstract class CounterEvent {}
///
/// final class IncrementEvent extends CounterEvent {}
/// final class DecrementEvent extends CounterEvent {}
///
/// class CounterBloc extends BasicBloc<CounterEvent, int> {
///   CounterBloc() : super(0);
///
///   @override
///   void setEventHandlers() {
///     on<IncrementEvent>(_onIncrement);
///     onAsync<DecrementEvent>(_onDecrement);
///   }
///
///   Future<void> _onIncrement(IncrementEvent event, Emitter<int> emit) async {
///     emit(state + 1);
///   }
///
///   Stream<int> _onDecrement(DecrementEvent event) async* {
///     yield state - 1;
///   }
/// }
abstract class BasicBloc<Event, State> extends Bloc<Event, State> {
  /// Creates a new [BasicBloc] with the given [initialState].
  ///
  /// The [setEventHandlers] method will be called during initialization.
  BasicBloc(State initialState) : super(initialState) {
    setEventHandlers();
    init();
  }

  /// Tracks registered event handler types to prevent duplicate registrations.
  final Set<Type> _eventHandlerTypes = <Type>{};

  /// A broadcast stream that automatically emits the current state to new subscribers.
  ///
  /// This is useful for widgets that need to react to state changes but don't
  /// need to handle the initial state differently.
  late final Stream<State> streamSeeded =
      stream.publishValueSeeded(state).autoConnect();

  /// Sets up event handlers for this bloc.
  ///
  /// Subclasses should override this method to register their event handlers
  /// using the [onAsync] method.
  void setEventHandlers();

  /// Called after the bloc is initialized.
  ///
  /// Subclasses can override this method to perform additional initialization.
  Future<void> init() async {}

  /// Register event handler for an event of type `E`.
  /// There should only ever be one event handler per event type `E`.
  void onAsync<E extends Event>(
    AsyncEventHandler<E, State> handler, {
    Stream<E> Function(Stream<E>, Stream<E> Function(E))? transformer,
  }) {
    // Prevent duplicate event handler registration
    if (!_eventHandlerTypes.add(E)) return;

    on<E>((E event, Emitter<State> emit) async {
      await for (final State state in handler(event)) {
        emit(state);
      }
    }, transformer: transformer);
  }
}

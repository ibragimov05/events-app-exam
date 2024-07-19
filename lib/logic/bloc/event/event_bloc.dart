import 'package:bloc/bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../../data/models/event.dart';
import '../../../logic/services/firebase/firebase_event_service.dart';

part 'event_event.dart';

part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final FirebaseEventService _eventService;

  EventBloc(this._eventService) : super(EventInitial()) {
    on<LoadEvents>(
      _onLoadEvents,
      transformer: (events, mapper) =>
          events.throttle(const Duration(milliseconds: 300)).switchMap(mapper),
    );
  }

  Future<void> _onLoadEvents(LoadEvents event, Emitter<EventState> emit) async {
    if (event.query == '' || event.query.isEmpty) {
      emit(EventQueryRemoved());
    } else {
      try {
        final eventsStream = _eventService.getEvents(event.query);
        await emit.forEach<List<Event>>(
          eventsStream,
          onData: (events) => EventLoaded(events),
          onError: (error, stackTrace) => EventError(error: error.toString()),
        );
      } catch (e) {
        emit(EventError(error: e.toString()));
      }
    }
  }
}

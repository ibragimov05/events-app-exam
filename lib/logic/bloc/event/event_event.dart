part of 'event_bloc.dart';

abstract class EventEvent {}

class LoadEvents extends EventEvent {
  final String query;

  LoadEvents({required this.query});
}

class UpdateEvents extends EventEvent {
  final List<Event> events;

  UpdateEvents(this.events);
}

part of 'event_bloc.dart';

abstract class EventState {}

class EventInitial extends EventState {}

class EventLoaded extends EventState {
  final List<Event> events;

  EventLoaded(this.events);
}

class EventQueryRemoved extends EventState {}

class EventError extends EventState {
  final String error;

  EventError({required this.error});
}

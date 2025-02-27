abstract class PollEvent {}

class LoadPolls extends PollEvent {

  LoadPolls();
}

class UpdatePollActiveStatus extends PollEvent {
  final String pollId;
  final bool isActive;

  UpdatePollActiveStatus(this.pollId, this.isActive);
}

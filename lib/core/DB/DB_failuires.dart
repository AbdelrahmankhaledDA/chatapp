abstract class Failure {
  final String message;
  Failure(this.message);
}

class DbFailure extends Failure {
  DbFailure(super.message);
}

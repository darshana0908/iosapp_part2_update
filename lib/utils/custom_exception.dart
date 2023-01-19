class CustomException implements Exception {
  final dynamic _prefix;
  final dynamic _message;

  CustomException([this._prefix, this._message]);

  @override
  String toString() => "$_prefix - $_message";
}

class FetchDataException extends CustomException {
  FetchDataException(String message) : super("Error During Communication", message);
}

class BadRequestException extends CustomException {
  BadRequestException(Map message) : super(message['status'], message['error']);
}

class UnauthorizedException extends CustomException {
  UnauthorizedException(Map message) : super(message['status'], message['error']);
}

class NotFoundException extends CustomException {
  NotFoundException(Map message) : super(message['status'], message['error']);
}

class InvalidInputException extends CustomException {
  InvalidInputException(Map message) : super(message['status'], message['error']);
}

class InternalServerErrorException extends CustomException {
  InternalServerErrorException(Map message) : super(message['status'], message['error']);
}

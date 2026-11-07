import "package:logger/logger.dart";

final Logger logger = Logger(
  printer: PrettyPrinter(
    colors: false,
    printEmojis: false,
    lineLength: 80,

    methodCount: 0,
    errorMethodCount: 5,
    noBoxingByDefault: true,
  ),
);

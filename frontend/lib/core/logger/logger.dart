import 'package:grpc/grpc_web.dart';
import 'package:logger/logger.dart';
import 'package:porker2fe/core/env/env.dart';

final logger = newLogger();

Logger newLogger() {
  if (Env().isProduction()) {
    Logger.level = Level.error;
    return Logger(
      filter: null, // Use the default LogFilter (-> only log in debug mode)
      printer: PrettyPrinter(), // Use the PrettyPrinter to format and print log
      output: null, // Use the default LogOutput (-> send everything to console)
    );
  }

  Logger.level = Level.debug;
  return Logger(
    printer: PrettyPrinter(
        methodCount: 2,
        // number of method calls to be displayed
        errorMethodCount: 8,
        // number of method calls if stacktrace is provided
        lineLength: 120,
        // width of the output
        colors: true,
        // Colorful log messages
        printEmojis: true,
        // Print an emoji for each log message
        printTime: true // Should each log print contain a timestamp
        ),
  );
}

void grpcLoggingInfo(Exception err) {
  try {
    final grpcErr = err as GrpcError;
    logger.i(grpcErr.toString());
  } catch (e, stackTrace) {
    logger.i("an unexpected exception has occurred",
        error: e, stackTrace: stackTrace);
  }
}

void grpcLogging(Exception err) {
  try {
    final grpcErr = err as GrpcError;
    switch (grpcErr.code) {
      case StatusCode.deadlineExceeded:
        logger.i("deadline exceeded");
        break;
      case StatusCode.cancelled:
        logger.i("canceled");
        break;
      case StatusCode.unavailable:
        logger.w("unavailable: ${grpcErr.message!}");
        break;
      default:
        logger.e(grpcErr.toString());
    }
  } catch (e, stackTrace) {
    logger.e("an unexpected exception has occurred",
        error: e, stackTrace: stackTrace);
  }
}

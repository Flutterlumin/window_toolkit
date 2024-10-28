import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';

/// Calculates the position of a window based on its size and the specified alignment.
///
/// This function retrieves the current display information and cursor position
/// to determine the optimal position for the window on the screen. It uses the
/// provided alignment to adjust the window's position accordingly. If the
/// alignment is not a standard one, the function calculates the position based
/// on the specified alignment value.
///
/// Returns a [Future] that resolves to an [Offset] representing the top-left
/// corner of the window in logical pixels.
///
/// Parameters:
/// - [windowSize]: The size of the window being positioned.
/// - [alignment]: The alignment of the window relative to the display.
///
/// Example usage:
/// ```dart
/// Size windowSize = Size(800, 600);
/// Offset position = await calculateWindowPosition(windowSize, Alignment.center);
/// ```
Future<Offset> calculateWindowPosition(Size windowSize, Alignment alignment) async {
  // Retrieve the primary display and all displays
  Display primaryDisplay = await screenRetriever.getPrimaryDisplay();
  List<Display> allDisplays = await screenRetriever.getAllDisplays();
  Offset cursorScreenPoint = await screenRetriever.getCursorScreenPoint();

  // Determine the current display based on cursor position
  Display currentDisplay = allDisplays.firstWhere(
    (display) => Rect.fromLTWH(
      display.visiblePosition!.dx,
      display.visiblePosition!.dy,
      display.size.width,
      display.size.height,
    ).contains(cursorScreenPoint),
    orElse: () => primaryDisplay,
  );

  // Initialize visible dimensions and position
  double visibleWidth = currentDisplay.visibleSize?.width ?? currentDisplay.size.width.toDouble();
  double visibleHeight = currentDisplay.visibleSize?.height ?? currentDisplay.size.height.toDouble();
  double visibleStartX = currentDisplay.visiblePosition?.dx ?? 0.0;
  double visibleStartY = currentDisplay.visiblePosition?.dy ?? 0.0;

  // Calculate the window position based on alignment
  Offset position = Offset.zero;

  if (alignment == Alignment.topLeft) {
    position = Offset(visibleStartX, visibleStartY);
  } else if (alignment == Alignment.topCenter) {
    position = Offset(
      visibleStartX + (visibleWidth / 2) - (windowSize.width / 2),
      visibleStartY,
    );
  } else if (alignment == Alignment.topRight) {
    position = Offset(
      visibleStartX + visibleWidth - windowSize.width,
      visibleStartY,
    );
  } else if (alignment == Alignment.centerLeft) {
    position = Offset(
      visibleStartX,
      visibleStartY + (visibleHeight / 2) - (windowSize.height / 2),
    );
  } else if (alignment == Alignment.center) {
    position = Offset(
      visibleStartX + (visibleWidth / 2) - (windowSize.width / 2),
      visibleStartY + (visibleHeight / 2) - (windowSize.height / 2),
    );
  } else if (alignment == Alignment.centerRight) {
    position = Offset(
      visibleStartX + visibleWidth - windowSize.width,
      visibleStartY + (visibleHeight / 2) - (windowSize.height / 2),
    );
  } else if (alignment == Alignment.bottomLeft) {
    position = Offset(
      visibleStartX,
      visibleStartY + visibleHeight - windowSize.height,
    );
  } else if (alignment == Alignment.bottomCenter) {
    position = Offset(
      visibleStartX + (visibleWidth / 2) - (windowSize.width / 2),
      visibleStartY + visibleHeight - windowSize.height,
    );
  } else if (alignment == Alignment.bottomRight) {
    position = Offset(
      visibleStartX + visibleWidth - windowSize.width,
      visibleStartY + visibleHeight - windowSize.height,
    );
  } else {
    final left = (visibleWidth - windowSize.width) / 2 + alignment.x * ((visibleWidth - windowSize.width) / 2);
    final top = (visibleHeight - windowSize.height) / 2 + alignment.y * ((visibleHeight - windowSize.height) / 2);
    position = Offset(
      visibleStartX + left,
      visibleStartY + top,
    );
  }

  return position;
}

/// Calculates the position of a window based on its size and the specified alignment.
///
/// This function retrieves the current display information and cursor position
/// to determine the optimal position for the window on the screen. It uses the
/// provided alignment to adjust the window's position accordingly. If the
/// alignment is not a standard one, the function calculates the position based
/// on the specified alignment value.
///
/// Returns a [Future] that resolves to an [Offset] representing the top-left
/// corner of the window in logical pixels.
///
/// Parameters:
/// - [windowSize]: The size of the window being positioned.
/// - [alignment]: The alignment of the window relative to the display.
///
/// Example usage:
/// ```dart
/// Size windowSize = Size(800, 600);
/// Offset position = await calculateWindowPosition(windowSize, Alignment.center);
/// ```
///
// Future<Offset> calculateWindowPosition(Size windowSize, Alignment alignment) async {
//   Display primaryDisplay = await screenRetriever.getPrimaryDisplay();
//   List<Display> allDisplays = await screenRetriever.getAllDisplays();
//   Offset cursorScreenPoint = await screenRetriever.getCursorScreenPoint();

//   Display currentDisplay = allDisplays.firstWhere(
//     (display) => Rect.fromLTWH(
//       display.visiblePosition!.dx,
//       display.visiblePosition!.dy,
//       display.size.width,
//       display.size.height,
//     ).contains(cursorScreenPoint),
//     orElse: () => primaryDisplay,
//   );

//   num visibleWidth = currentDisplay.size.width;
//   num visibleHeight = currentDisplay.size.height;
//   num visibleStartX = 0;
//   num visibleStartY = 0;

//   if (currentDisplay.visibleSize != null) {
//     visibleWidth = currentDisplay.visibleSize!.width;
//     visibleHeight = currentDisplay.visibleSize!.height;
//   }
//   if (currentDisplay.visiblePosition != null) {
//     visibleStartX = currentDisplay.visiblePosition!.dx;
//     visibleStartY = currentDisplay.visiblePosition!.dy;
//   }
//   Offset position = const Offset(0, 0);

//   if (alignment == Alignment.topLeft) {
//     position = Offset(
//       visibleStartX + 0,
//       visibleStartY + 0,
//     );
//   } else if (alignment == Alignment.topCenter) {
//     position = Offset(
//       visibleStartX + (visibleWidth / 2) - (windowSize.width / 2),
//       visibleStartY + 0,
//     );
//   } else if (alignment == Alignment.topRight) {
//     position = Offset(
//       visibleStartX + visibleWidth - windowSize.width,
//       visibleStartY + 0,
//     );
//   } else if (alignment == Alignment.centerLeft) {
//     position = Offset(
//       visibleStartX + 0,
//       visibleStartY + ((visibleHeight / 2) - (windowSize.height / 2)),
//     );
//   } else if (alignment == Alignment.center) {
//     position = Offset(
//       visibleStartX + (visibleWidth / 2) - (windowSize.width / 2),
//       visibleStartY + ((visibleHeight / 2) - (windowSize.height / 2)),
//     );
//   } else if (alignment == Alignment.centerRight) {
//     position = Offset(
//       visibleStartX + visibleWidth - windowSize.width,
//       visibleStartY + ((visibleHeight / 2) - (windowSize.height / 2)),
//     );
//   } else if (alignment == Alignment.bottomLeft) {
//     position = Offset(
//       visibleStartX + 0,
//       visibleStartY + (visibleHeight - windowSize.height),
//     );
//   } else if (alignment == Alignment.bottomCenter) {
//     position = Offset(
//       visibleStartX + (visibleWidth / 2) - (windowSize.width / 2),
//       visibleStartY + (visibleHeight - windowSize.height),
//     );
//   } else if (alignment == Alignment.bottomRight) {
//     position = Offset(
//       visibleStartX + visibleWidth - windowSize.width,
//       visibleStartY + (visibleHeight - windowSize.height),
//     );
//   } else {
//     final left = (visibleWidth - windowSize.width) / 2 + alignment.x * ((visibleWidth - windowSize.width) / 2);
//     final top = (visibleHeight - windowSize.height) / 2 + alignment.y * ((visibleHeight - windowSize.height) / 2);
//     position = Offset(
//       visibleStartX + left,
//       visibleStartY + top,
//     );
//   }
//   return position;
// }

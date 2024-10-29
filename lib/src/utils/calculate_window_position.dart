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
Future<Offset> calculateWindowPosition(Size size, Alignment alignment) async {
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
  double visibleW = currentDisplay.visibleSize != null
      ? currentDisplay.visibleSize!.width
      : currentDisplay.size.width.toDouble();
  double visibleH = currentDisplay.visibleSize != null
      ? currentDisplay.visibleSize!.height
      : currentDisplay.size.height.toDouble();
  double visibleStartX = currentDisplay.visiblePosition?.dx ?? 0.0;
  double visibleStartY = currentDisplay.visiblePosition?.dy ?? 0.0;

  // Calculate the window position based on alignment
  Offset position = Offset.zero;

  if (alignment == Alignment.topLeft) {
    position = Offset(visibleStartX, visibleStartY);
  } else if (alignment == Alignment.topCenter) {
    position = Offset(
      visibleStartX + (visibleW / 2) - (size.width / 2),
      visibleStartY,
    );
  } else if (alignment == Alignment.topRight) {
    position = Offset(
      visibleStartX + visibleW - size.width,
      visibleStartY,
    );
  } else if (alignment == Alignment.centerLeft) {
    position = Offset(
      visibleStartX,
      visibleStartY + (visibleH / 2) - (size.height / 2),
    );
  } else if (alignment == Alignment.center) {
    position = Offset(
      visibleStartX + (visibleW / 2) - (size.width / 2),
      visibleStartY + (visibleH / 2) - (size.height / 2),
    );
  } else if (alignment == Alignment.centerRight) {
    position = Offset(
      visibleStartX + visibleW - size.width,
      visibleStartY + (visibleH / 2) - (size.height / 2),
    );
  } else if (alignment == Alignment.bottomLeft) {
    position = Offset(
      visibleStartX,
      visibleStartY + visibleH - size.height,
    );
  } else if (alignment == Alignment.bottomCenter) {
    position = Offset(
      visibleStartX + (visibleW / 2) - (size.width / 2),
      visibleStartY + visibleH - size.height,
    );
  } else if (alignment == Alignment.bottomRight) {
    position = Offset(
      visibleStartX + visibleW - size.width,
      visibleStartY + visibleH - size.height,
    );
  } else {
    final double leftAdjustment = (visibleW - size.width) / 2;
    final double leftOffset = alignment.x * leftAdjustment;
    final double left = leftAdjustment + leftOffset;

    final double topAdjustment = (visibleH - size.height) / 2;
    final double topOffset = alignment.y * topAdjustment;
    final top = topAdjustment + topOffset;

    position = Offset(visibleStartX + left, visibleStartY + top);
  }

  return position;
}

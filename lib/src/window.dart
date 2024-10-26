import 'dart:ui';

class Window {
  const Window({
    this.movable,
    this.closable,
    this.minimizable,
    this.maximizable,
    this.center,
    this.opacity,
    this.size,
    this.minimumSize,
    this.maximumSize,
  });
  final bool? movable;
  final bool? closable;
  final bool? minimizable;
  final bool? maximizable;
  final bool? center;
  final double? opacity;
  final Size? size;
  final Size? minimumSize;
  final Size? maximumSize;
}

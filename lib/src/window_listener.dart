abstract mixin class WindowListener {
  void onWindowFocus() {}
  void onWindowBlur() {}
  void onWindowMaximize() {}
  void onWindowUnmaximize() {}
  void onWindowRestore() {}
  void onWindowEnterFullScreen() {}
  void onWindowLeaveFullScreen() {}

  void onWindowEvent(String eventName) {}
}

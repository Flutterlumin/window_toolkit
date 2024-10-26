# window_toolkit

[![pub version][pub-image]][pub-url]
[pub-image]: https://img.shields.io/pub/v/window_toolkit.svg
[pub-url]: https://pub.dev/packages/window_toolkit

window_toolkit is a Flutter plugin for macOS that simplifies customization of native window properties. It enables developers to control window behavior, style, and UI components like title bars, window alignment, resizing, and opacity. Future platform support is planned, making it adaptable for cross-platform development.


#### Features
	•	Window Management: Control window properties including movability, minimizability, maximizability, and more.
	•	Title Bar Customization: Adjust the title bar’s visibility and style.
	•	Resizable Options: Enable or disable window resizing based on user needs.
	•	Alignment and Positioning: Center or align the window with preset alignments.
	•	Opacity Control: Adjust the window’s opacity dynamically.

Currently designed for macOS, with plans to support additional platforms in the future.


### Getting Started

To use window_toolkit, add it to your 'pubspec.yaml':

```yaml
dependencies:
  window_toolkit: ^0.1.0
```

Alternatively, add it directly from GitHub:

```yaml
dependencies:
  window_toolkit:
    git:
      url: https://github.com/Codedop/window_toolkit.git
      ref: main
```

Then, import the package:

```dart
import 'package:window_toolkit/window_toolkit.dart';
```

### Usage

Here’s a basic example of how to use window_toolkit:

```dart
import 'package:flutter/material.dart';
import 'package:window_toolkit/window_toolkit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WindowToolkit toolkit = WindowToolkit.instance;
  await toolkit.initialize();
  await toolkit.titlebar(Titlebar(style: TitlebarStyle.expand));
  await toolkit.window(
    Window(maximumSize: Size(1000, 800), minimumSize: Size(800, 700), size: (Size(800, 700)), center: true),
  );

  runApp(App());
}
```

### API Overview

	•	WindowToolkit: The primary class to control window settings.
	•	Define: Configure individual properties like movability and size.
	•	Check: Verify window properties like minimized or fullscreen.
	•	Perform: Actions on the window, like minimize, maximize, or fullscreen.


### License
This project is licensed under the [MIT License](LICENSE).


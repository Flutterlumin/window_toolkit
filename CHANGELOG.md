## 0.1.5

- **Bug Fixes**:
	- **Stack Overflow Error**: Resolved an issue where a recursive call in `WindowToolkit.instance` caused a stack overflow.
  
- **Features**:
  - **StandardButtons**: Added detailed inline documentation to explain the functionality, state management, and interaction of the StandardButtons class.
	- **MacosIconButton**: Documented the MacosIconButton class, describing its behavior, styling, and state-based feedback.

## 0.1.5

- **Enhancements**:
  - **Dart Formatting**: Updated code formatting in `WindowToolkit` and `calculateWindowPosition` to finally meet Dart standards.

## 0.1.3

- **Enhancements**:
  - **Example App Screenshot**: The Sowcase screenshot url has been updated.

## 0.1.2

- **Enhancements**:
  - **Example App Screenshot**: Added a screenshot of the example app to the README for better visual representation.
  - **Dart Formatting**: Updated code formatting in `WindowToolkit` and `calculateWindowPosition` to meet Dart standards.

## 0.1.1

- **Enhancements**:
  - **Current Window Tracking**: Implemented a mechanism within `WindowToolkit` to keep track of the current window instance.
  - **Fullscreen Control Logic**: Updated the `fullscreen` method to prevent entering fullscreen mode when a maximum size is defined.
  - **Dynamic Position Calculation**: Improved the `calculateWindowPosition` function to ensure it uses `double` instead of `num` for dimensions.
  - **Performance Optimizations**: Made various optimizations across window property management and alignment calculations.

## 0.1.0

- **Features**:
  - **Window Management**: Control window properties including movability, minimizability, and maximizability.
  - **Title Bar Customization**: Adjust the title bar’s visibility and style.
  - **Resizable Options**: Enable or disable window resizing based on user needs.
  - **Alignment and Positioning**: Center or align the window with preset alignments.
  - **Opacity Control**: Adjust the window’s opacity dynamically.

## 0.0.1

- **Initial Release**: Introduced `window_toolkit`, a Flutter plugin for macOS that simplifies customization of native window properties. 

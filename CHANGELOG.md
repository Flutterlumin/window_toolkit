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

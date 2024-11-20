import Cocoa
import FlutterMacOS

public class WindowToolkit: NSObject, NSWindowDelegate {
    public var onEvent: ((String) -> Void)?
    private var _window: NSWindow?
    public var window: NSWindow {
        get {
            return _window!
        }
        set {
            _window = newValue
            _window?.delegate = self
            configureWindow()

        }
    }

    override public init() {
        super.init()
    }

    private func configureWindow() {
        guard let window = _window else { return }

        // Configure initial properties to hide title bar
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.styleMask.insert(.fullSizeContentView)  // Extend content to full size
        window.collectionBehavior = [.managed]
    }

    public func titlebar(_ args: [String: Any]) {
        let style: String = args["style"] as? String ?? ""

        if style == "remove" {
            titlebarVisibility(false)
            standardWindowButton(false)

        } else if style == "hidden" {
            titlebarVisibility(false)
            standardWindowButton(true)
        } else if style == "expand" {
            window.toolbar = NSToolbar()
            titlebarVisibility(true)
            standardWindowButton(true)
        } else {
            window.toolbar = nil
            titlebarVisibility(true)
            standardWindowButton(true)
        }
        window.isOpaque = false
        window.hasShadow = true
    }

    private func titlebarVisibility(_ show: Bool) {
        guard let window: NSWindow = _window else { return }
        window.titleVisibility = show ? .visible : .hidden
        window.titlebarAppearsTransparent = !show
        if !show {
            window.styleMask.insert(.fullSizeContentView)
        } else {
            window.styleMask.remove(.fullSizeContentView)
        }

    }

    private func standardWindowButton(_ show: Bool) {
        window.standardWindowButton(.closeButton)?.isHidden = !show
        window.standardWindowButton(.miniaturizeButton)?.isHidden = !show
        window.standardWindowButton(.zoomButton)?.isHidden = !show
    }

    public func setMovable(_ args: [String: Any]) {
        let movable: Bool = args["movable"] as? Bool ?? true
        window.isMovableByWindowBackground = movable
        window.isMovable = movable
    }

    public func setClosable(_ args: [String: Any]) {
        let closable: Bool = args["closable"] as? Bool ?? true
        if closable {
            window.styleMask.insert(.closable)
        } else {
            window.styleMask.remove(.closable)
        }
    }

    public func setMinimizable(_ args: [String: Any]) {
        let minimizable: Bool = args["minimizable"] as? Bool ?? true
        if minimizable {
            window.styleMask.insert(.miniaturizable)
        } else {
            window.styleMask.remove(.miniaturizable)
        }
    }

    public func setMaximizable(_ args: [String: Any]) {
        let maximizable: Bool = args["maximizable"] as? Bool ?? true
        if maximizable {
            window.styleMask.insert(.resizable)
        } else {
            window.styleMask.remove(.resizable)
        }
    }

    public func setMaximumSize(_ args: [String: Any]) {
        let size: NSSize = NSSize(
            width: CGFloat((args["width"] as! NSNumber).floatValue),
            height: CGFloat((args["height"] as! NSNumber).floatValue)
        )
        window.maxSize = size
    }

    public func setMinimumSize(_ args: [String: Any]) {
        let size: NSSize = NSSize(
            width: CGFloat((args["width"] as! NSNumber).floatValue),
            height: CGFloat((args["height"] as! NSNumber).floatValue)
        )
        window.minSize = size
    }

    public func setOpacity(_ args: [String: Any]) {
        let opacity: CGFloat = args["opacity"] as? CGFloat ?? 1
        window.alphaValue = opacity
    }

    public func setBounds(_ args: [String: Any]) {
        let animate = args["animate"] as? Bool ?? false

        var frameRect = window.frame
        if args["width"] != nil && args["height"] != nil {
            let width: CGFloat = CGFloat(truncating: args["width"] as! NSNumber)
            let height: CGFloat = CGFloat(truncating: args["height"] as! NSNumber)

            frameRect.origin.y += (frameRect.size.height - height)
            frameRect.size.width = width
            frameRect.size.height = height
        }

        if args["x"] != nil && args["y"] != nil {
            frameRect.origin.x = CGFloat(truncating: args["x"] as! NSNumber)
            frameRect.origin.y = CGFloat(truncating: args["y"] as! NSNumber)
        }

        if animate {
            window.animator().setFrame(frameRect, display: true, animate: true)
        } else {
            window.setFrame(frameRect, display: true)
        }
    }

    public func getClosable() -> Bool { return window.styleMask.contains(.closable) }
    public func getMinimizable() -> Bool { return window.styleMask.contains(.miniaturizable) }
    public func getMinimized() -> Bool { return window.isMiniaturized }
    public func getMaximizable() -> Bool { return window.styleMask.contains(.resizable) }
    public func getMaximized() -> Bool { return window.isZoomed }
    public func getMovable() -> Bool { return window.isMovable }
    public func getFullscreen() -> Bool { return window.styleMask.contains(.fullScreen) }
    public func getOpacity() -> CGFloat { return window.alphaValue }
    public func getBounds() -> NSDictionary {
        let frame: NSRect = window.frame
        let data: NSDictionary = [
            "x": frame.origin.x,
            "y": frame.origin.y,
            "width": frame.size.width,
            "height": frame.size.height,
        ]
        return data
    }

    public func destroy() { NSApp.terminate(nil) }
    public func close() { window.close() }
    public func minimize() { window.miniaturize(nil) }
    public func maximize() { if !getMaximized() { window.zoom(nil) } }
    public func unmaximize() { if getMaximized() { window.zoom(nil) } }
    public func fullScreen() { window.toggleFullScreen(nil) }

    public func drag() {
        DispatchQueue.main.async {
            let inner: NSWindow = self.window
            if inner.currentEvent != nil { inner.performDrag(with: inner.currentEvent!) }
        }
    }

    public func windowDidBecomeKey(_ notification: Notification) {
        if window is NSPanel {
            emitEvent("focus")
        }
    }

    public func windowDidBecomeMain(_ notification: Notification) {
        emitEvent("focus")
    }

    public func windowDidResignMain(_ notification: Notification) {
        emitEvent("blur")
    }

    public func windowDidDeminiaturize(_ notification: Notification) {
        emitEvent("restore")
    }

    public func windowDidEnterFullScreen(_ notification: Notification) {
        emitEvent("enter-full-screen")
    }

    public func windowDidExitFullScreen(_ notification: Notification) {
        emitEvent("leave-full-screen")
    }

    public func emitEvent(_ eventName: String) {
        if onEvent != nil {
            onEvent!(eventName)
        }
    }
}

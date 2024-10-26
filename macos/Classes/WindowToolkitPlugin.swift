import Cocoa
import FlutterMacOS

public class WindowToolkitPlugin: NSObject, FlutterPlugin {
    public static var RegisterGeneratedPlugins: ((FlutterPluginRegistry) -> Void)?
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "toolkit", binaryMessenger: registrar.messenger)
        let instance = WindowToolkitPlugin(registrar, channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    private var registrar: FlutterPluginRegistrar!
    private var channel: FlutterMethodChannel!

    private var window: NSWindow {
        return (self.registrar.view?.window)!
    }

    private var _inited: Bool = false
    private var toolkit: WindowToolkit = WindowToolkit()

    public init(_ registrar: FlutterPluginRegistrar, _ channel: FlutterMethodChannel) {
        super.init()
        self.registrar = registrar
        self.channel = channel
    }

    public func initialize() {
        if !_inited {
            toolkit.window = window
            toolkit.onEvent = {
                (eventName: String) in self._emitEvent(eventName)
            }
            _inited = true
        }
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let methodName: String = call.method
        let args: [String: Any] = call.arguments as? [String: Any] ?? [:]

        switch methodName {
        case "initialize":
            initialize()
            result(true)
            break
        case "titlebar":
            toolkit.titlebar(args)
            result(true)
            break
        case "set_movable":
            toolkit.setMovable(args)
            result(true)
        case "set_closable":
            toolkit.setClosable(args)
            result(true)
        case "set_minimizable":
            toolkit.setMinimizable(args)
            result(true)
        case "set_maximizable":
            toolkit.setMaximizable(args)
            result(true)
        case "set_minimum_size":
            toolkit.setMinimumSize(args)
            result(true)
        case "set_maximum_size":
            toolkit.setMaximumSize(args)
            result(true)
        case "set_opacity":
            toolkit.setOpacity(args)
            result(true)
        case "set_bounds":
            toolkit.setBounds(args)
            result(true)
            break
        case "get_closable":
            result(toolkit.getClosable())
            break
        case "get_minimizable":
            result(toolkit.getMinimizable())
            break
        case "get_minimized":
            result(toolkit.getMinimized())
            break
        case "get_maximizable":
            result(toolkit.getMaximizable())
            break
        case "get_maximized":
            result(toolkit.getMaximized())
            break
        case "get_movable":
            result(toolkit.getMovable())
            break
        case "get_fullscreen":
            result(toolkit.getFullscreen())
            break
        case "get_opacity":
            result(toolkit.getOpacity())
        case "get_bounds":
            result(toolkit.getBounds())
            break
        case "destroy":
            toolkit.destroy()
            result(true)
            break
        case "close":
            toolkit.close()
            result(true)
            break
        case "minimize":
            toolkit.minimize()
            result(true)
            break
        case "maximize":
            toolkit.maximize()
            result(true)
            break
        case "unmaximize":
            toolkit.unmaximize()
            result(true)
            break
        case "fullscreen":
            toolkit.fullScreen()
            result(true)
        case "drag":
            toolkit.drag()
            result(true)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func _emitEvent(_ eventName: String) {
        let args: NSDictionary = [
            "eventName": eventName
        ]
        channel.invokeMethod("onEvent", arguments: args, result: nil)
    }

}

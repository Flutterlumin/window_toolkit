import 'package:flutter/material.dart';
import 'package:window_toolkit/window_toolkit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WindowToolkit toolkit = WindowToolkit.instance;
  await toolkit.initialize();
  await toolkit.titlebar(Titlebar(style: TitlebarStyle.expand));
  await toolkit.window(
    Window(minimumSize: Size(800, 700), size: (Size(800, 700)), center: true),
  );

  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final WindowToolkit _toolkit = WindowToolkit.instance;
  double _opacity = 1.0;
  TitlebarStyle _titlebarStyle = TitlebarStyle.expand;

  @override
  Widget build(BuildContext context) {
    TextTheme texts = Theme.of(context).textTheme;
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: size.width / 1.2),
          child: Column(
            children: [
              _buildTitlebarSelector(texts),
              _gap(gap: 60),
              _buildWindowActions(texts),
              _gap(gap: 60),
              _buildWindowSettings(texts),
              _gap(gap: 60),
              _buildOpacitySlider(texts)
            ],
          ),
        ),
      ),
    );
  }

  Widget _gap({double? gap}) => SizedBox(height: gap ?? 20);
  Widget _buildTitlebarSelector(TextTheme texts) {
    return Column(
      children: [
        Text("Title Bar Style", style: texts.headlineMedium),
        _gap(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: TitlebarStyle.values.map((style) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Radio<TitlebarStyle>(
                    value: style,
                    groupValue: _titlebarStyle,
                    onChanged: (style) async {
                      setState(() => _titlebarStyle = style!);
                      await _toolkit.titlebar(Titlebar(style: _titlebarStyle));
                    },
                  ),
                  Text(
                    style.toString().split('.').last[0].toUpperCase() +
                        style.toString().split('.').last.substring(1),
                  )
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildWindowActions(TextTheme texts) {
    return Column(
      children: [
        Text("Window Actions", style: texts.headlineMedium),
        _gap(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton('Destroy', () => _toolkit.perform.destroy()),
            _buildActionButton('Close', () => _toolkit.perform.close()),
            _buildActionButton('Minimize', () => _toolkit.perform.minimize()),
            _buildActionButton(
              'Maximize',
              () async {
                bool isMaximized = await _toolkit.check.maximized();
                isMaximized ? _toolkit.perform.unmaximize() : _toolkit.perform.maximize();
              },
            ),
            _buildActionButton('Fullscreen', () => _toolkit.perform.fullscreen()),
          ],
        ),
      ],
    );
  }

  Widget _buildWindowSettings(TextTheme texts) {
    return Column(
      children: [
        Text("Window Settings", style: texts.headlineMedium),
        _gap(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildToggleActionButton('Movable', _toolkit.define.movable, _toolkit.check.movable),
            _buildToggleActionButton('Closable', _toolkit.define.closable, _toolkit.check.closable),
            _buildToggleActionButton(
              'Minimizable',
              _toolkit.define.minimizable,
              _toolkit.check.minimizable,
            ),
            _buildToggleActionButton(
              'Maximizable',
              _toolkit.define.maximizable,
              _toolkit.check.maximizable,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }

  Widget _buildToggleActionButton(
      String text, Future<void> Function(bool) define, Future<bool> Function() check) {
    return FutureBuilder<bool>(
      future: check(),
      builder: (context, snapshot) {
        bool isEnabled = snapshot.data ?? false;
        return TextButton(
          onPressed: () async {
            await define(!isEnabled);
            setState(() {});
          },
          child: Text(isEnabled ? '$text: ON' : '$text: OFF'),
        );
      },
    );
  }

  Widget _buildOpacitySlider(TextTheme texts) {
    return Column(
      children: [
        Text("Window Opacity", style: texts.headlineMedium),
        _gap(),
        Slider(
          value: _opacity,
          min: 0.0,
          max: 1.0,
          divisions: 10,
          label: "${(_opacity * 100).round()}%",
          onChanged: (value) async {
            setState(() => _opacity = value);
            await _toolkit.define.opacity(value);
          },
        ),
      ],
    );
  }
}

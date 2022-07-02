import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import 'backevent_notifier.dart';
void main() {

  runApp(
      ChangeNotifierProvider(
        create: (context) => BackEventNotifier(),
        child:  MyApp(),
      ));
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Webpage(),
    );
  }
}

class Webpage extends StatefulWidget{
  @override
  State<Webpage> createState() => _WebpageState();
}

class _WebpageState extends State<Webpage> {

  bool isLoading=true;
  final _key = UniqueKey();
  late WebViewController _controll;


  GlobalKey<ScaffoldState>_globalKey=GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        key: _globalKey,
        appBar: EmptyAppBar(),
        body: Stack(
          children: <Widget>[
            WebView(
              key: _key,
              initialUrl: "https://www.tufidcoschemes.co.in/admin",
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: ( webViewController) {
                _controll=webViewController;
              },
              javascriptChannels: <JavascriptChannel>{
                _toasterJavascriptChannel(context),
              },
              navigationDelegate: (NavigationRequest request) {
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageFinished: (finish) {
                setState(() {
                  isLoading = false;
                });
              },
              gestureNavigationEnabled: true,
            ),
            isLoading ? Center( child: CircularProgressIndicator(),)
                : Stack(),
          ],
        ),
      ),

    );


  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Future<bool> _onBack() async {

    bool goBack;

    var value = await _controll.canGoBack();  // check webview can go back

    if (value) {

      _controll.goBack(); // perform webview back operation

      return false;

    } else {
      late BackEventNotifier _notifier;
      await showDialog(

          context: _globalKey.currentState!.context,

          builder: (context) => Consumer<BackEventNotifier>(
              builder: (context, event, child) {
                _notifier=event;
                return AlertDialog(

                  title: const Text(
                      'Confirmation ', style: TextStyle(color: Colors.purple)),

                  content: const Text('Do you want exit app ?'),

                  actions: <Widget>[

                    TextButton(

                      onPressed: () {
                        Navigator.of(context).pop(false);
                        event.add(false);
                      },

                      child: Text("No"), // No

                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        event.add(true);
                      },
                      child: Text("Yes"), // Yes
                    ),
                  ],
                );
              }
          )



      );

      //Navigator.pop(_globalKey.currentState!.context);
      print("_notifier.isBack ${_notifier.isBack}");
      return _notifier.isBack;
    }
  }
}
class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
    );
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}
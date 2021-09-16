import 'package:flutter/material.dart';
import 'package:vigidas_pack/screens/loading-screen.dart';
import 'package:vigidas_pack/screens/login-screen.dart';
import 'package:vigidas_pack/screens/measurement-screen.dart';
import 'package:vigidas_pack/screens/length-screen.dart';
import 'package:vigidas_pack/screens/tasks-screen.dart';
import 'package:vigidas_pack/screens/quantity-screen.dart';
import 'package:vigidas_pack/screens/upload-screen.dart';
import 'package:vigidas_pack/screens/thankyou-screen.dart';
import 'package:provider/provider.dart';
import 'models/tasks-provider.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  runApp(VigidasPack());
}

class VigidasPack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => TasksProvider(),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            fontFamily: 'OpenSans',
          ),
          initialRoute: Loading.id,
          routes: {
            Loading.id: (context) => Loading(),
            LoginScreen.id: (context) => LoginScreen(),
            MeasurementScreen.id: (context) => MeasurementScreen(),
            LengthScreen.id: (context) => LengthScreen(),
            TasksScreen.id: (context) => TasksScreen(),
            QuantityScreen.id: (context) => QuantityScreen('', ''),
            UploadScreen.id: (context) => UploadScreen(),
            ThankyouScreen.id: (context) => ThankyouScreen(),
          },
        ),
      ),
    );
  }
}

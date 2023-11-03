import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/pages/widgets/circle_painter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

@RoutePage()
class TermsOfUseScreen extends StatelessWidget {
  TermsOfUseScreen({Key? key}) : super(key: key);
  
  final Future<String> _termsOfUseText = rootBundle.loadString('assets/tou-flexid.md');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.router.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomPaint(
            painter: CirclePainter(left: false),
            size: const Size(double.infinity, double.infinity),
          ),
          FutureBuilder<String>(
            future: _termsOfUseText,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                // Use the Markdown widget to display the content
                return Markdown(
                  data: snapshot.data!,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: kToolbarHeight + 40),
                );
              } else {
                // Show a loading spinner while the Markdown is loading
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}

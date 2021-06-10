import 'package:gwa_app/states/global_state.dart';
import 'package:provider/provider.dart';
import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gwa_app/widgets/gradient_appbar_flexible_space.dart';

import 'local_widgets/home_section.dart';

//FIXME: Sometimes certain lists don't load.
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Home'),
          elevation: 15.0,
          backgroundColor: Colors.transparent,
          flexibleSpace: GradientAppBarFlexibleSpace(),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              print('The app bar leading button has been pressed');
              // Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HomeSection(
                title: 'Top Posts of The Month',
                waitDuration: Duration(milliseconds: 800),
                contentStream: Provider.of<GlobalState>(context, listen: false)
                    .getTopStream(TimeFilter.month, 21),
                homeSectionPageContentStream:
                    Provider.of<GlobalState>(context, listen: false)
                        .getTopStream(TimeFilter.month, 99),
              ),
              HomeSection(
                title: 'Top Posts of The Week',
                waitDuration: Duration(milliseconds: 700),
                contentStream: Provider.of<GlobalState>(context, listen: false)
                    .getTopStream(TimeFilter.week, 21),
                homeSectionPageContentStream:
                    Provider.of<GlobalState>(context, listen: false)
                        .getTopStream(TimeFilter.week, 99),
              ),
              HomeSection(
                title: 'Hot Posts',
                waitDuration: Duration(milliseconds: 600),
                contentStream: Provider.of<GlobalState>(context, listen: false)
                    .getHotStream(21),
                homeSectionPageShufflePages: true,
                homeSectionPageContentStream:
                    Provider.of<GlobalState>(context, listen: false)
                        .getHotStream(99),
              )
            ],
          ),
        ),
      ),
    );
  }
}

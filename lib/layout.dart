import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  const Layout({
    super.key, 
    required this.body,
    this.appBar,
    this.title,
    this.leadingRoute = '',
    this.actions,
    this.floatingActionButton,
  });
  final String? title;
  final String leadingRoute;
  final Widget body;
  final AppBar? appBar;
  final List<Widget>? actions;
  final FloatingActionButton? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    Widget backAction = Icon(
      Icons.arrow_back_ios,
      color: Theme.of(context).colorScheme.inversePrimary,
    );

    Widget? titleWidget = title != null
      ? Text(
          title!,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        )
      : null;

    AppBar? navbar;
    if (appBar != null) {
      navbar = appBar;
    } else if (title != null && title != '') {
      navbar = AppBar(
        centerTitle: true,
        title: titleWidget,
        leading: GestureDetector(
          onTap: () {
            if (leadingRoute == '') {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacementNamed(leadingRoute);
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: backAction,
            ),
          ),
        ),
        actions: actions,
      );
    }

    return Scaffold(
      appBar: navbar,
      body: body,
      floatingActionButton: floatingActionButton
    );
  }
}

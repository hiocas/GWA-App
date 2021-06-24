import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gwa_app/models/audio_launch_options.dart';
import 'package:gwa_app/screens/gwa_drawer/local_widgets/login.dart';
import 'package:gwa_app/screens/submission_page/submission_page.dart';
import 'package:gwa_app/services/reddit_client_service.dart';

import '../main.dart';

String getTagName(String tag) {
  if (tag.startsWith('{author:}'))
    return tag.substring(9);
  else
    return tag;
}

Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) {
  return rootBundle.loadString(assetsPath).then((value) => jsonDecode(value));
}

String getUrlTitle(String url) {
  if (url.contains('soundgasm')) {
    return url.substring(url.lastIndexOf('/') + 1).replaceAll('-', ' ');
  }
  return url;
}

/// Use this function when you want to push a SubmissionPage. It'll handle
/// returning the query data from it (if it exists).
void pushSubmissionPageWithReturnData(
    BuildContext context, String submissionFullname, bool fromLibrary) async {
  final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SubmissionPage(
              submissionFullname: submissionFullname,
              fromLibrary: fromLibrary)));
  if (result != null) {
    Navigator.pushNamedAndRemoveUntil(
        context,
        ExtractArgumentsSubmissionList.routeName,
        (Route<dynamic> route) => false,
        arguments: SubmissionListArguments(
            result['query'], result['sort'], result['timeFilter']));
  }
}

/// Use this function when you want to replace the current rout and push a
/// SubmissionPage. It'll handle returning the query data from it
/// (if it exists).
void pushReplacementSubmissionPageWithReturnData(
    BuildContext context, String submissionFullname, bool fromLibrary) async {
  final result = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => SubmissionPage(
              submissionFullname: submissionFullname,
              fromLibrary: fromLibrary)));
  if (result != null) {
    Navigator.pushNamedAndRemoveUntil(
        context,
        ExtractArgumentsSubmissionList.routeName,
        (Route<dynamic> route) => false,
        arguments: SubmissionListArguments(
            result['query'], result['sort'], result['timeFilter']));
  }
}

/// Use this function when you want to pop SubmissionList and return data with
/// it.
void popSubmissionPageWithData(BuildContext context,
    {String query, Sort sort, TimeFilter timeFilter}) {
  Navigator.pop(
      context, {'query': query, 'sort': sort, 'timeFilter': timeFilter});
}

/// Pushes [Login] with a [RedditClientService] so that later when it pops with
/// [popLogin] the [HomeScaffold] will be updated.
void pushLogin(BuildContext context,
    {RedditClientService redditClientService}) async {
  final redirect = await Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => Login(
                redditClientService: redditClientService,
              )));
  if (redirect != null && redirect) {
    Navigator.pushNamedAndRemoveUntil(
        context, RedirectToHome.routeName, (Route<dynamic> route) => false);
  }
}

/// Pops [Login] and redirect [HomeScaffold] to [Home] based on [redirect].
/// To use this make sure you pushed [Login] with [pushLogin].
void popLogin(BuildContext context, {bool redirect}) {
  Navigator.pop(context, redirect);
}

String audioLaunchOptionToString(AudioLaunchOptions audioLaunchOptions) {
  switch (audioLaunchOptions) {
    case AudioLaunchOptions.ChromeCustomTabs:
      return 'Chrome Custom Tabs';
    case AudioLaunchOptions.WebView:
      return 'WebView';
  }
  return '';
}

import 'package:draw/draw.dart';
import 'package:gwa_app/utils/gwa_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GwaSubmission {
  String fullTitle;
  String title = '';
  String selftext = '';
  String author = '';
  Uri shortlink;
  Uri url;
  String fullname = '';
  List<String> tags = [];
  List<String> urls = [];
  String firstImageOrGifUrl = '';
  Image img;
  String thumbnailUrl;
  bool hasAudioUrl = false;
  String fromNow;
  int upvotes;
  DateTime created;
  int gold;
  int silver;
  int platinum;
  String linkFlairText;
  String authorFlairText;
  int numComments;

  GwaSubmission(Submission submission) {
    this.fullTitle = submission.title;
    this.title = findSubmissionTitle(this.fullTitle);
    this.shortlink = submission.shortlink;
    this.selftext = submission.selftext;
    this.author = submission.author;
    this.url = submission.url;
    this.fullname = submission.fullname;
    this.tags = findSubmissionTags(submission);
    this.urls = findSubmissionURLS(submission);
    var urlStr = this.url.toString();
    //Only add the url to urls if it has soundgasm in it -> when posting a link submission to reddit this is where the link is.
    if (urlStr.contains('soundgasm')) this.urls.add(urlStr);
    if (submission.preview.length > 0)
      this.thumbnailUrl = submission.preview[0].source.url.toString();
    this.firstImageOrGifUrl = findFirstImageOrGifURL(submission);
    this.img = getImg();
    this.hasAudioUrl = checkHasAudioUrl();
    this.fromNow = getTimeSinceCreated(submission.createdUtc);
    this.upvotes = submission.upvotes;
    this.created = submission.createdUtc;
    this.gold = submission.gold ?? 0;
    this.silver = submission.silver ?? 0;
    this.platinum = submission.platinum ?? 0;
    this.linkFlairText = submission.linkFlairText ?? '';
    this.authorFlairText = submission.authorFlairText ?? '';
    this.numComments = submission.numComments ?? 0;
  }

  List<String> findSubmissionTags(Submission submission) {
    var exp = RegExp(r'(?<=\[)(.*?)(?=\])');
    var matches = exp.allMatches(submission.title);
    return List<String>.generate(
        matches.length, (int index) => matches.elementAt(index).group(0));
  }

  // Returns a list strings of all urls found in a submission's self text.
  // There's an issue with the reddit &amp; flag, it can appear mid url
  List<String> findSubmissionURLS(Submission submission) {
    List<String> urls = [];
    var exp = RegExp(
      r"""\b((?:https?://|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'\".,<>?«»“”‘’]))""",
      caseSensitive: false,
    );
    var matches = exp.allMatches(submission.selftext);
    var matchesList = List<String>.generate(
        matches.length, (int index) => matches.elementAt(index).group(0));
    /*TODO(DoubleCheck): For now I'll replace all $amp; with an &. I don't know
       if this could cause problems but it fixes some.*/
    for (var i = 0; i < matchesList.length; i++) {
      matchesList[i] = matchesList[i].replaceAll(r'&amp;', '&');
      urls.add(matchesList[i]);
    }
    return urls;
  }

  /// Returns a string of the first image or gif url found in a submission's self text.
  String findFirstImageOrGifURL(Submission submission) {
    for (var s in this.urls) {
      if (s.contains('.jpg') || s.contains('.png') || s.contains('.gif')) {
        return s;
      }
    }
    if (this.thumbnailUrl != null) {
      return this.thumbnailUrl;
    }
    return 'https://styles.redditmedia.com/t5_2u463/styles/communityIcon_1lj5xecdisi31.png?width=256&s=98e8187f0403751b02c03e7ffb9f059ce0ce18d9';
  }

  bool checkHasAudioUrl() {
    for (var url in this.urls) {
      if (url.contains('soundgasm')) return true;
    }
    return false;
  }

  Image getImg() {
    return Image.network(
      this.firstImageOrGifUrl,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: 200,
          width: 200,
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                  : null,
            ),
          ),
        );
      },
      errorBuilder:
          (BuildContext context, Object exception, StackTrace stackTrace) {
        return Image.network(
          this.thumbnailUrl ?? 'https://styles.redditmedia.com/t5_2u463/styles/communityIcon_1lj5xecdisi31.png?width=256&s=98e8187f0403751b02c03e7ffb9f059ce0ce18d9',
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 200,
              width: 200,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                ),
              ),
            );
          },
          errorBuilder:
              (BuildContext context, Object exception, StackTrace stackTrace) {
            return Text('There was an error');
          },
        );
      },
    );
  }

  String getTimeSinceCreated(DateTime created) {
    var diff = DateTime.now().difference(created);
    var years = (diff.inDays / 365).truncate();
    var months = (diff.inDays / 30).truncate();
    var weeks = (diff.inDays / 7).truncate();
    var days = diff.inDays;
    var hours = diff.inHours;
    var minutes = diff.inMinutes;
    var seconds = diff.inSeconds;
    if (years >= 1)
      return years.toString() + 'y';
    else if (months >= 1)
      return months.toString() + 'mo';
    else if (weeks >= 1)
      return weeks.toString() + 'w';
    else if (days >= 1)
      return days.toString() + 'd';
    else if (hours >= 1)
      return hours.toString() + 'h';
    else if (minutes >= 1) return minutes.toString() + 'm';
    else if (seconds >= 1) return seconds.toString() + 's';
    return 'now';
  }
}

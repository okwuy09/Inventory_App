//EN
timeEn(String dateTime, {bool numberDate = true}) {
  DateTime date = DateTime.parse(dateTime);
  final dateNow = DateTime.now();
  final difference = dateNow.difference(date);
  if ((difference.inDays / 365).floor() >= 2) {
    return '${(difference.inDays / 365).floor()} Years Ago';
  } else if ((difference.inDays / 365).floor() >= 1) {
    return (numberDate) ? '1 Years Ago' : 'Last Year';
  } else if ((difference.inDays / 30).floor() >= 2) {
    return '${(difference.inDays / 30).floor()} Months Ago';
  } else if ((difference.inDays / 30).floor() >= 1) {
    return (numberDate) ? '1 Month Ago' : 'Last Month';
  } else if ((difference.inDays / 7).floor() >= 2) {
    return '${(difference.inDays / 7).floor()} Weeks Ago';
  } else if ((difference.inDays / 7).floor() >= 1) {
    return (numberDate) ? '1 Week Ago' : 'Last Week';
  } else if (difference.inDays >= 2) {
    return '${difference.inDays} Days Ago';
  } else if (difference.inDays >= 1) {
    return (numberDate) ? '1 Day Ago' : 'Yesterday';
  } else if (difference.inHours >= 2) {
    return '${difference.inHours} Hours Ago';
  } else if (difference.inHours >= 1) {
    return (numberDate) ? '1 Hour Ago' : 'Last Hour';
  } else if (difference.inMinutes >= 2) {
    return '${difference.inMinutes} Minutes Ago';
  } else if (difference.inMinutes >= 1) {
    return (numberDate) ? '1 Minute Ago' : 'Last Minute';
  } else if (difference.inSeconds >= 3) {
    return '${difference.inSeconds} Seconds Ago';
  } else {
    return 'Now';
  }
}

// timeEn('2020-09-10 20:05:14');

  

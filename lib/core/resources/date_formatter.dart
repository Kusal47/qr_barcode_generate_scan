

import 'package:intl/intl.dart';

String formatDateTimeString(
  String dateTimeString, {
  bool customDate = false,
  bool formatTime = false,
  bool formatStringDate = false,
  bool convertDateString = false,
  bool addAMPM = false,
}) {
  try {
    DateTime dateTime = DateTime.parse(dateTimeString);
    if (addAMPM) {
      final inputFormat = DateFormat("HH:mm"); // 24-hour format
      final outputFormat = DateFormat("hh:mm a"); // 12-hour format with AM/PM
      final dateTime = inputFormat.parse(dateTimeString);
      return outputFormat.format(dateTime);
    }
    if (formatTime) {
      return DateFormat('hh:mm a').format(dateTime);
    }

    if (customDate) {
      String formattedMonth = DateFormat('MMM').format(dateTime);
      String year = DateFormat('yy').format(dateTime);
      String dayWithSuffix = getDayWithSuffix(dateTime.day);

      return '$dayWithSuffix $formattedMonth, $year';
    }

    if (formatStringDate) {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }

    if (convertDateString) {
      return DateFormat('yyyy/MM/dd').format(dateTime);
    }

    return DateFormat('dd/MM/yyyy').format(dateTime);
  } catch (e) {
    return dateTimeString; // Return original string if parsing fails
  }
}

String formatDateTime(
  DateTime dateTime, {
  bool onlyDate = false,
  bool dateInMMYY = false,
  bool dateYYYYMMDD = false,
  bool isTransactionDetail = false,
  bool dayOnly = false,
  bool dateTimeOnly = false,
  bool isStartEnd = false,
}) {
  if (dateInMMYY) return DateFormat('MM/yy').format(dateTime);
  if (dateYYYYMMDD) return DateFormat("yyyy-MM-dd").format(dateTime);
  if (isTransactionDetail) {
    final time = DateFormat('hh:mm a').format(dateTime);
    String formattedMonth = DateFormat('MMM').format(dateTime);
    String year = DateFormat('yy').format(dateTime);
    String dayWithSuffix = getDayWithSuffix(dateTime.day);

    return '$dayWithSuffix $formattedMonth, $year, $time';
  }
  if (dayOnly) return DateFormat('EEEE').format(dateTime);
  if (dateTimeOnly) return DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);
  if (isStartEnd) return DateFormat('HH:mm:ss').format(dateTime);

  return DateFormat(onlyDate ? 'dd MMM, yy' : 'EEEE dd MMM, yy').format(dateTime);
}

String toLocalTime(
  String utcTimestamp, {
  bool isTransaction = false,
  bool onlyTime = false,
  bool isEvent = false,
}) {
  if (isTransaction) {
    var dateTime = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(utcTimestamp, true);
    var dateLocal = DateFormat("dd MMM, yy, hh:mm a").format(dateTime.toLocal());
    return dateLocal;
  } else if (onlyTime) {
    var dateTime = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(utcTimestamp, true);
    var dateLocal = DateFormat("hh:mm a").format(dateTime.toLocal());
    return dateLocal;
  } else if (isEvent) {
    var dateTime = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(utcTimestamp, true);
    var dateLocal = DateFormat("dd MMM, yy").format(dateTime.toLocal());
    return dateLocal;
  } else {
    var dateTime = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(utcTimestamp, true);
    var dateLocal = DateFormat("hh:mm a").format(dateTime.toLocal());
    return dateLocal;
  }
}

String convertToIsoFormat(String inputDateTime) {
  DateFormat inputFormat = DateFormat('yyyy-MM-dd hh:mm a');

  DateTime parsedDateTime = inputFormat.parse(inputDateTime);

  DateFormat outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

  return outputFormat.format(parsedDateTime);
}

String getDayWithSuffix(int day) {
  if (day >= 11 && day <= 13) return '$dayᵗʰ';
  switch (day % 10) {
    case 1:
      return '$dayˢᵗ'; // 1ˢᵗ
    case 2:
      return '$dayⁿᵈ'; // 2ⁿᵈ
    case 3:
      return '$dayʳᵈ'; // 3ʳᵈ
    default:
      return '$dayᵗʰ'; // 4ᵗʰ, 5ᵗʰ, 6ᵗʰ, etc.
  }
}

String getPartOfDay() {
  int hour = int.parse(DateFormat('HH').format(DateTime.now()));

  if (hour >= 5 && hour < 12) {
    return 'Morning';
  } else if (hour >= 12 && hour < 17) {
    return 'Afternoon';
  } else if (hour >= 17 && hour < 21) {
    return 'Evening';
  } else {
    return 'Night';
  }
}

String getTimeAgo(String dateTimeString) {
  DateTime messageDate = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(dateTimeString, true);
  final Duration difference = DateTime.now().difference(messageDate);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds}s';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h';
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else {
    return '${difference.inDays}d';
  }
}

String getFutureDates({bool isMonth = false}) {
  DateTime now = DateTime.now();
  DateTime oneMonthLater = DateTime(now.year, now.month + 1, now.day);
  DateTime oneYearLater = DateTime(now.year + 1, now.month, now.day);

  final formatter = DateFormat('dd MMMM, yyyy');
  return isMonth ? formatter.format(oneMonthLater) : formatter.format(oneYearLater);
}

String getTimeRemaining(String toDateString) {
  final toDate = DateTime.parse(toDateString);
  final now = DateTime.now();
  final difference = toDate.difference(now);

  if (difference.isNegative) {
    return '0d 0hr 0min';
  }

  return '${difference.inDays}d:${difference.inHours % 24}hr:${difference.inMinutes % 60}min';
}



import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDateSeparator(String time) {
  final date = DateTime.parse(time).toLocal();
  final now = DateTime.now();

  if (DateUtils.isSameDay(date, now)) {
    return "Today";
  }

  if (DateUtils.isSameDay(date, now.subtract(const Duration(days: 1)))) {
    return "Yesterday";
  }

  return DateFormat('dd MMM yyyy').format(date);
}

bool isNewDate(String current, String? previous) {
  if (previous == null) return true;

  final currentDate = DateTime.parse(current);
  final previousDate = DateTime.parse(previous);

  return !DateUtils.isSameDay(currentDate, previousDate);
}

String formatTime(String time) {
  final date = DateTime.parse(time).toLocal();
  return DateFormat('HH:mm').format(date);
}

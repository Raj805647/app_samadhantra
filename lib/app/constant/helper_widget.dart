String formatDate(String dateString) {
  try {
    // Parse the date string (assuming format like "2024-01-15T10:30:00.000Z")
    DateTime dateTime = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      // More than a year - show full date
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    } else if (difference.inDays > 30) {
      // More than a month - show month and year
      return _getMonthName(dateTime.month) + " ${dateTime.year}";
    } else if (difference.inDays > 0) {
      return "${difference.inDays}d ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}h ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes}m ago";
    } else {
      return "Just now";
    }
  } catch (e) {
    // If parsing fails, return original string or empty
    return dateString.split('T')[0]; // Returns only date part
  }
}
String _getMonthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}

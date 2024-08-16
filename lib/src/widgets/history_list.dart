import 'package:flutter/material.dart';

/// A stateless widget that represents a history item in a list..
///
/// The [HistoryItemWidget] is a custom widget that displays information about a
/// specific history entry, including the serial number and the timestamp when it
/// was viewed. It also provides a callback function that is triggered when the 
/// item is tapped.
class HistoryItemWidget extends StatelessWidget {
  
  /// The serial number of the history item.
  final String serial;
  
  /// The timestamp indicating when the serial number was viewed.
  final DateTime timestamp;
  
  /// A callback function that is triggered when the item is tapped.
  final VoidCallback onTap;

  // ignore: use_super_parameters
  /// Creates a [HistoryItemWidget].
  ///
  /// The [serial], [timestamp], and [onTap] parameters are required.
  const HistoryItemWidget({
    Key? key,
    required this.serial,
    required this.timestamp,
    required this.onTap,
  }) : super(key: key);
  
  /// Formats a [DateTime] object into a readable string.
  /// 
  /// Single-digit minutes are padded with a leading zero.
  String _formatDate(DateTime date) {
  
  // Ensures single-digit minutes are displayed as 01, 02, etc.
  String formattedMinute = date.minute.toString().padLeft(2, '0');
  
  // Formats the date and time in a more user-friendly way.
  String formattedDate = 
  '${date.day}.${date.month}.${date.year} ${date.hour}:$formattedMinute';
  return formattedDate;
}

  /// Builds the widget tree for the [HistoryItemWidget].
  /// 
  /// This method constructs a [Card] containing a [ListTile] widget. The serial number 
  /// is displayed as the title, and the formatted timestamp is shown below it.
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              serial,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6), // Small space between serial and date
            Text(
              'Viewed on: ${_formatDate(timestamp)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward,
          color: Colors.black,
        ),
        onTap: onTap,
      ),
    );
  }
  
}
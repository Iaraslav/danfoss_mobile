import 'package:flutter/material.dart';
import 'dart:developer';

class HistoryItemWidget extends StatelessWidget {
  final String serial;
  final DateTime timestamp;
  final VoidCallback onTap;

  // ignore: use_super_parameters
  const HistoryItemWidget({
    Key? key,
    required this.serial,
    required this.timestamp,
    required this.onTap,
  }) : super(key: key);
  
  // Format DateTime to a readable string
  String _formatDate(DateTime date) {
  // fix the issue with always having two using padLeft(2, '0') 
  //to ensure single-digit minutes are displayed as 01, 02, etc
  String formattedMinute = date.minute.toString().padLeft(2, '0');
  // Format the date and time in a more user-friendly way
  String formattedDate = 
  '${date.day}.${date.month}.${date.year} ${date.hour}:$formattedMinute';
  return formattedDate;
}

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
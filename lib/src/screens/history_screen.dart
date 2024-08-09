import 'dart:developer';

import 'package:danfoss_mobile/src/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/history_list.dart';
import 'recognition_screen.dart';

/// A stateful widget that displays a page with the user's serial number history.
///
/// The [HistoryPage] class presents a list of serial numbers previously 
/// scanned or entered by the user, along with their corresponding timestamps.
/// The history is loaded from [SharedPreferences].
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  HistoryPageState createState() => HistoryPageState();
}

/// The state associated with [HistoryPage].
///
/// This class handles the loading, displaying, and clearing of the user's 
/// serial number history.
class HistoryPageState extends State<HistoryPage> {
  
  /// A list of maps where each map contains a 'serial' and a 'timestamp' entry
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory(); // Load history when the page is initialized.
  }

  /// Loads the serial numbers from history stored in [SharedPreferences].
  Future<void> _loadHistory() async {
    log('enter load history');
    final prefs = await SharedPreferences.getInstance();
    List<String>? storedHistory = prefs.getStringList('serialHistory') ?? [];

    // Parses the history entries into a list of maps containing serial and timestamp.
    List<Map<String, dynamic>> parsedHistory = [];
    for (String entry in storedHistory) {
      try {
        List<String> parts = entry.split('|');
        if (parts.length == 2) {
          parsedHistory.add({
            'serial': parts[0],
            'timestamp': DateTime.parse(parts[1]),
          });
        }
      } catch (e) {
        // Log the error for debugging.
        log('Error parsing entry: $entry', error: e);
      }
    }

    // Sort the list by timestamp in descending order.
    parsedHistory.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

    setState(() {
      _history = parsedHistory;
    });

    log('Loaded history: $_history');  // Debugging
  }

  /// Displays a confirmation dialog and clears history if confirmed.
  Future<void> _showClearHistoryDialog() async {
    return showDialog<void>(
      context: context,
      // User must tap button to close dialog
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete History'),
          content: const Text('Are you sure you want to delete all history?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _clearHistory(); // Clear history
              },
            ),
          ],
        );
      },
    );
  }

  /// Clears all history from [SharedPreferences] and updates the UI.
  Future<void> _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('serialHistory');

    setState(() {
      _history = [];
    });

    log('History cleared');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showBackButton: true),
      body: _history.isEmpty
          ? Center(child: Text('No history available'))
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                return HistoryItemWidget(
                  serial: item['serial'],
                  timestamp: item['timestamp'],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecognizePage(serial: item['serial']),
                      ),
                    );
                  },
                );
              },
            ),
      /// Clear history button
      floatingActionButton: FloatingActionButton(
        onPressed: _showClearHistoryDialog,
        backgroundColor: Color.fromRGBO(207, 45, 36, 1),
        tooltip: 'Clear History',
        child: Icon(Icons.delete,
        color: Colors.white,),
      ),
    );
  }
}

import 'dart:developer';

import 'package:danfoss_mobile/src/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/history_list.dart';
import 'recognition_screen.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  // Load serial nums from history list
  Future<void> _loadHistory() async {
    log('enter load history');
    final prefs = await SharedPreferences.getInstance();
    List<String>? storedHistory = prefs.getStringList('serialHistory') ?? [];

    // Parse the history entries into a list of maps containing serial and timestamp
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
        log('Error parsing entry: $entry', error: e);
      }
    }

    // Sort the list by timestamp in descending order
    parsedHistory.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

    setState(() {
      _history = parsedHistory;
    });

    log('Loaded history: $_history');  // Debugging
  }

  // Show confirmation dialog and clear history if confirmed
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

  // Clear all history from SharedPreferences and update UI
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

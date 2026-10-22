import 'package:flutter/material.dart';

void main() {
  runApp(const WorkTimeTrackerApp());
}

class WorkTimeTrackerApp extends StatelessWidget {
  const WorkTimeTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arbeitszeit-Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TrackerHomePage(),
    );
  }
}

class TrackerHomePage extends StatefulWidget {
  const TrackerHomePage({super.key});

  @override
  State<TrackerHomePage> createState() => _TrackerHomePageState();
}

class _TrackerHomePageState extends State<TrackerHomePage> {
  final List<Map<String, dynamic>> _entries = [];
  bool _isTracking = false;
  DateTime? _startTime;

  void _toggleTracking() {
    setState(() {
      if (!_isTracking) {
        _isTracking = true;
        _startTime = DateTime.now();
      } else {
        _isTracking = false;
        final endTime = DateTime.now();
        final duration = endTime.difference(_startTime!);
        
        _entries.insert(0, {
          'date': '${_startTime!.day}.${_startTime!.month}.${_startTime!.year}',
          'start': '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}',
          'end': '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
          'duration': '${duration.inHours}h ${duration.inMinutes.remainder(60)}m',
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mein Arbeitszeit-Tracker'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      _isTracking ? 'Zeiterfassung läuft...' : 'Bereit für die Arbeit',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _isTracking ? Colors.green : Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _toggleTracking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isTracking ? Colors.red : Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: Text(_isTracking ? 'Stopp' : 'Start', style: const TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Letzte Einträge:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _entries.isEmpty
                  ? const Center(child: Text('Noch keine Einträge vorhanden.'))
                  : ListView.builder(
                      itemCount: _entries.length,
                      itemBuilder: (context, index) {
                        final item = _entries[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.access_time, color: Colors.blue),
                            title: Text('Datum: ${item['date']} (${item['duration']})'),
                            subtitle: Text('Zeit: ${item['start']} - ${item['end']} Uhr'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

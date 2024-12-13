import 'package:flutter/material.dart';
import 'api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REST API Task',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ApiTaskScreen(),
    );
  }
}

class ApiTaskScreen extends StatefulWidget {
  const ApiTaskScreen({Key? key}) : super(key: key);

  @override
  _ApiTaskScreenState createState() => _ApiTaskScreenState();
}

class _ApiTaskScreenState extends State<ApiTaskScreen> {
  final ApiService apiService = ApiService();
  dynamic apiResponse;
  String hash = '';
  String message = '';
  bool isLoading = false;

  //get
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final data = await apiService.fetchData();
    setState(() {
      apiResponse = data;
      isLoading = false;
      message = data.toString();
    });

    print("Fetched Data: $message");
  }

  //post
  Future<void> sendData() async {
    const String email = 'wanysamsuri1@gmail.com';

    final fetchedHash = await apiService.getHash(email);
    if (fetchedHash.contains('Failed') || fetchedHash.contains('Error')) {
      setState(() {
        message = fetchedHash;
      });

      print("Error: $message");
      return;
    }

    setState(() {
      hash = fetchedHash;
      message = 'Hash fetched successfully: $hash';
    });

    print('Fetched Hash: $hash');

    await sendPutData();
  }

  //put
  Future<void> sendPutData() async {
    const String email = 'wanysamsuri1@gmail.com';
    int y = 59; //<p>
    int x = ((34 + 14 * y) / 15).toInt(); //15x - 14y = 34

    final response = await apiService.sendPutData(email, hash, x, y);

    setState(() {
      message = response;
    });

    print("Put Request Response: $response");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REST API Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: fetchData,
              child: const Text('Fetch Data'),
            ),
            ElevatedButton(
              onPressed: sendData,
              child: const Text('Send Email'),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (apiResponse is List)
              Expanded(
                child: ListView.builder(
                  itemCount: apiResponse.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(apiResponse[index]['name'] ?? 'No Name'),
                        subtitle: Text(apiResponse[index]['description'] ??
                            'No Description'),
                      ),
                    );
                  },
                ),
              )
            else if (apiResponse != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    apiResponse.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              )
            else
              const Text('Press the button to fetch data.'),

            const SizedBox(height: 20),

            // hash display
            if (hash.isNotEmpty)
              Text(
                'Fetched Hash: $hash',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

            const SizedBox(height: 20),

            if (message.isNotEmpty)
              Text(
                message,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
          ],
        ),
      ),
    );
  }
}

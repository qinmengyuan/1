import 'package:flutter/material.dart';
import 'package:appui/help_data.dart';
import 'showpage.dart';

class NumberSelectorPage extends StatefulWidget {
  const NumberSelectorPage({super.key});

  @override
  State<NumberSelectorPage> createState() => _NumberSelectorPageState();
}

class _NumberSelectorPageState extends State<NumberSelectorPage> {
  int? selectedNumber;
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    HelpDataManager.loadFromFile(); //
  }

  void updateTextFieldFromDatabase() {
    if (selectedNumber != null) {
      final message = HelpDataManager.getHelpMessage(selectedNumber!);
      textController.text = message ?? 'null';
    } else {
      textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Digital Information Input"),
        backgroundColor: Colors.blue[600],
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 330,
                child: GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: List.generate(12, (index) {
                    final num = index + 1;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(4),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedNumber = num;
                          updateTextFieldFromDatabase();
                        });
                      },
                      child: Text(
                        "$num",
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),
              const Text("The number currently selected is：", style: TextStyle(fontSize: 16)),
              Text(
                selectedNumber != null ? "$selectedNumber" : "“Please choose any number”",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: textController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Please enter what you want to express",
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (selectedNumber != null) {
                        HelpDataManager.updateHelpMessage(
                            selectedNumber!, textController.text);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Num $selectedNumber contents is modified：${textController.text}'),
                          ),
                        );
                        await HelpDataManager.saveToFile();
                      }
                    },
                    child: const Text("Confirm"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DeviceStatusPage(),
                        ),
                      );
                    },
                    child: const Text("Back"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:patterns_codelab/data.dart';

void main() {
  runApp(const DocumentApp());
}

class DocumentApp extends StatelessWidget {
  const DocumentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: DocumentScreen(
        document: Document(),
      ),
    );
  }
}

class DocumentScreen extends StatelessWidget {
  final Document document;

  const DocumentScreen({
    required this.document,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var (title, :modified) = document.getMetadata();
    var formattedModifiedData = formatData(modified);
    var blocks = document.getBlocks();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Text('Last modified $formattedModifiedData'),
          Expanded(
            child: ListView.builder(
              itemCount: blocks.length,
              itemBuilder: (context, index) => BlockWidget(
                block: blocks[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BlockWidget extends StatelessWidget {
  final Block block;
  const BlockWidget({
    required this.block,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: switch (block) {
        HeaderBlock(:var text) => Text(
            text,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ParagraphBlock(:var text) => Text(text),
        CheckboxBlock(:var text, :var isChecked) => Row(
            children: [
              Checkbox(value: isChecked, onChanged: (_) {}),
              Text(text),
            ],
          ),
      },
    );
  }
}

String formatData(DateTime dateTime) {
  var today = DateTime.now();
  var difference = dateTime.difference(today);

  return switch (difference) {
    Duration(inDays: 0) => 'today',
    Duration(inDays: 1) => 'tomorrow',
    Duration(inDays: -1) => 'yesterday',
    Duration(inDays: var days) when days > 7 => '${days ~/ 7} weeks from now',
    Duration(inDays: var days) when days < -7 => '${days.abs() ~/ 7} weeks ago',
    Duration(inDays: var days, isNegative: true) => '${days.abs()} days ago',
    Duration(inDays: var days) => '$days days from now',
  };
}

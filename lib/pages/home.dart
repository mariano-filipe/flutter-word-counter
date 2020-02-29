import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FocusNode textFieldFocusNode;
  List<String> words = [];

  @override
  void initState() {
    super.initState();
    textFieldFocusNode = FocusNode();
    // Focus on the text field as soon as the home page is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(textFieldFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(8),
                color: Colors.blue,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'type some text',
                  ),
                  focusNode: textFieldFocusNode,
                  onChanged: onTextFieldChanged,
                ),
              ),
            ),
            SizedBox(width: 16),
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.pink,
                child: PaginatedDataTable(
                  header: Text("Found words"),
                  columns: [DataColumn(label: Text('word'))],
                  source: WordsTableDataSource(words),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTextFieldChanged(String typedText) {
    RegExp wordRegExp = new RegExp(r"(\w+)");
    this.setState(() {
      words = wordRegExp
          .allMatches(typedText)
          .map((RegExpMatch wordMatch) => wordMatch.group(0))
          .toList();
    });
  }

  @override
  void dispose() {
    textFieldFocusNode.dispose();
    super.dispose();
  }
}

class WordsTableDataSource implements DataTableSource {
  List<String> words;

  WordsTableDataSource(this.words);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => words.length;

  @override
  int get selectedRowCount => 0;

  @override
  bool get hasListeners => false;

  @override
  void notifyListeners() {}

  @override
  void removeListener(listener) {}

  @override
  void addListener(listener) {}

  @override
  void dispose() {}

  @override
  DataRow getRow(int index) {
    return DataRow(
      cells: [
        DataCell(Text(this.words[index])),
      ],
    );
  }
}

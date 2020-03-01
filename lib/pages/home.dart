import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FocusNode textFieldFocusNode;
  Map<String, int> wordCount = {};
  int sortColumnIndex = 0;
  bool sortAscending = true;

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
                    hintText: 'Type some text',
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
                  header: Text("Words found"),
                  columns: [
                    DataColumn(
                      label: Text('Word'),
                      onSort: onTableColumnSort,
                    ),
                    DataColumn(
                      label: Text('Count'),
                      onSort: onTableColumnSort,
                      numeric: true,
                    )
                  ],
                  source: WordsTableDataSource(
                      wordCount, sortColumnIndex, sortAscending),
                  sortColumnIndex: sortColumnIndex,
                  sortAscending: sortAscending,
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
    wordCount = Map();
    setState(() {
      wordRegExp.allMatches(typedText).forEach(
        (RegExpMatch wordMatch) {
          String word = wordMatch.group(0);
          wordCount[word] =
              wordCount.containsKey(word) ? wordCount[word] + 1 : 1;
        },
      );
    });
  }

  void onTableColumnSort(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;
    });
  }

  @override
  void dispose() {
    textFieldFocusNode.dispose();
    super.dispose();
  }
}

class WordsTableDataSource implements DataTableSource {
  Map<String, int> wordCount;
  List<String> words = [];
  List<int> counts = [];

  WordsTableDataSource(this.wordCount, int sortColumnIndex, bool ascending) {
    if (sortColumnIndex == 0) {
      // Word column
      this.words = wordCount.keys.toList()
        ..sort((word, otherWord) =>
            ascending ? word.compareTo(otherWord) : otherWord.compareTo(word));
    } else if (sortColumnIndex == 1) {
      // Count column
      this.words = wordCount.keys.toList()
        ..sort((word, otherWord) => ascending
            ? wordCount[word].compareTo(wordCount[otherWord])
            : wordCount[otherWord].compareTo(wordCount[word]));
    }
    this.counts = this.words.map((word) => wordCount[word]).toList();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => this.wordCount.length;

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
        DataCell(Text(words[index])),
        DataCell(Text(counts[index].toString())),
      ],
    );
  }
}

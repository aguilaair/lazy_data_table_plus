import 'package:flutter/material.dart';
import 'package:lazy_data_table/lazy_data_table.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Example table")),
        body: LazyDataTable(
          rows: 20,
          columns: 20,
          cellHeight: 100,
          cellWidth: 100,
          columnHeaderHeight: 150,
          rowHeaderWidth: 150,
          columnHeaderBuilder: (i) => Text("Col:${i + 1}"),
          rowHeaderBuilder: (i) => Text("Row:${i + 1}"),
          dataCellBuilder: (i, j) => Text("Cell:$i,$j"),
          cornerWidget: Text("Corner"),
        ),
      ),
    ),
  );
}

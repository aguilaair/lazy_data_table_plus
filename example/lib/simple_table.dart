import 'package:flutter/material.dart';
import 'package:lazy_data_table_plus/lazy_data_table_plus.dart';

class SimpleTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple table"),
      ),
      body: LazyDataTable(
        rows: 100,
        columns: 100,
        tableDimensions: DataTableDimensions(
          cellHeight: 50,
          cellWidth: 100,
          columnHeaderHeight: 50,
          rowHeaderWidth: 75,
        ),
        tableTheme: LazyDataTableTheme(
          columnHeaderBorder: Border.all(color: Colors.black38),
          rowHeaderBorder: Border.all(color: Colors.black38),
          cellBorder: Border.all(color: Colors.black12),
          cornerBorder: Border.all(color: Colors.black38),
          columnHeaderColor: Colors.white60,
          rowHeaderColor: Colors.white60,
          cellColor: Colors.white,
          cornerColor: Colors.white38,
        ),
        columnHeaderBuilder: (i) => Center(child: Text("Column: ${i + 1}")),
        rowHeaderBuilder: (i) => Center(child: Text("Row: ${i + 1}")),
        dataCellBuilder: (i, j) => Center(child: Text("Cell: $i, $j")),
        cornerWidget: Center(child: Text("Corner")),
      ),
    );
  }
}

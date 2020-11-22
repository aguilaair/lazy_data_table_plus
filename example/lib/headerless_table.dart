import 'package:flutter/material.dart';
import 'package:lazy_data_table_plus/lazy_data_table_plus.dart';

class HeaderlessTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Header-less table"),
      ),
      body: LazyDataTable(
        rows: 100,
        columns: 100,
        tableDimensions: LazyDataTableDimensions(
          cellHeight: 50,
          cellWidth: 100,
        ),
        tableTheme: LazyDataTableTheme(
          cellBorder: Border.all(color: Colors.black12),
          cellColor: Colors.white,
        ),
        dataCellBuilder: (i, j) => Center(child: Text("Cell: $i, $j")),
      ),
    );
  }
}

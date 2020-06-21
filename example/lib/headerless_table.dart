import 'package:flutter/material.dart';
import 'package:lazy_data_table/lazy_data_table.dart';

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
        tableDimensions: DataTableDimensions(
          cellHeight: 50,
          cellWidth: 100,
        ),
        tableTheme: DataTableTheme(
          cellBorder: Border.all(color: Colors.black12),
          cellColor: Colors.white,
        ),
        dataCellBuilder: (i, j) => Center(child: Text("Cell: $i, $j")),
      ),
    );
  }
}

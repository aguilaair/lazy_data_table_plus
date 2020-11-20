# lazy_data_table_plus

A Flutter widget data table that can be loaded lazily. The table also has a column header row and a row header column that will stay in view.
(This widget is still in development, and may not work 100%)

This widget is based on [table-sticky-headers](https://pub.dev/packages/table_sticky_headers) made by Alex Bacich, so credits to him.

## Features

* Scrollable when items overflow
* Column header row stays in view
* Row header column stays in view
* Items are loaded lazily

![img not loaded](https://github.com/aguilaair/lazy_data_table_plus/raw/master/example/lazy_data_table_plus_example.gif "lazy_data_table_plus example")

## Usage

To use this widget, add `lazy_data_table_plus: ^0.1.5` to your dependencies in `pubspec.yaml`

```yaml
dependencies:
  lazy_data_table_plus: ^0.1.6
```

Then the package can be included in a file with:

```dart
import 'package:lazy_data_table_plus/lazy_data_table_plus.dart';
```

And then the LazyDataTable can be used as following:  
(This example is used to create the table in the gif above)

```dart
LazyDataTable(
  rows: 100,
  columns: 100,
  tableDimensions: DataTableDimensions(
    cellHeight: 50,
    cellWidth: 100,
    columnHeaderHeight: 50,
    rowHeaderWidth: 75,
  ),
  tableTheme: DataTableTheme(
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
```

## Issues
If you have any problems or even suggestions feel free leave them [here](https://gitlab.com/_Naomi/lazy_data_table_plus/-/issues)

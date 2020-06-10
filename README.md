# lazy_data_table

A Flutter widget data table that can be loaded lazily. The table also has a column header row and a row header column that will stay in view.
(This widget is still in development, and may not work 100%)

This widget is based on [table-sticky-headers](https://pub.dev/packages/table_sticky_headers) made by Alex Babich, so credits to him.

## Features

* Scrollable when items overflow
* Column header row stays in view
* Row header column stays in view
* Items are loaded lazily

![img not loaded](https://gitlab.com/_Naomi/lazy_data_table/-/raw/master/example/lazy_data_table_example.gif "lazy_data_table example")

## Usage

To use this widget, add `lazy_data_table: ^0.1.3` to your dependencies in `pubspec.yaml`

```yaml
dependencies:
  lazy_data_table: ^0.1.3
```

Then the package can be included in a file with:

```dart
import 'package:lazy_data_table/lazy_data_table.dart';
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

## Known issues
Currently, whenever you scroll vertically, every row that is currently loaded has their offset corrected to make sure every line is at the same position.
This isn't ideal as it causes a lot of unnecessary updates. Ideally you'd only want the row to be updated once when it's loaded, but I can't seem to figure that out :/

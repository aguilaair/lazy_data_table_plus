# lazy_data_table

A Flutter widget data table that can be loaded lazily. The table also has a column header row and a row header column that will stay in view.
(This widget is still in development, and may not work 100%)

This widget is based on the [sticky-headers-table](https://github.com/AlexBacich/sticky-headers-table) made by Alex Babich, so credits to him.

## Features

* Scrollable when items overflow
* Column header row stays in view
* Row header column stays in view
* Items are loaded lazily

## Usage

To use this widget, add `lazy_data_table: ^0.0.1` to your dependencies in `pubspec.yaml`

```yaml
dependencies:
  lazy_data_table: ^0.0.1
```

Then the package can be included in a file with:

```dart
import 'package:lazy_data_table/lazy_data_table.dart';
```

And then the LazyDataTable can be used as following:

```dart
LazyDataTable(
  rows: 20,
  columns: 20,
  cellHeight: 100,
  cellWidth: 100,
  columnHeaderHeight: 150,
  rowHeaderWidth: 150,
  columnHeaderBuilder: (i) => Text("Col:${i+1}"),
  rowHeaderBuilder: (i) => Text("Row:${i+1}"),
  dataCellBuilder: (i, j) => Text("Cell:$i,$j"),
  cornerWidget: Text("Corner"),
),
```

## Known issues
Currently, whenever you scroll vertically, every row that is currently loaded has their offset corrected to make sure every line is at the same position.
This isn't ideal as it causes a lot of unnecessary updates. Ideally you'd only want the row to be updated once when it's loaded, but I can't seem to figure that out :/

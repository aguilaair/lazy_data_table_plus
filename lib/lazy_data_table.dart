library lazy_data_table;

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

/// Create a lazily loaded data table.
///
/// The table is [columns] by [rows] big.
/// The [columnHeaderBuilder] and [rowHeaderBuilder] are optional,
/// and when either of those is not given, the corner widget should also not be given.
class LazyDataTable extends StatefulWidget {
  LazyDataTable({
    Key key,
    // Number of data columns.
    @required this.columns,

    // Number of data rows.
    @required this.rows,

    // Dimensions of the table elements.
    this.tableDimensions = const DataTableDimensions(),

    // Theme of the table elements.
    this.tableTheme = const DataTableTheme(),

    // Builder function for the column header.
    this.columnHeaderBuilder,

    // Builder function for the row header.
    this.rowHeaderBuilder,

    // Builder function for the data cell.
    @required this.dataCellBuilder,

    // Corner widget.
    this.cornerWidget,
  }) : super(key: key) {
    assert(columns != null);
    assert(rows != null);
    assert(dataCellBuilder != null);
    if (rowHeaderBuilder == null || columnHeaderBuilder == null) {
      assert(cornerWidget == null,
          "The corner widget is only allowed when you have both a column header and a row header.");
    }
  }

  /// The state class that contains the table.
  final table = _LazyDataTableState();

  // Amount of cells
  /// The number of columns in the table.
  final int columns;

  /// The number of rows in the table.
  final int rows;

  // Size of cells and headers
  /// The dimensions of the table cells and headers.
  final DataTableDimensions tableDimensions;

  // Theme of the table
  /// The theme of the table cells and headers.
  final DataTableTheme tableTheme;

  // Builder functions
  /// The builder function for a column header.
  final Widget Function(int columnIndex) columnHeaderBuilder;

  /// The builder function for a row header.
  final Widget Function(int rowIndex) rowHeaderBuilder;

  /// The builder function for a data cell.
  final Widget Function(int columnIndex, int rowIndex) dataCellBuilder;

  /// The widget for the upper-left corner.
  final Widget cornerWidget;

  @override
  _LazyDataTableState createState() => table;

  /// Jump the table to the given location.
  void jumpTo(int column, int row) {
    table.jumpTo(column, row);
  }
}

class _LazyDataTableState extends State<LazyDataTable> {
  _CustomScrollController _horizontalControllers = _CustomScrollController();
  _CustomScrollController _verticalControllers = _CustomScrollController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        widget.rowHeaderBuilder != null
            ? SizedBox(
                width: widget.tableDimensions.rowHeaderWidth,
                child: Column(
                  children: <Widget>[
                    // Corner widget
                    SizedBox(
                      height: widget.tableDimensions.columnHeaderHeight,
                      width: widget.tableDimensions.rowHeaderWidth,
                      child: widget.cornerWidget != null
                          ? Container(
                              decoration: BoxDecoration(
                                color: widget.tableTheme.cornerColor,
                                border: widget.tableTheme.cornerBorder,
                              ),
                              child: widget.cornerWidget,
                            )
                          : Container(),
                    ),
                    // Row headers
                    Expanded(
                      child: NotificationListener(
                        onNotification: (ScrollNotification notification) {
                          _verticalControllers
                              .processNotification(notification);
                          return true;
                        },
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            controller: _verticalControllers,
                            itemCount: widget.rows,
                            itemBuilder: (__, i) {
                              return Container(
                                height: widget.tableDimensions.cellHeight,
                                width: widget.tableDimensions.rowHeaderWidth,
                                decoration: BoxDecoration(
                                  color: widget.tableTheme.rowHeaderColor,
                                  border: widget.tableTheme.rowHeaderBorder,
                                ),
                                child: widget.rowHeaderBuilder(i),
                              );
                            }),
                      ),
                    )
                  ],
                ),
              )
            : Container(),
        Expanded(
            child: Column(
          children: <Widget>[
            // Column headers
            widget.columnHeaderBuilder != null
                ? SizedBox(
                    height: widget.tableDimensions.columnHeaderHeight,
                    child: NotificationListener(
                      onNotification: (ScrollNotification notification) {
                        _horizontalControllers
                            .processNotification(notification);
                        return true;
                      },
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: _horizontalControllers,
                          itemCount: widget.columns,
                          itemBuilder: (__, i) {
                            return Container(
                              height: widget.tableDimensions.columnHeaderHeight,
                              width: widget.tableDimensions.cellWidth,
                              decoration: BoxDecoration(
                                color: widget.tableTheme.columnHeaderColor,
                                border: widget.tableTheme.columnHeaderBorder,
                              ),
                              child: widget.columnHeaderBuilder(i),
                            );
                          }),
                    ),
                  )
                : Container(),
            // Main data
            Expanded(
              child: NotificationListener(
                onNotification: (ScrollNotification notification) {
                  _verticalControllers.processNotification(notification);
                  return true;
                },
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    controller: _verticalControllers,
                    itemCount: widget.rows,
                    itemBuilder: (_, i) {
                      return SizedBox(
                        height: widget.tableDimensions.cellHeight,
                        child: NotificationListener(
                          onNotification: (ScrollNotification notification) {
                            _horizontalControllers
                                .processNotification(notification);
                            return true;
                          },
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              controller: _horizontalControllers,
                              itemCount: widget.columns,
                              itemBuilder: (__, j) {
                                return Container(
                                  height: widget.tableDimensions.cellHeight,
                                  width: widget.tableDimensions.cellWidth,
                                  decoration: BoxDecoration(
                                    color: widget.tableTheme.cellColor,
                                    border: widget.tableTheme.cellBorder,
                                  ),
                                  child: widget.dataCellBuilder(i, j),
                                );
                              }),
                        ),
                      );
                    }),
              ),
            )
          ],
        ))
      ],
    );
  }

  /// Jump the table to the given location.
  jumpTo(int column, int row) {
    _horizontalControllers.jumpTo(column * widget.tableDimensions.cellWidth);
    _verticalControllers.jumpTo(row * widget.tableDimensions.cellHeight);
  }
}

/// Data class for the dimensions of a [LazyDataTable].
class DataTableDimensions {
  const DataTableDimensions({
    /// Height of a cell and row header.
    this.cellHeight = 50,

    /// Width of a cell and column header.
    this.cellWidth = 50,

    /// Height of a column header.
    this.columnHeaderHeight = 50,

    /// Width of a row header.
    this.rowHeaderWidth = 50,
  });

  final double cellHeight;
  final double cellWidth;
  final double columnHeaderHeight;
  final double rowHeaderWidth;
}

class DataTableTheme {
  const DataTableTheme({
    /// [BoxBorder] for the column header.
    this.columnHeaderBorder,

    /// [BoxBorder] for the row header.
    this.rowHeaderBorder,

    /// [BoxBorder] for the cell.
    this.cellBorder,

    /// [BoxBorder] for the corner widget.
    this.cornerBorder,

    /// [Color] for the column header.
    this.columnHeaderColor,

    /// [Color] for the row header.
    this.rowHeaderColor,

    /// [Color] for the cell.
    this.cellColor,

    /// [Color] for the corner widget.
    this.cornerColor = Colors.white,
  });

  final BoxBorder columnHeaderBorder;
  final BoxBorder rowHeaderBorder;
  final BoxBorder cellBorder;
  final BoxBorder cornerBorder;

  final Color columnHeaderColor;
  final Color rowHeaderColor;
  final Color cellColor;
  final Color cornerColor;
}

/// A custom synchronized scroll controller.
///
/// This controller stores all their attached [ScrollPosition] in a list,
/// and when given a notification via [processNotification], it will scroll
/// every ScrollPosition in that list to the same [_offset].
class _CustomScrollController extends ScrollController {
  List<ScrollPosition> _positions = List();
  double _offset = 0;

  /// Stores given [ScrollPosition] in the list and
  /// set the initial offset of that ScrollPosition.
  @override
  void attach(ScrollPosition position) {
    position.correctPixels(_offset);
    _positions.add(position);
  }

  /// Removes given [ScrollPostion] from the list.
  @override
  void detach(ScrollPosition position) {
    _positions.remove(position);
  }

  /// Processes notification from one of the [ScrollPositions] in the list.
  processNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      jumpTo(notification.metrics.pixels);
    }
  }

  /// Jumps every item in the list to the given [offset],
  /// except the ones that are already at the correct offset.
  @override
  void jumpTo(double offset) {
    _offset = offset;
    for (ScrollPosition position in _positions) {
      if (position.pixels != _offset) {
        position.jumpTo(_offset);
      }
    }
  }
}

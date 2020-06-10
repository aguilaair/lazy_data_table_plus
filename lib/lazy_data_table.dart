library lazy_data_table;

import 'package:flutter/material.dart';

/// Create a lazily loaded data table.
///
/// The table is [columns] by [rows] big.
/// The [columnHeaderBuilder] and [rowHeaderBuilder] are optional,
/// and when either of those is not given, the corner widget should also not be given.
class LazyDataTable extends StatefulWidget {
  LazyDataTable({
    Key key,
    // Number of data columns
    @required this.columns,

    // Number of data rows
    @required this.rows,

    // Width of a cell
    this.cellWidth = 50,

    // Height of a cell
    this.cellHeight = 50,

    // Height of the column headers
    this.columnHeaderHeight = 50,

    // Width of the row headers
    this.rowHeaderWidth = 50,

    // Builder function for the column header
    this.columnHeaderBuilder,

    // Builder function for the row header
    this.rowHeaderBuilder,

    // Builder function for the data cell
    @required this.dataCellBuilder,

    // Corner widget
    this.cornerWidget,
  }) : super(key: key) {
    assert(columns != null);
    assert(rows != null);
    assert(cellWidth != null);
    assert(cellHeight != null);
    assert(columnHeaderHeight != null);
    assert(rowHeaderWidth != null);
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
  /// The width of a cell and a column header.
  final double cellWidth;

  /// The height of a cell and a row header.
  final double cellHeight;

  /// The height of a column header.
  final double columnHeaderHeight;

  /// The width of a column headers.
  final double rowHeaderWidth;

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
                width: widget.rowHeaderWidth,
                child: Column(
                  children: <Widget>[
                    // Corner widget
                    SizedBox(
                      height: widget.columnHeaderHeight,
                      child: widget.cornerWidget != null
                          ? widget.cornerWidget
                          : Container(),
                    ),
                    // Row headers
                    Expanded(
                      child: NotificationListener(
                        onNotification: (ScrollNotification notification) {
                          _verticalControllers.processNotification(
                              notification);
                          return true;
                        },
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            controller: _verticalControllers,
                            itemCount: widget.rows,
                            itemBuilder: (__, i) {
                              return Container(
                                height: widget.cellHeight,
                                width: widget.rowHeaderWidth,
                                decoration: BoxDecoration(border: Border.all()),
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
                    height: widget.columnHeaderHeight,
                    child: NotificationListener(
                      onNotification: (ScrollNotification notification) {
                        _horizontalControllers.processNotification(
                            notification);
                        return true;
                      },
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          controller:
                              _horizontalControllers,
                          itemCount: widget.columns,
                          itemBuilder: (__, i) {
                            return Container(
                              height: widget.columnHeaderHeight,
                              width: widget.cellWidth,
                              decoration: BoxDecoration(border: Border.all()),
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
                        height: widget.cellHeight,
                        child: NotificationListener(
                          onNotification: (ScrollNotification notification) {
                            _horizontalControllers.processNotification(
                                notification);
                            return true;
                          },
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              controller:
                                  _horizontalControllers,
                              itemCount: widget.columns,
                              itemBuilder: (__, j) {
                                return Container(
                                  height: widget.cellHeight,
                                  width: widget.cellWidth,
                                  //decoration: BoxDecoration(border: Border.all()),
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
    _horizontalControllers.jumpTo(column * widget.cellWidth);
    _verticalControllers.jumpTo(row * widget.cellHeight);
  }
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

library lazy_data_table;

import 'package:flutter/material.dart';

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
    @required this.columnHeaderBuilder,

    // Builder function for the row header
    @required this.rowHeaderBuilder,

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
    assert(columnHeaderBuilder != null);
    assert(rowHeaderBuilder != null);
    assert(dataCellBuilder != null);
  }

  final table = _LazyDataTableState();

  // Amount of cells
  final int columns;
  final int rows;
  // Size of cells and headers
  final double cellWidth;
  final double cellHeight;
  final double columnHeaderHeight;
  final double rowHeaderWidth;
  // Builder functions
  final Widget Function(int columnIndex) columnHeaderBuilder;
  final Widget Function(int rowIndex) rowHeaderBuilder;
  final Widget Function(int columnIndex, int rowIndex) dataCellBuilder;
  final Widget cornerWidget;

  @override
  _LazyDataTableState createState() => table;

  void jumpTo(int column, int row) {
    table.jumpTo(column, row);
  }
}

class _LazyDataTableState extends State<LazyDataTable> {
  _SyncScrollController _horizontalControllers;
  _SyncScrollController _verticalControllers;

  @override
  void initState() {
    super.initState();
    this._horizontalControllers = _SyncScrollController(widget.rows + 1);
    this._verticalControllers = _SyncScrollController(2);
    this._verticalControllers.setOtherAxis(_horizontalControllers);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: widget.rowHeaderWidth,
          child: Column(
            children: <Widget>[
              // Corner widget
              SizedBox(
                height: widget.columnHeaderHeight,
                child: widget.cornerWidget,
              ),
              // Row headers
              Expanded(
                child: NotificationListener(
                  onNotification: (ScrollNotification notification) {
                    _verticalControllers.processNotification(notification, 1);
                    return true;
                  },
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      controller: _verticalControllers.addController(1),
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
        ),
        Expanded(
            child: Column(
          children: <Widget>[
            // Column headers
            SizedBox(
              height: widget.columnHeaderHeight,
              child: NotificationListener(
                onNotification: (ScrollNotification notification) {
                  _horizontalControllers.processNotification(
                      notification, widget.rows);
                  return true;
                },
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller:
                        _horizontalControllers.addController(widget.rows),
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
            ),
            // Main data
            Expanded(
              child: NotificationListener(
                onNotification: (ScrollNotification notification) {
                  _verticalControllers.processNotification(notification, 0);
                  return true;
                },
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    controller: _verticalControllers.addController(0),
                    itemCount: widget.rows,
                    itemBuilder: (_, i) {
                      return SizedBox(
                        height: widget.cellHeight,
                        child: NotificationListener(
                          onNotification: (ScrollNotification notification) {
                            _horizontalControllers.processNotification(
                                notification, i);
                            return true;
                          },
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              controller:
                                  _horizontalControllers.addController(i),
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

  jumpTo(int column, int row) {
    _horizontalControllers.jumpTo(column * widget.cellWidth);
    _verticalControllers.jumpTo(row * widget.cellHeight);
  }
}

class _SyncScrollController {
  _SyncScrollController(int size) {
    _scrollControllers = List<ScrollController>(size);
  }
  // TODO: Better solution for this.
  // It should just go to the _offset on load/attach, but I can't seem to figure that out.
  _SyncScrollController _otherAxis;
  List<ScrollController> _scrollControllers;

  ScrollController _scrollingController;
  bool _scrollingActive = false;
  double _offset = 0;

  setOtherAxis(_SyncScrollController other) {
    _otherAxis = other;
  }

  ScrollController addController(int i) {
    var temp = ScrollController();
    _scrollControllers[i] = temp;
    return temp;
  }

  jumpTo(double value) {
    _offset = value;
    update();
  }

  update() {
    for (ScrollController controller in _scrollControllers) {
      if (identical(_scrollingController, controller)) continue;
      if (controller != null && controller.hasClients) {
        controller.jumpTo(_offset);
      }
    }
  }

  processNotification(ScrollNotification notification, int index) {
    if (notification is ScrollStartNotification && !_scrollingActive) {
      _scrollingController = _scrollControllers[index];
      _scrollingActive = true;
      return;
    }

    if (identical(_scrollControllers[index], _scrollingController) &&
        _scrollingActive) {
      if (notification is ScrollEndNotification) {
        _scrollingController = null;
        _scrollingActive = false;
        return;
      }

      if (notification is ScrollUpdateNotification) {
        _offset = _scrollingController.offset;
        update();
        if (_otherAxis != null) _otherAxis.update();
      }
    }
  }
}

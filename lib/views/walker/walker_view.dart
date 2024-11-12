import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import './bottom_sheet.dart';

class WalkerView extends StatefulWidget {
  const WalkerView({super.key, required this.endPoint});
  final GeoPoint endPoint;

  @override
  State<WalkerView> createState() => _WalkerViewState();
}

class _WalkerViewState extends State<WalkerView> {
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();

  Widget? _sheetWidget;
  // Future<RoadInfo>? routeInfo;
  @override
  void initState() {
    super.initState();
    _sheetWidget = Sheet(
      sheet: _sheet,
      controller: _controller,
      endPoint: widget.endPoint,
    );
    _controller.addListener(_onChanged);
    // OSM map controller
  }

  void _onChanged() {
    final currentSize = _controller.size;
    if (currentSize <= 0.05) _collapse();
  }

  void _collapse() => _animateSheet(sheet.snapSizes!.first);

  void _anchor() => _animateSheet(sheet.snapSizes!.last);

  void _expand() => _animateSheet(sheet.maxChildSize);

  void _hide() => _animateSheet(sheet.minChildSize);

  void _animateSheet(double size) {
    _controller.animateTo(
      size,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  DraggableScrollableSheet get sheet =>
      (_sheet.currentWidget as DraggableScrollableSheet);

  @override
  Widget build(BuildContext context) {
    return _sheetWidget!;
  }
}

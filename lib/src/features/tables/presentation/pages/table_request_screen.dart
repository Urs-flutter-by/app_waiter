// lib/src/features/tables/presentation/pages/table_request_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/table_model.dart';
import '../widgets/table_info_widget.dart';
import '../widgets/request_section.dart';
import '../widgets/order_section.dart';


class TableRequestScreen extends ConsumerWidget {
  final TableModel table;

  const TableRequestScreen({
    super.key,
    required this.table,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _TableRequestScreenContent(
      table: table,
      ref: ref,
    );
  }
}

class _TableRequestScreenContent extends StatefulWidget {
  final TableModel table;
  final WidgetRef ref;

  const _TableRequestScreenContent({
    required this.table,
    required this.ref,
  });

  @override
  _TableRequestScreenContentState createState() => _TableRequestScreenContentState();
}

class _TableRequestScreenContentState extends State<_TableRequestScreenContent> {
  bool _isRequestConfirmed = false;
  bool _isOrderConfirmed = false;

  void _onRequestConfirmed() {
    setState(() {
      _isRequestConfirmed = true;
    });
  }

  void _onOrderConfirmed() {
    setState(() {
      _isOrderConfirmed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Стол №${widget.table.tableId.replaceAll('table_', '')}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableInfoWidget(table: widget.table),
            RequestSection(
              tableId: widget.table.tableId,
              hasGuestRequest: widget.table.hasGuestRequest,
              hasInProgressRequest: widget.table.hasInProgressRequest,
              isRequestConfirmed: _isRequestConfirmed,
              onRequestConfirmed: _onRequestConfirmed,
            ),
            OrderSection(
              tableId: widget.table.tableId,
              hasNewOrder: widget.table.hasNewOrder,
              hasInProgressOrder: widget.table.hasInProgressOrder,
              isOrderConfirmed: _isOrderConfirmed,
              onOrderConfirmed: _onOrderConfirmed,
            ),
          ],
        ),
      ),
    );
  }
}
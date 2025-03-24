import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/halls_provider.dart';


class HallsScreen extends ConsumerWidget {
  const HallsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hallsStream = ref.watch(hallsStreamProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(title: const Text('Залы и столы')),
        body: hallsStream.when(
          data: (halls) {
            if (halls.isEmpty) {
              return const Center(child: Text('Залы не загружены'));
            }
            return PageView.builder(
              itemCount: halls.length,
              itemBuilder: (context, index) {
                final hall = halls[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        hall.name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: hall.tables.length,
                        itemBuilder: (context, tableIndex) {
                          final table = hall.tables[tableIndex];
                          return ListTile(
                            leading: Icon(
                              Icons.table_bar,
                              color: table.status == 'free'
                                  ? Colors.green
                                  : table.status == 'occupied'
                                  ? Colors.red
                                  : Colors.orange,
                            ),
                            title: Text('Стол ${table.tableId}'),
                            subtitle: Text(
                              'Статус: ${table.status}, ${table.isOwn ? 'Свой' : 'Чужой'}',
                            ),
                            trailing: table.hasNewOrder || table.hasGuestRequest
                                ? Icon(
                              Icons.notifications,
                              color: table.hasNewOrder && table.hasGuestRequest
                                  ? Colors.orange
                                  : table.hasNewOrder
                                  ? Colors.yellow
                                  : Colors.red,
                            )
                                : null,
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Ошибка: $error')),
        ),
      ),
    );
  }
}
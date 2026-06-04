import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talonflow/features/diagrams/cubit/diagram_list_cubit.dart';
import 'package:talonflow/features/diagrams/cubit/diagram_list_state.dart';
import 'package:talonflow/features/diagrams/ui/widgets/diagram_list_empty.dart';
import 'package:talonflow/features/diagrams/ui/widgets/diagram_tile.dart';

class DiagramList extends StatelessWidget {
  const DiagramList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiagramListCubit, DiagramListState>(
      builder: (context, state) => switch (state) {
        DiagramListInitial() || DiagramListLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        DiagramListError(:final message) => Center(
          child: Text(
            message,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        DiagramListLoaded(:final diagrams) when diagrams.isEmpty =>
          const DiagramListEmpty(),
        DiagramListLoaded(:final diagrams) => ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: diagrams.length,
          itemBuilder: (_, index) => DiagramTile(diagram: diagrams[index]),
        ),
      },
    );
  }
}

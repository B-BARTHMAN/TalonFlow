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
      builder: (context, state) => switch (state.status) {
        DiagramListStatus.initial || DiagramListStatus.loading => const Center(
          child: CircularProgressIndicator(),
        ),
        DiagramListStatus.error => Center(
          child: Text(
            state.error ?? 'Something went wrong',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        DiagramListStatus.loaded when state.diagrams.isEmpty =>
          const DiagramListEmpty(),
        DiagramListStatus.loaded => ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: state.diagrams.length,
          itemBuilder: (_, index) =>
              DiagramTile(diagram: state.diagrams[index]),
        ),
      },
    );
  }
}

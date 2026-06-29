import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/note_model.dart';
import '../../../providers/notes_provider.dart';

class NoteCard extends ConsumerWidget {
  final NoteModel note;

  const NoteCard({
    super.key,
    required this.note,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Card(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        title: Text(
          note.title,
        ),
        subtitle: Text(
          note.content,
          maxLines: 2,
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete,
          ),
          onPressed: () {
            ref
                .read(
                  notesProvider
                      .notifier,
                )
                .deleteNote(
                  note.id,
                );
          },
        ),
      ),
    );
  }
}
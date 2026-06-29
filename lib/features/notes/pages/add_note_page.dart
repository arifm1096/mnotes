import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/notes_provider.dart';

class AddNotePage extends ConsumerStatefulWidget {
  const AddNotePage({
    super.key,
  });

  @override
  ConsumerState<AddNotePage>
      createState() =>
          _AddNotePageState();
}

class _AddNotePageState
    extends ConsumerState<AddNotePage> {
  final titleController =
      TextEditingController();

  final contentController =
      TextEditingController();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Note',
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller:
                  titleController,
              decoration:
                  const InputDecoration(
                labelText: 'Judul',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller:
                  contentController,
              maxLines: 8,
              decoration:
                  const InputDecoration(
                labelText: 'Isi Note',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FilledButton(
              onPressed: () async {
                await ref
                    .read(
                      notesProvider
                          .notifier,
                    )
                    .addNote(
                      titleController
                          .text,
                      contentController
                          .text,
                    );

                Navigator.pop(
                  context,
                );
              },
              child:
                  const Text('Simpan'),
            )
          ],
        ),
      ),
    );
  }
}
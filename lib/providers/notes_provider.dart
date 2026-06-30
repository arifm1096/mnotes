import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../data/local/notes_storage.dart';
import '../data/models/note_model.dart';

final notesStorageProvider = Provider((ref) => NotesStorage());

final notesProvider = StateNotifierProvider<NotesNotifier, List<NoteModel>>(
  (ref) => NotesNotifier(ref.read(notesStorageProvider)),
);

class NotesNotifier extends StateNotifier<List<NoteModel>> {
  final NotesStorage storage;

  NotesNotifier(this.storage) : super([]) {
    loadNotes();
  }

  Future<void> loadNotes() async {
    final notes = await storage.getNotes();
    print('LOAD NOTES');
    print(notes.length);

    state = notes;
  }

  Future<bool> addNote(String title, String content) async {
    print('SAVE NOTE');
    print('Title: $title');
    print('Content: $content');

    if (title == '' || content == '') {
      return false;
    }

    final note = NoteModel(
      id: const Uuid().v4(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
      updateAt: DateTime.now(),
    );

    await storage.saveNote(note);
    print('Data berhasil disimpan');
    await loadNotes();
    return true;
  }

  Future<void> updateNote(NoteModel note) async {
    note.updateAt = DateTime.now();

    await storage.saveNote(note);

    await loadNotes();
  }

  Future<void> deleteNote(String id) async {
    await storage.deleteNote(id);

    await loadNotes();
  }
}

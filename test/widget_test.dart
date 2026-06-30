import 'package:flutter_test/flutter_test.dart';

import 'package:mnotes/data/models/note_model.dart';
import 'package:mnotes/features/notes/pages/notes_page.dart';

void main() {
  test('filterNotesByKeyword matches title and content', () {
    final notes = [
      NoteModel(
        id: '1',
        title: 'Belajar Flutter',
        content: 'Membuat UI yang rapi',
        createdAt: DateTime(2024, 1, 1),
        updateAt: DateTime(2024, 1, 1),
      ),
      NoteModel(
        id: '2',
        title: 'Belanja',
        content: 'Beli kopi dan roti',
        createdAt: DateTime(2024, 1, 2),
        updateAt: DateTime(2024, 1, 2),
      ),
    ];

    final filtered = filterNotesByKeyword(notes, 'kopi');

    expect(filtered, hasLength(1));
    expect(filtered.first.id, '2');
  });
}

import 'package:hive/hive.dart';
import '../models/note_model.dart';

class NotesStorage {
  static const boxName = 'notes';

  Future<Box<NoteModel>> openBox() async {
    return await Hive.openBox<NoteModel>(boxName);
  }

  Future<List<NoteModel>> getNotes() async {
    final box = await openBox();
    return box.values.toList();
  }

  Future<void> saveNote(NoteModel note) async{
    final box = await openBox();
    await box.put(note.id, note);
  }

  Future <void> deleteNote(String id) async{
    final box = await openBox();
    await box.delete(id);
  }

  Future<void> save(NoteModel note) async {}

  Future<void> delete(String id) async {}
}
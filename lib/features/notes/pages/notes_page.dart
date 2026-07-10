import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/note_model.dart';
import '../../../providers/notes_provider.dart';
import '../../../providers/search_provider.dart';
import '../widgets/note_card.dart';
import 'add_note_page.dart';

List<NoteModel> filterNotesByKeyword(List<NoteModel> notes, String keyword) {
  final query = keyword.toLowerCase();

  return notes.where((note) {
    final title = note.title.toLowerCase();
    final content = note.content.toLowerCase();

    return title.contains(query) || content.contains(query);
  }).toList();
}

/// Urutkan note dari yang paling baru dibuat ke yang paling lama,
/// supaya note terbaru selalu tampil paling atas.
List<NoteModel> sortNotesByNewest(List<NoteModel> notes) {
  final sorted = [...notes];
  sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return sorted;
}

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(notesProvider);
    final keyword = ref.watch(searchProvider);

    final filteredNotes = sortNotesByNewest(
      filterNotesByKeyword(notes, keyword),
    );

    Widget nullCards() {
      const borderColor = Colors.black;
      const borderWidth = 2.5;
      const radius = 0.1;
      const shadowOffset = 5.0;

      return Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: shadowOffset,
              top: shadowOffset,
              right: -shadowOffset,
              bottom: -shadowOffset,
              child: Container(
                decoration: BoxDecoration(
                  color: borderColor,
                  borderRadius: BorderRadius.circular(radius),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF6FA8FF),
                borderRadius: BorderRadius.circular(1.0),
                border: Border.all(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  width: 1,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tidak ada catatan',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          'My Notes',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),

              /// SEARCH
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 240, 197, 141),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      ref.read(searchProvider.notifier).state = value;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Color.fromARGB(255, 65, 65, 65)),
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Color.fromARGB(255, 65, 65, 65)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: filteredNotes.isEmpty
                    ? Center(child: nullCards())
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 4, bottom: 24),
                        itemCount: filteredNotes.length,
                        itemBuilder: (context, index) {
                          return NoteCard(
                            note: filteredNotes[index],
                            index: index,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Material(
        type: MaterialType.transparency, // ini kuncinya, bikin beneran transparan
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF90D5FF),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.black, width: 3.0),
            
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                top: -20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddNotePage()),
                    );
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFA1FF8D),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      border: Border.all(color: Colors.black, width: 2.0),
                    ),
                    child: const Icon(Icons.add, color: Colors.black, size: 35),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

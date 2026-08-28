import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mnotes/features/notes/widgets/iklan_banner.dart';
import 'package:mnotes/features/notes/widgets/search.dart';
import '../../../data/models/note_model.dart';
import '../../../providers/notes_provider.dart';
import '../../../providers/search_provider.dart';
import '../widgets/note_card.dart';

List<NoteModel> filterNotesByKeyword(List<NoteModel> notes, String keyword) {
  final query = keyword.toLowerCase();

  return notes.where((note) {
    final title = note.title.toLowerCase();
    final content = note.content.toLowerCase();

    return title.contains(query) || content.contains(query);
  }).toList();
}

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
                color: const Color.fromARGB(255, 136, 155, 133),
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
                    'Notes Not Found',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
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
      extendBody: false,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          'My Notes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32,
            color: Color.fromARGB(255, 27, 27, 27),
            fontFamily: 'Poppins',
          ),
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

              SearchWidget(searchController: searchController),

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

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: SizedBox(
          width: 145,
          height: 50,
          child: InkWell(
            onTap: () {
              context.go('/add-note/new');
            },
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  right: 0,
                  top: 3,
                  left: 3,
                  child: Container(
                    width: 140,
                    height: 47,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
                // Lapisan Konten Utama (Kotak Biru)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 140,
                    height: 47,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 136, 155, 133),
                      borderRadius: BorderRadius.zero,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Icon(Icons.add, color: Colors.black, size: 25),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            "Add Notes",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: const SafeArea(
        child: SizedBox(height: 55, child: IklanBanner()),
      ),
    );
  }
}

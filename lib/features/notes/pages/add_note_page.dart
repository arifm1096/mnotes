import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/note_model.dart';
import '../../../providers/notes_provider.dart';

class AddNotePage extends ConsumerStatefulWidget {
  final NoteModel? note;
  const AddNotePage({super.key, this.note});

  @override
  ConsumerState<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends ConsumerState<AddNotePage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xffd4af37)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.push_pin_outlined, color: Color(0xffd4af37)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xffd4af37)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Color(0xffd4af37)),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
              const SizedBox(height: 15),

              /// Judul
              TextField(
                controller: titleController,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),

              /// Isi note
              Expanded(
                child: TextField(
                  controller: contentController,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(fontSize: 18, height: 1.5),
                  decoration: const InputDecoration(
                    hintText: 'Start typing...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      /// Bottom Navigation seperti Apple Notes
      bottomNavigationBar: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.checklist, color: Color(0xffd4af37)),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.attach_file, color: Color(0xffd4af37)),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.camera_alt_outlined,
                color: Color(0xffd4af37),
              ),
            ),

            /// Tombol simpan tetap menggunakan fungsi lama
            IconButton(
              onPressed: () async {
                if (widget.note == null) {
                  await ref
                      .read(notesProvider.notifier)
                      .addNote(titleController.text, contentController.text);
                } else {
                  widget.note!.title = titleController.text;
                  widget.note!.content = contentController.text;

                  await ref
                      .read(notesProvider.notifier)
                      .updateNote(widget.note!);
                }

                if (mounted) {
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.done, color: Color(0xffd4af37)),
            ),
          ],
        ),
      ),
    );
  }
}

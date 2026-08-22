import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mnotes/features/notes/widgets/iklan_banner.dart';
import 'package:mnotes/features/notes/widgets/note_bottom_bar.dart';
import '../../../data/models/note_model.dart';
import '../../../providers/notes_provider.dart';

class AddNotePage extends ConsumerStatefulWidget {
  final NoteModel? note;
  final String? id;
  const AddNotePage({super.key, this.note,this.id});

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

  void _loadExistingNote() {
    if(widget.id != null && widget.id != 'new') {
      final notes = ref.read(notesProvider);

      try {
        existingNote = notes.fir
      } catch (e) {
        
      }
    }
  }

  void _insertBullet() {
    final text = contentController.text;
    final selection = contentController.selection;
    String bulletText = '• ';

    if (selection.baseOffset != -1) {
      final start = selection.start;
      final end = selection.end;
      if (start > 0 && text[start - 1] != '\n') {
        bulletText = '\n';
      }
      final newText = text.replaceRange(start, end, bulletText);
      contentController.value = contentController.value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: start + bulletText.length),
      );
    }
  }

  Future<void> _saveNote() async {
    // 1. Tutup keyboard terlebih dahulu untuk mencegah UI freeze saat pindah halaman
    FocusScope.of(context).unfocus();

    // 2. (Opsional) Validasi: Jangan simpan jika judul dan isi kosong
    if (titleController.text.trim().isEmpty &&
        contentController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Judul atau isi catatan tidak boleh kosong'),
          ),
        );
      }
      return; // Hentikan fungsi di sini
    }

    try {
      if (widget.note == null) {
        // Tambah Catatan Baru
        await ref
            .read(notesProvider.notifier)
            .addNote(titleController.text, contentController.text);
      } else {
        // Update Catatan Lama
        widget.note!.title = titleController.text;
        widget.note!.content = contentController.text;
        await ref.read(notesProvider.notifier).updateNote(widget.note!);
      }

      // 3. Jika berhasil menyimpan, kembali ke halaman utama
      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      // 4. Tangkap error jika Hive / Provider bermasalah
      print("🚨 ERROR SAAT MENYIMPAN: $e");

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan catatan: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const _colorIcon = Color(0xFFF7CB46); // Warna emas untuk ikon
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 136, 155, 133),
        elevation: 0,
        surfaceTintColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.0),
          child: Container(color: Colors.black, height: 3.0),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: _colorIcon),
          onPressed: () {
            context.go('/');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.push_pin_outlined, color: _colorIcon),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: _colorIcon),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: _colorIcon),
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _colorIcon,
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(3, 3)),
                  ],
                ),
                child: Text(
                  '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 14, 13, 13),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                  ),
                ),
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
                  hintStyle: TextStyle(color: Colors.black38),
                  border: InputBorder.none,
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
                    hintStyle: TextStyle(color: Colors.black38),
                    border: InputBorder.none,
                  ),
                ),
              ),

              IklanBanner(),
            ],
          ),
        ),
      ),

      /// Bottom Navigation seperti Apple Notes
      bottomNavigationBar: NoteBottomBar(
        onChecklistPressed: _insertBullet,
        onSavePressed: _saveNote,
      ),
    );
  }
}

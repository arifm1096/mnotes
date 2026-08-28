import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mnotes/features/notes/widgets/iklan_banner.dart';
import 'package:mnotes/features/notes/widgets/note_bottom_bar.dart';
import 'package:mnotes/utils/note_content_utils.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/note_model.dart';
import '../../../providers/notes_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cross_file/cross_file.dart';
import 'package:image_picker/image_picker.dart' show ImageSource, ImagePicker;

class AddNotePage extends ConsumerStatefulWidget {
  final NoteModel? note;
  final String? id;
  const AddNotePage({super.key, this.note, this.id});

  @override
  ConsumerState<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends ConsumerState<AddNotePage> {
  final titleController = TextEditingController();
  late QuillController contentController;
  NoteModel? _existingNote;

  @override
  void initState() {
    super.initState();
    contentController = QuillController.basic();

    if (widget.note != null) {
      _existingNote = widget.note;
      titleController.text = widget.note!.title;

      contentController = QuillController(
        document: NoteContentUtils.parseContent(widget.note!.content),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else if (widget.id != null && widget.id != 'new') {
      _loadExistingNote();
    }
  }

  void _loadExistingNote() {
    if (widget.id != null && widget.id != 'new') {
      final notes = ref.read(notesProvider);

      try {
        final existingNote = notes.firstWhere((note) => note.id == widget.id);
        setState(() {
          _existingNote = existingNote;
          titleController.text = existingNote.title;
          contentController = QuillController(
            document: NoteContentUtils.parseContent(existingNote.content),
            selection: const TextSelection.collapsed(offset: 0),
          );
        });

        print("✅ NOTE DITEMUKAN: ${existingNote.title}");
      } catch (e) {
        print("🚨 NOTE TIDAK DITEMUKAN: $e");
      }
    }
  }

  Future<String> _saveImageLocally(XFile pickedFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${appDir.path}/note_images');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }
    final fileName = '${const Uuid().v4()}${p.extension(pickedFile.path)}';
    final savedPath = '${imageDir.path}/$fileName';

    await pickedFile.saveTo(
      savedPath,
    ); // XFile punya method saveTo(), bukan copy()

    return savedPath;
  }

  Future<void> _saveNote() async {
    FocusScope.of(context).unfocus();
    final contentJson = NoteContentUtils.toJsonString(
      contentController.document,
    );
    final isContentEmpty = contentController.document
        .toPlainText()
        .trim()
        .isEmpty;

    if (titleController.text.trim().isEmpty && isContentEmpty) {
      if (mounted) {
        context.go('/');
      }
      return;
    }

    try {
      if (_existingNote == null) {
        await ref
            .read(notesProvider.notifier)
            .addNote(titleController.text, contentJson);
      } else {
        _existingNote!.title = titleController.text;
        _existingNote!.content = contentJson;
        await ref.read(notesProvider.notifier).updateNote(_existingNote!);
      }

      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      print("🚨 ERROR SAAT MENYIMPAN: $e");

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan catatan: $e')));
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<ImageSource?> showModalImage(BuildContext context) async {
    return await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Ambil dari Kamera'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const colorIcon = Color(0xFFF7CB46); // Warna emas untuk ikon
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
          icon: const Icon(Icons.arrow_back_ios, color: colorIcon),
          onPressed: _saveNote,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.push_pin_outlined, color: colorIcon),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: colorIcon),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: colorIcon),
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
                  color: colorIcon,
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
                child: QuillEditor.basic(
                  controller: contentController,
                  config: QuillEditorConfig(
                    padding: EdgeInsets.zero,
                    embedBuilders: kIsWeb
                        ? FlutterQuillEmbeds.editorWebBuilders()
                        : FlutterQuillEmbeds.editorBuilders(),
                    placeholder: 'Start typing...',
                  ),
                ),
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: QuillSimpleToolbar(
                  controller: contentController,
                  config: QuillSimpleToolbarConfig(
                    embedButtons: FlutterQuillEmbeds.toolbarButtons(
                      imageButtonOptions: QuillToolbarImageButtonOptions(
                        imageButtonConfig: QuillToolbarImageConfig(
                          onRequestPickImage: (context) async {
                            // Munculkan pilihan: Kamera atau Galeri
                            final source = await showModalImage(context);

                            if (source == null)
                              return null; // user batal pilih sumber

                            final picker = ImagePicker();
                            final xfile = await picker.pickImage(
                              source: source,
                            );
                            if (xfile == null)
                              return null; // user batal ambil/pilih foto

                            return await _saveImageLocally(xfile);
                          },
                        ),
                      ),
                    ),
                    showFontFamily: false,
                    showFontSize: false,
                    showSubscript: false,
                    showSuperscript: false,
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
        onChecklistPressed: () {
          contentController.formatSelection(Attribute.ul); // toggle bullet list
        },
        onSavePressed: _saveNote,
        onImagePressed: () => showModalImage(context),
      ),
    );
  }
}

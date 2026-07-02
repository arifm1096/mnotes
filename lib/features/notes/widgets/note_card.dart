import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/note_model.dart';
import '../../../providers/notes_provider.dart';

class NoteCard extends ConsumerWidget {
  final NoteModel note;
  final int index;

  const NoteCard({super.key, required this.note, required this.index});

  /// Warna berdasarkan urutan index, palet flat ala neobrutalism
  Color _getCardColor(int index) {
    final colors = [
      const Color(0xFFFF6F91), // pink
      const Color(0xFFFFC75F), // kuning
      const Color(0xFF6FE3C4), // hijau mint
      const Color(0xFF6FA8FF), // biru
    ];

    return colors[index % colors.length];
  }

  String shortContent(String text) {
    if (text.length <= 40) return text;
    return '${text.substring(0, 40)}...';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _getCardColor(index);
    const borderColor = Colors.black;
    const borderWidth = 2.5;
    const radius = 1.0;
    const shadowOffset = 6.0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // HARD SHADOW (blok hitam solid di belakang, bukan blur)
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

          // CARD UTAMA
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: borderColor, width: borderWidth),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ikon bulat outline hitam, ala simbol "!" di referensi
                    Container(
                      width: 26,
                      height: 26,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(
                          BorderSide(color: borderColor, width: 2),
                        ),
                      ),
                      child: const Icon(
                        Icons.edit_note,
                        size: 16,
                        color: borderColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        note.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // TODO: hubungkan ke field isFavorite di NoteModel
                      },
                      child: const Icon(
                        Icons.star_border,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  shortContent(note.content),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      note.createdAt.toString(),
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1.0),
                                side: const BorderSide(
                                  color: borderColor,
                                  width: 2,
                                ),
                              ),
                              title: const Text(
                                'Anda Yakin Hapus ?',
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                              content: Text(note.title),
                              actions: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey.shade700,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text('Batal'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text(
                                    'Hapus',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirm == true) {
                          ref.read(notesProvider.notifier).deleteNote(note.id);
                        }
                      },
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

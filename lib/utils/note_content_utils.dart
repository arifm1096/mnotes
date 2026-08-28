import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart';

class NoteContentUtils {
  static Document parseContent(String raw) {
    if (raw.trim().isEmpty) return Document();

    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return Document.fromJson(decoded);
      }
    } catch (_) {
      // Bukan JSON valid -> berarti note lama berisi plain text
    }

    final doc = Document();
    doc.insert(0, raw);
    return doc;
  }

  /// Ubah Document jadi String JSON, siap disimpan ke Hive.
  static String toJsonString(Document document) {
    return jsonEncode(document.toDelta().toJson());
  }

  /// Ambil ringkasan teks polos untuk ditampilkan di card (tanpa render gambar).
  static String plainTextPreview(String raw, {int maxLength = 100}) {
    final text = parseContent(raw).toPlainText().replaceAll('\n', ' ').trim();
    return text.length > maxLength ? '${text.substring(0, maxLength)}…' : text;
  }
}
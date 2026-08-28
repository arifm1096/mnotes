import 'package:flutter/material.dart';

class NoteBottomBar extends StatelessWidget {
  final VoidCallback onChecklistPressed;
  final VoidCallback onSavePressed;
  final VoidCallback onImagePressed;
  Color get _colorIcon => Color(0xFFF7CB46);

  const NoteBottomBar({
    super.key,
    required this.onChecklistPressed,
    required this.onSavePressed,
    required this.onImagePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 136, 155, 133),
        border: Border(
          top: BorderSide(color: Colors.black, width: 3.5), // Garis atas hitam tebal
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onChecklistPressed,
            icon: Icon(Icons.checklist, color: _colorIcon),
          ),
          IconButton(
            onPressed: onChecklistPressed,
            icon: Icon(Icons.camera_alt_outlined, color: _colorIcon),
          ),
          IconButton(
            onPressed: onSavePressed,
            icon: Icon(Icons.done, color: _colorIcon),
            tooltip: 'Simpan',
          ),
        ],
      ),
    );
  }
}

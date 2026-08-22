import 'package:flutter/material.dart';

class NoteBottomBar extends StatelessWidget {
  final VoidCallback onChecklistPressed;
  final VoidCallback onSavePressed;
  Color get _colorIcon => Color(0xFFF7CB46);

  const NoteBottomBar({
    super.key,
    required this.onChecklistPressed,
    required this.onSavePressed,
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
            onPressed: () {},
            icon: Icon(Icons.attach_file, color: _colorIcon),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.camera_alt_outlined, color: _colorIcon),
          ),
          IconButton(
            onPressed: onSavePressed,
            icon: Icon(Icons.done, color: _colorIcon),
          ),
        ],
      ),
    );
  }
}

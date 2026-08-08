import 'package:go_router/go_router.dart';
import '../features/notes/pages/notes_page.dart';
import '../features/notes/pages/add_note_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const NotesPage(),
    ),
    GoRoute(
      path: '/note-add',
      builder: (context, state) => const AddNotePage(),
    ),
  ],
);
import 'package:go_router/go_router.dart';
import '../features/notes/pages/notes_page.dart';
import '../features/notes/pages/add_note_page.dart';

final router = GoRouter(
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
    // GoRoute(
    //   path: '/profile',
    //   builder: (context, state) => const ProfilePage(),
    // ),
    // GoRoute(
    //   path: '/detail/:id',
    //   builder: (context, state) {
    //     final id = state.pathParameters['id'];
    //     return DetailPage(id: id!);
    //   },
    // ),
  ],
);
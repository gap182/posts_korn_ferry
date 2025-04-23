import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posts_korn_ferry/firebase_options.dart';
import 'features/home/data/datasources/posts_data_source_impl.dart';
import 'features/home/data/repositories/posts_repository_impl.dart';
import 'features/home/state/posts_provider.dart';
import 'common/repositories/post_repository.dart';
import 'features/home/presentation/ui/post_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PostRepository>(create: (_) => PostRepository()),
        Provider<PostsDataSourceImpl>(
          create:
              (context) => PostsDataSourceImpl(context.read<PostRepository>()),
        ),
        Provider<PostsRepositoryImpl>(
          create:
              (context) =>
                  PostsRepositoryImpl(context.read<PostsDataSourceImpl>()),
        ),
        ChangeNotifierProvider<PostsProvider>(
          create:
              (context) => PostsProvider(context.read<PostsRepositoryImpl>()),
        ),
      ],
      child: MaterialApp(home: const PostScreen()),
    );
  }
}

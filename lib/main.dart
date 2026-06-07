import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';
import 'feedback_bloc.dart';
import 'database_service.dart';
import 'home.dart';
import 'login_screen.dart';
import 'screens/loading_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const FeedbackFlowApp());
}

class FeedbackFlowApp extends StatelessWidget {
  const FeedbackFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FeedbackBloc>(
          create: (context) => FeedbackBloc(databaseService: DatabaseService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Feedback Flow',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const LoadingScreen(),
      ),
    );
  }
}

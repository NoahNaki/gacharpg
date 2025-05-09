import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/game_provider.dart';
import 'providers/combat_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const GearRollerApp());
}

class GearRollerApp extends StatelessWidget {
  const GearRollerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(
          create: (context) => CombatProvider(
            gameProvider: context.read<GameProvider>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gear Roller Auto‑Battler',
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          textTheme: GoogleFonts.robotoTextTheme(
            ThemeData(brightness: Brightness.dark).textTheme,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

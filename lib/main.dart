import 'dart:io';
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:developer' as devtools;
import 'firebase_options.dart';

// ========================================
// DESIGN SYSTEM - CONSISTENT STYLING
// ========================================

// Color Palette
const Color kFruityYellow = Color(0xFFFFF9C4);
const Color kFruityOrange = Color(0xFFFFCC80);
const Color kFruityRed = Color(0xFFFF8A80);
const Color kFruityAccent = Color(0xFFFF7043);

// Text Colors - Ensures proper contrast
const Color kTextDark = Color(0xFF2C2C2C);
const Color kTextMedium = Color(0xFF5A5A5A);
const Color kTextLight = Color(0xFF8A8A8A);
const Color kTextOnAccent = Colors.white;

// Border & Shadow
const double kBorderWidth = 2.0;
const double kBorderRadius = 20.0;
const Color kBorderColor = kFruityAccent;
const Color kBorderSecondary = kFruityOrange;

// Box Shadow
List<BoxShadow> kBoxShadow = [
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 15,
    offset: const Offset(0, 5),
    spreadRadius: 0,
  ),
];

List<BoxShadow> kBoxShadowElevated = [
  BoxShadow(
    color: Colors.black.withOpacity(0.15),
    blurRadius: 25,
    offset: const Offset(0, 8),
    spreadRadius: 2,
  ),
];

// Gradient Backgrounds
const LinearGradient kPrimaryGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [kFruityYellow, kFruityOrange, kFruityRed],
);

const LinearGradient kSecondaryGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [kFruityYellow, kFruityOrange],
);

// Stylish Container Box Decoration
BoxDecoration kStyledBoxDecoration({
  Color? backgroundColor,
  Color? borderColor,
  double? borderRadius,
}) {
  return BoxDecoration(
    color: backgroundColor ?? Colors.white,
    borderRadius: BorderRadius.circular(borderRadius ?? kBorderRadius),
    border: Border.all(color: borderColor ?? kBorderColor, width: kBorderWidth),
    boxShadow: kBoxShadow,
  );
}

// Stylish Card Box Decoration
BoxDecoration kStyledCardDecoration({Color? borderColor}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(kBorderRadius),
    border: Border.all(color: borderColor ?? kBorderColor, width: kBorderWidth),
    boxShadow: kBoxShadowElevated,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fruit Slice Detector',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kFruityAccent),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              kFruityYellow, // light yellow
              kFruityOrange, // orange
              kFruityRed, // red
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 80,
              left: 40,
              child: Opacity(
                opacity: 0.2,
                child: Icon(Icons.local_pizza, size: 60, color: kFruityAccent),
              ),
            ),
            Positioned(
              bottom: 100,
              right: 40,
              child: Opacity(
                opacity: 0.2,
                child: Icon(Icons.brightness_5, size: 70, color: kFruityAccent),
              ),
            ),
            Center(
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: _controller,
                  curve: Curves.easeOutBack,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [kFruityOrange, kFruityRed],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.local_pizza,
                          size: 70,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Slice Fruit Detector',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: kFruityAccent,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Detect your fruit slices instantly!',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: kFruityAccent,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ========================================
// HOME PAGE
// ========================================

// Fruit Slice Icons Helper - Creates faded fruit slice decorations
class _FruitSliceIcon extends StatelessWidget {
  final String fruitType;
  final double size;

  const _FruitSliceIcon({required this.fruitType, this.size = 50});

  Color _getFruitColor() {
    switch (fruitType) {
      case 'Orange':
        return const Color(0xFFFFA726);
      case 'Lemon':
        return const Color(0xFFFFEB3B);
      case 'Grapefruit':
        return const Color(0xFFFFB3BA);
      case 'Apple':
        return const Color(0xFFFF5252);
      case 'Watermelon':
        return const Color(0xFFFF6B9D);
      case 'Strawberry':
        return const Color(0xFFE91E63);
      case 'Kiwi':
        return const Color(0xFF9CCC65);
      case 'Pineapple':
        return const Color(0xFFFFC107);
      case 'Banana':
        return const Color(0xFFFFF176);
      case 'Mango':
        return const Color(0xFFFFA000);
      default:
        return kFruityAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getFruitColor();

    // Create a slice-like appearance using CustomPaint
    return CustomPaint(
      size: Size(size, size),
      painter: _FruitSlicePainter(color: color, fruitType: fruitType),
    );
  }
}

// Custom Painter for Fruit Slices
class _FruitSlicePainter extends CustomPainter {
  final Color color;
  final String fruitType;

  _FruitSlicePainter({required this.color, required this.fruitType});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Different slice angles for variety
    double sliceAngle;
    if (fruitType == 'Banana') {
      sliceAngle = 0.6; // Curved banana shape
    } else if (fruitType == 'Strawberry' || fruitType == 'Kiwi') {
      sliceAngle = 0.9; // Wider slice
    } else if (fruitType == 'Pineapple') {
      sliceAngle = 0.5; // Narrower slice
    } else {
      sliceAngle = 0.8; // Standard citrus slice
    }

    // Draw the slice/wedge shape
    final fillPaint = Paint()
      ..color = color.withOpacity(0.35)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color.withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(center.dx + radius * 0.85, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius * 0.85),
        0,
        sliceAngle,
        false,
      )
      ..close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);

    // Add details specific to each fruit type
    if (fruitType == 'Orange' ||
        fruitType == 'Lemon' ||
        fruitType == 'Grapefruit') {
      // Center circle for citrus fruits
      canvas.drawCircle(
        center,
        radius * 0.18,
        Paint()..color = color.withOpacity(0.4),
      );
      // Add some radial lines (segments)
      for (int i = 0; i < 4; i++) {
        final angle = (i * sliceAngle / 4);
        final endPoint = Offset(
          center.dx + (radius * 0.6) * math.cos(angle * 1.5),
          center.dy + (radius * 0.6) * math.sin(angle * 1.5),
        );
        canvas.drawLine(
          center,
          endPoint,
          Paint()
            ..color = color.withOpacity(0.3)
            ..strokeWidth = 1,
        );
      }
    }

    // Add seeds/details for specific fruits
    if (fruitType == 'Kiwi') {
      final seedPaint = Paint()..color = Colors.black.withOpacity(0.4);
      for (var seedOffset in [
        Offset(radius * 0.3, radius * 0.2),
        Offset(radius * 0.5, radius * 0.1),
        Offset(radius * 0.4, radius * 0.35),
      ]) {
        canvas.drawCircle(center + seedOffset, radius * 0.04, seedPaint);
      }
    }

    if (fruitType == 'Strawberry') {
      final seedPaint = Paint()..color = color.withOpacity(0.6);
      for (var seedOffset in [
        Offset(radius * 0.35, radius * 0.25),
        Offset(radius * 0.55, radius * 0.15),
        Offset(radius * 0.45, radius * 0.4),
      ]) {
        canvas.drawCircle(center + seedOffset, radius * 0.03, seedPaint);
      }
    }

    if (fruitType == 'Watermelon') {
      // Add rind (outer edge)
      final rindPath = Path()
        ..addOval(Rect.fromCircle(center: center, radius: radius * 0.85));
      canvas.drawPath(
        rindPath,
        Paint()
          ..color = Colors.green.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(currentIndex: 0),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.menu, color: kFruityAccent, size: 24),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Slice Fruit Detector',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: kFruityAccent,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                shadows: [
                  Shadow(
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: kPrimaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Main Content Box - Centered with Fruit Decorations
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final screenHeight = constraints.maxHeight;
                    final screenWidth = constraints.maxWidth;

                    return Stack(
                      children: [
                        // Faded Fruit Slice Decorations Around Container
                        // Positioned fruits that adapt to screen size
                        // Top Left
                        Positioned(
                          top: screenHeight * 0.08,
                          left: screenWidth * 0.05,
                          child: Opacity(
                            opacity: 0.15,
                            child: Transform.rotate(
                              angle: -0.5,
                              child: const _FruitSliceIcon(
                                fruitType: 'Orange',
                                size: 45,
                              ),
                            ),
                          ),
                        ),

                        // Top Right
                        Positioned(
                          top: screenHeight * 0.10,
                          right: screenWidth * 0.08,
                          child: Opacity(
                            opacity: 0.18,
                            child: Transform.rotate(
                              angle: 0.6,
                              child: const _FruitSliceIcon(
                                fruitType: 'Lemon',
                                size: 50,
                              ),
                            ),
                          ),
                        ),

                        // Left Side Top
                        Positioned(
                          left: screenWidth * 0.02,
                          top: screenHeight * 0.25,
                          child: Opacity(
                            opacity: 0.12,
                            child: Transform.rotate(
                              angle: 0.3,
                              child: const _FruitSliceIcon(
                                fruitType: 'Apple',
                                size: 40,
                              ),
                            ),
                          ),
                        ),

                        // Right Side Top
                        Positioned(
                          right: screenWidth * 0.04,
                          top: screenHeight * 0.22,
                          child: Opacity(
                            opacity: 0.16,
                            child: Transform.rotate(
                              angle: -0.4,
                              child: const _FruitSliceIcon(
                                fruitType: 'Watermelon',
                                size: 48,
                              ),
                            ),
                          ),
                        ),

                        // Left Side Middle
                        Positioned(
                          left: screenWidth * 0.06,
                          top: screenHeight * 0.45,
                          child: Opacity(
                            opacity: 0.10,
                            child: Transform.rotate(
                              angle: -0.8,
                              child: const _FruitSliceIcon(
                                fruitType: 'Pineapple',
                                size: 38,
                              ),
                            ),
                          ),
                        ),

                        // Right Side Middle
                        Positioned(
                          right: screenWidth * 0.08,
                          top: screenHeight * 0.48,
                          child: Opacity(
                            opacity: 0.11,
                            child: Transform.rotate(
                              angle: 0.5,
                              child: const _FruitSliceIcon(
                                fruitType: 'Mango',
                                size: 43,
                              ),
                            ),
                          ),
                        ),

                        // Bottom Left
                        Positioned(
                          bottom: screenHeight * 0.35,
                          left: screenWidth * 0.06,
                          child: Opacity(
                            opacity: 0.14,
                            child: Transform.rotate(
                              angle: 0.7,
                              child: const _FruitSliceIcon(
                                fruitType: 'Strawberry',
                                size: 42,
                              ),
                            ),
                          ),
                        ),

                        // Bottom Right
                        Positioned(
                          bottom: screenHeight * 0.33,
                          right: screenWidth * 0.05,
                          child: Opacity(
                            opacity: 0.13,
                            child: Transform.rotate(
                              angle: -0.6,
                              child: const _FruitSliceIcon(
                                fruitType: 'Kiwi',
                                size: 44,
                              ),
                            ),
                          ),
                        ),

                        // Additional scattered fruits
                        Positioned(
                          bottom: screenHeight * 0.45,
                          left: screenWidth * 0.10,
                          child: Opacity(
                            opacity: 0.09,
                            child: Transform.rotate(
                              angle: 1.0,
                              child: const _FruitSliceIcon(
                                fruitType: 'Banana',
                                size: 40,
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: screenHeight * 0.42,
                          right: screenWidth * 0.12,
                          child: Opacity(
                            opacity: 0.12,
                            child: Transform.rotate(
                              angle: -0.9,
                              child: const _FruitSliceIcon(
                                fruitType: 'Grapefruit',
                                size: 46,
                              ),
                            ),
                          ),
                        ),

                        // Main Content Box - Centered
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 400),
                              decoration: kStyledCardDecoration(),
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Icon Circle
                                    Container(
                                      height: 140,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [kFruityOrange, kFruityRed],
                                        ),
                                        boxShadow: kBoxShadow,
                                        border: Border.all(
                                          color: kBorderColor,
                                          width: kBorderWidth,
                                        ),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.local_pizza,
                                          size: 75,
                                          color: kTextOnAccent,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 28),

                                    // Title Text
                                    Text(
                                      'Start a new scan',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: kTextDark,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    // Subtitle Text
                                    Text(
                                      'Tap the button below to begin',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.quicksand(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: kTextMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              // Bottom Action Bar
              Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                  border: Border(
                    top: BorderSide(color: kBorderColor, width: kBorderWidth),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle Indicator
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Primary Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyHomePage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kFruityAccent,
                          foregroundColor: kTextOnAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kBorderRadius),
                          ),
                          elevation: 4,
                        ),
                        icon: const Icon(Icons.camera_alt_outlined, size: 24),
                        label: Text(
                          'Scan Now',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Secondary Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HistoryPage(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: kFruityAccent,
                              side: const BorderSide(
                                color: kBorderSecondary,
                                width: kBorderWidth,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  kBorderRadius,
                                ),
                              ),
                            ),
                            icon: const Icon(Icons.history, size: 20),
                            label: Text(
                              'History',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const StatisticsPage(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: kFruityAccent,
                              side: const BorderSide(
                                color: kBorderSecondary,
                                width: kBorderWidth,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  kBorderRadius,
                                ),
                              ),
                            ),
                            icon: const Icon(Icons.bar_chart, size: 20),
                            label: Text(
                              'Graphs',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
    );
  }
}

// ========================================
// TOOLS LIST PAGE
// ========================================
class ToolsListPage extends StatelessWidget {
  const ToolsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(currentIndex: 1),
      appBar: AppBar(
        title: Text(
          'Detector Classes',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: kFruityAccent,
        foregroundColor: kTextOnAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: kSecondaryGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Section
                Text(
                  'Available Classes',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: kFruityAccent,
                  ),
                ),
                const SizedBox(height: 16),

                // Action Button
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyHomePage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kFruityAccent,
                        foregroundColor: kTextOnAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kBorderRadius),
                        ),
                        elevation: 4,
                      ),
                      icon: const Icon(Icons.camera_alt, size: 24),
                      label: Text(
                        'Proceed to Scan',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // List of Classes
                Expanded(
                  child: ListView(
                    children: const [
                      _ToolListItem(label: 'Orange Slice'),
                      _ToolListItem(label: 'Lemon Slice'),
                      _ToolListItem(label: 'Grapefruit Slice'),
                      _ToolListItem(label: 'Apple Slice'),
                      _ToolListItem(label: 'Watermelon Slice'),
                      _ToolListItem(label: 'Strawberry Slice'),
                      _ToolListItem(label: 'Kiwi Slice'),
                      _ToolListItem(label: 'Pineapple Slice'),
                      _ToolListItem(label: 'Banana Slice'),
                      _ToolListItem(label: 'Mango Slice'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 1),
    );
  }
}

// Tool List Item with Consistent Styling
class _ToolListItem extends StatelessWidget {
  final String label;

  const _ToolListItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: kStyledBoxDecoration(
          backgroundColor: Colors.white,
          borderColor: kBorderSecondary,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kFruityAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.check_circle_outline,
                color: kFruityAccent,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  color: kTextDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigation({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget destination;
    switch (index) {
      case 0:
        destination = const HomePage();
        break;
      case 1:
        destination = const MyHomePage();
        break;
      case 2:
        destination = const HistoryPage();
        break;
      case 3:
      default:
        destination = const StatisticsPage();
        break;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => destination),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) => _onItemTapped(context, index),
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: kFruityAccent,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Graphs',
            ),
          ],
        ),
      ),
    );
  }
}

// Sidebar Drawer Widget
class AppDrawer extends StatelessWidget {
  final int currentIndex;

  const AppDrawer({super.key, required this.currentIndex});

  void _navigateToPage(BuildContext context, int index) {
    Navigator.pop(context); // Close drawer first

    if (index == currentIndex) return;

    Widget destination;
    switch (index) {
      case 0:
        destination = const HomePage();
        break;
      case 1:
        destination = const MyHomePage();
        break;
      case 2:
        destination = const HistoryPage();
        break;
      case 3:
      default:
        destination = const StatisticsPage();
        break;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => destination),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(gradient: kSecondaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  border: Border(
                    bottom: BorderSide(
                      color: kFruityAccent.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: kFruityAccent,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: kBoxShadow,
                      ),
                      child: const Icon(
                        Icons.restaurant_menu,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Slice Fruit\nDetector',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: kTextDark,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Navigation Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  children: [
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.home,
                      title: 'Home',
                      index: 0,
                    ),
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.camera_alt,
                      title: 'Scan',
                      index: 1,
                    ),
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.list_alt,
                      title: 'Tools List',
                      index: 1,
                      isToolsList: true,
                    ),
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.history,
                      title: 'History',
                      index: 2,
                    ),
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.bar_chart,
                      title: 'Graphs',
                      index: 3,
                    ),
                  ],
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  border: Border(
                    top: BorderSide(
                      color: kFruityAccent.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  'Fruit Slice Detection App',
                  style: GoogleFonts.quicksand(
                    fontSize: 12,
                    color: kTextMedium,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required int index,
    bool isToolsList = false,
  }) {
    final isSelected = isToolsList
        ? false // Tools List doesn't have a specific index
        : (index == currentIndex);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? kFruityAccent.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? Border.all(color: kFruityAccent, width: 2) : null,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? kFruityAccent : Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : kTextDark,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? kFruityAccent : kTextDark,
          ),
        ),
        onTap: () {
          if (isToolsList) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ToolsListPage()),
            );
          } else {
            _navigateToPage(context, index);
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  File? filePath;
  String label = "";
  double confidence = 0.0;
  int _currentClassPage = 0;
  Map<String, double> _predictionDistribution = {};
  static const List<String> _availableClasses = [
    'Orange Slice',
    'Lemon Slice',
    'Grapefruit Slice',
    'Apple Slice',
    'Watermelon Slice',
    'Strawberry Slice',
    'Kiwi Slice',
    'Pineapple Slice',
    'Banana Slice',
    'Mango Slice',
  ];
  static const Map<String, String> _classImages = {
    'Orange Slice': 'assets/orange-slice.PNG',
    'Lemon Slice': 'assets/lemon-slice.PNG',
    'Grapefruit Slice': 'assets/Grapefruit.png',
    'Apple Slice': 'assets/apple-slice.jpg',
    'Watermelon Slice': 'assets/watermelon-slice.jpg',
    'Strawberry Slice': 'assets/sliced-strawberry.jpg',
    'Kiwi Slice': 'assets/kiwi-slice.jpg',
    'Pineapple Slice': 'assets/pineapple-slice.PNG',
    'Banana Slice': 'assets/banana-slice.png',
    'Mango Slice': 'assets/mango-slice.png',
  };
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late final PageController _classPageController;

  @override
  void initState() {
    super.initState();
    _tfiteInit();
    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _classPageController = PageController(viewportFraction: 0.85);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _classPageController.dispose();
    super.dispose();
    Tflite.close();
  }

  Future<void> _tfiteInit() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 4, // Increased threads for better performance
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  Widget _buildClassCarousel(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'What I can detect',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: kTextDark,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: kFruityAccent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kFruityAccent.withOpacity(0.3)),
              ),
              child: Text(
                '${_availableClasses.length} classes',
                style: GoogleFonts.quicksand(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kFruityAccent,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: isSmallScreen ? 220 : 240,
          child: PageView.builder(
            controller: _classPageController,
            itemCount: _availableClasses.length,
            onPageChanged: (index) {
              setState(() => _currentClassPage = index);
            },
            itemBuilder: (context, index) {
              final fruitClass = _availableClasses[index];
              final imagePath = _classImages[fruitClass];
              return AnimatedBuilder(
                animation: _classPageController,
                builder: (context, child) {
                  double scale = 1.0;
                  if (_classPageController.hasClients &&
                      _classPageController.position.haveDimensions) {
                    final currentPage = _classPageController.page ?? 0.0;
                    scale = (1 - (currentPage - index).abs() * 0.15).clamp(
                      0.9,
                      1.0,
                    );
                  }
                  return Transform.scale(scale: scale, child: child);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [kFruityYellow, kFruityOrange],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: kFruityAccent.withOpacity(0.2),
                      width: 1.5,
                    ),
                    boxShadow: kBoxShadow,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: imagePath != null
                              ? Image.asset(imagePath, fit: BoxFit.cover)
                              : Container(
                                  color: kFruityAccent.withOpacity(0.15),
                                  child: const Icon(
                                    Icons.local_pizza,
                                    color: kFruityAccent,
                                    size: 48,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        fruitClass,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kTextDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'High accuracy recognition',
                        style: GoogleFonts.quicksand(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: kTextMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _availableClasses.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: _currentClassPage == index ? 22 : 8,
              decoration: BoxDecoration(
                color: _currentClassPage == index
                    ? kFruityAccent
                    : kFruityAccent.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Copies image to permanent storage directory
  /// Returns the permanent file path that will be saved to Firestore
  /// Path format: /data/user/0/[package]/app_flutter/scans/scan_[timestamp].jpg
  Future<String?> _copyImageToPermanentStorage(File sourceFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'scan_$timestamp.jpg';
      final permanentPath = '${directory.path}/scans/$fileName';

      // Create scans directory if it doesn't exist
      final scansDir = Directory('${directory.path}/scans');
      if (!await scansDir.exists()) {
        await scansDir.create(recursive: true);
      }

      // Copy file to permanent location (not cache - this ensures file persists)
      final permanentFile = await sourceFile.copy(permanentPath);
      devtools.log('Image saved to permanent storage: ${permanentFile.path}');
      return permanentFile.path;
    } catch (e) {
      devtools.log('Error copying image to permanent storage: $e');
      return null;
    }
  }

  Future<void> _saveToHistory() async {
    if (filePath != null && label.isNotEmpty && label != "No class found") {
      try {
        // Copy image to permanent storage first
        final permanentPath = await _copyImageToPermanentStorage(filePath!);

        if (permanentPath == null) {
          devtools.log('Failed to copy image to permanent storage');
          return;
        }

        await FirestoreService.instance.insertScan({
          'label': label,
          'confidence': confidence,
          'image_path':
              permanentPath, // Use permanent path instead of temp path
          'date_time':
              FieldValue.serverTimestamp(), // Use Firestore Timestamp for proper date/time format
        });
      } catch (e) {
        devtools.log('Error saving to Firestore: $e');
        // Firestore will queue writes when offline, so this is expected
      }
    }
  }

  void _processRecognitions(List? recognitions) {
    if (recognitions == null || recognitions.isEmpty) {
      setState(() {
        label = "No class found";
        confidence = 0.0;
        _predictionDistribution = {};
      });
      return;
    }

    // Process all recognition results - include ALL classes returned by the model
    Map<String, double> distribution = {};
    double totalConfidence = 0.0;
    
    for (var recognition in recognitions) {
      if (recognition['label'] != null && recognition['confidence'] != null) {
        final rawLabel = recognition['label'].toString();
        final parts = rawLabel.split(' ');
        final className = parts.length > 1 ? parts.sublist(1).join(' ') : rawLabel;
        final rawConfidence = (recognition['confidence'] as num).toDouble() * 100;
        final confidenceValue = rawConfidence.clamp(0.0, 100.0);
        
        // Add all classes returned by the model
        distribution[className] = confidenceValue;
        totalConfidence += confidenceValue;
      }
    }

    // Also initialize all available classes at 0% if they weren't returned
    for (String className in _availableClasses) {
      if (!distribution.containsKey(className)) {
        distribution[className] = 0.0;
      }
    }

    // Calculate remaining percentage (100% - sum of all shown percentages)
    // This accounts for any classes not returned by the model or rounding differences
    double remainingPercentage = (100.0 - totalConfidence).clamp(0.0, 100.0);
    if (remainingPercentage > 0.01) {
      distribution['Other'] = remainingPercentage;
    }

    // Get the top result
    final firstResult = recognitions[0];
    final rawConfidence = (firstResult['confidence'] as num).toDouble() * 100;
    final detectedConfidence = rawConfidence.clamp(0.0, 100.0);

    // Lower threshold for better detection with 500 images per class
    // Model should be more accurate with larger dataset
    if (detectedConfidence < 20.0 || firstResult['label'] == null) {
      setState(() {
        label = "No class found";
        confidence = 0.0;
        _predictionDistribution = {};
      });
      return;
    }

    setState(() {
      confidence = detectedConfidence;
      final rawLabel = firstResult['label'].toString();
      final parts = rawLabel.split(' ');
      label = parts.length > 1 ? parts.sublist(1).join(' ') : rawLabel;
      _predictionDistribution = distribution;
    });
  }

  pickImageGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    var imageMap = File(image.path);

    setState(() {
      filePath = imageMap;
    });

    // Animate on image selection
    _animationController.reset();
    _animationController.forward();

    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 127.5, // Standard normalization mean
      imageStd: 127.5, // Standard normalization std (normalizes to [-1, 1])
      numResults: _availableClasses.length,
      threshold: 0.1, // Minimum confidence threshold (10%)
      asynch: true,
    );

    devtools.log(recognitions.toString());
    _processRecognitions(recognitions);

    // Animate result appearance
    _animationController.forward();

    // Save to history only if a valid class was detected
    if (label.isNotEmpty && label != "No class found") {
    await _saveToHistory();
    }
  }

  pickImageCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    var imageMap = File(image.path);

    setState(() {
      filePath = imageMap;
    });

    // Animate on image selection
    _animationController.reset();
    _animationController.forward();

    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 127.5, // Standard normalization mean
      imageStd: 127.5, // Standard normalization std (normalizes to [-1, 1])
      numResults: _availableClasses.length,
      threshold: 0.1, // Minimum confidence threshold (10%)
      asynch: true,
    );

    devtools.log(recognitions.toString());
    _processRecognitions(recognitions);

    // Animate result appearance
    _animationController.forward();

    // Save to history only if a valid class was detected
    if (label.isNotEmpty && label != "No class found") {
    await _saveToHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      drawer: const AppDrawer(currentIndex: 1),
      appBar: AppBar(
        title: Text(
          "Scan Fruit Slices",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: kFruityAccent,
        foregroundColor: kTextOnAccent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: kSecondaryGradient),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16 : 24,
                  vertical: 24,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isSmallScreen ? double.infinity : 500,
                      minHeight: constraints.maxHeight - 48,
                    ),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Main Scan Card - Centered with Animation
                              Container(
                                decoration: kStyledCardDecoration(),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    isSmallScreen ? 20 : 24,
                                  ),
                                  child: Column(
                                    children: [
                                      // Image Display Container with Hover Effect
                                      GestureDetector(
                                        onTap: pickImageGallery,
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          curve: Curves.easeInOut,
                                          height: isSmallScreen ? 250 : 280,
                                          width: double.infinity,
                                          decoration: kStyledBoxDecoration(
                                            backgroundColor: Colors.white,
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: filePath == null
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    AnimatedContainer(
                                                      duration: const Duration(
                                                        milliseconds: 300,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                            20,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: kFruityAccent
                                                            .withOpacity(0.1),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        Icons.image_outlined,
                                                        size: 60,
                                                        color: kFruityAccent,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    Text(
                                                      'Tap to choose a photo',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                            fontSize:
                                                                isSmallScreen
                                                                ? 14
                                                                : 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: kTextMedium,
                                                          ),
                                                    ),
                                                  ],
                                                )
                                              : Image.file(
                                                  filePath!,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),

                                      // Result Section with Animation
                                      AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 400,
                                        ),
                                        curve: Curves.easeInOut,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isSmallScreen ? 16 : 20,
                                          vertical: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: label.isEmpty
                                              ? Colors.grey[100]
                                              : kFruityAccent.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          border: Border.all(
                                            color: label.isEmpty
                                                ? Colors.grey[300]!
                                                : kFruityAccent.withOpacity(
                                                    0.3,
                                                  ),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              label.isEmpty
                                                  ? 'No item detected yet'
                                                  : (label == "No class found"
                                                        ? "No class found"
                                                        : label),
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: isSmallScreen
                                                    ? 20
                                                    : 22,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    (label.isEmpty ||
                                                        label ==
                                                            "No class found")
                                                    ? kTextMedium
                                                    : kTextDark,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              label.isEmpty
                                                  ? 'Take a photo or pick from gallery to start detecting.'
                                                  : (label == "No class found"
                                                        ? 'No valid class detected. Try again with a clearer image.'
                                                        : 'Accuracy: ${confidence.toStringAsFixed(0)}%'),
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.quicksand(
                                                fontSize: isSmallScreen
                                                    ? 13
                                                    : 14,
                                                fontWeight: FontWeight.w500,
                                                color: kTextMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 20 : 24),

                              // Collapsible Prediction Distribution Section
                              if (label.isNotEmpty && 
                                  label != "No class found" && 
                                  _predictionDistribution.isNotEmpty)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: kBorderColor,
                                      width: kBorderWidth,
                                    ),
                                    boxShadow: kBoxShadow,
                                  ),
                                  child: ExpansionTile(
                                    tilePadding: EdgeInsets.symmetric(
                                      horizontal: isSmallScreen ? 16 : 20,
                                      vertical: 8,
                                    ),
                                    childrenPadding: EdgeInsets.fromLTRB(
                                      isSmallScreen ? 16 : 20,
                                      0,
                                      isSmallScreen ? 16 : 20,
                                      isSmallScreen ? 16 : 20,
                                    ),
                                    title: Row(
                                      children: [
                                        Icon(
                                          Icons.bar_chart,
                                          color: kFruityAccent,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Prediction Distribution',
                                          style: GoogleFonts.poppins(
                                            fontSize: isSmallScreen ? 15 : 16,
                                            fontWeight: FontWeight.w600,
                                            color: kTextDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      'Tap to view detailed breakdown',
                                      style: GoogleFonts.quicksand(
                                        fontSize: isSmallScreen ? 11 : 12,
                                        color: kTextMedium,
                                      ),
                                    ),
                                    iconColor: kFruityAccent,
                                    collapsedIconColor: kFruityAccent,
                                    children: [
                                      // Result Header
                                      Row(
                                        children: [
                                          Text(
                                            'Result: ',
                                            style: GoogleFonts.poppins(
                                              fontSize: isSmallScreen ? 14 : 15,
                                              fontWeight: FontWeight.w600,
                                              color: kTextDark,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              label,
                                              style: GoogleFonts.poppins(
                                                fontSize: isSmallScreen ? 14 : 15,
                                                fontWeight: FontWeight.w700,
                                                color: kFruityAccent,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      
                                      // Prediction Distribution Header
                                      Text(
                                        'Prediction distribution',
                                        style: GoogleFonts.poppins(
                                          fontSize: isSmallScreen ? 13 : 14,
                                          fontWeight: FontWeight.w600,
                                          color: kTextDark,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      
                                      // Distribution List
                                      ...() {
                                        final sortedEntries = _predictionDistribution.entries
                                            .where((entry) => entry.value > 0.0)
                                            .toList()
                                          ..sort((a, b) => b.value.compareTo(a.value));
                                        
                                        return sortedEntries.map((entry) {
                                          final percentage = entry.value;
                                          final className = entry.key;
                                          return Container(
                                            margin: const EdgeInsets.only(bottom: 10),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    className,
                                                    style: GoogleFonts.quicksand(
                                                      fontSize: isSmallScreen ? 12 : 13,
                                                      fontWeight: FontWeight.w600,
                                                      color: kTextDark,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Container(
                                                    height: 4,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius: BorderRadius.circular(2),
                                                    ),
                                                    child: FractionallySizedBox(
                                                      alignment: Alignment.centerLeft,
                                                      widthFactor: percentage / 100.0,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: kFruityAccent,
                                                          borderRadius: BorderRadius.circular(2),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                SizedBox(
                                                  width: 65,
                                                  child: Text(
                                                    '${percentage.toStringAsFixed(2)}%',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: isSmallScreen ? 11 : 12,
                                                      fontWeight: FontWeight.w700,
                                                      color: kFruityAccent,
                                                    ),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList();
                                      }(),
                                    ],
                                  ),
                                ),
                              if (label.isNotEmpty && 
                                  label != "No class found" && 
                                  _predictionDistribution.isNotEmpty)
                                SizedBox(height: isSmallScreen ? 20 : 24),
                              
                              SizedBox(height: isSmallScreen ? 20 : 24),

                              // Action Buttons - Responsive with Animation
                              Row(
                                children: [
                                  Expanded(
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      curve: Curves.easeInOut,
                                      child: ElevatedButton.icon(
                                        onPressed: pickImageCamera,
                                        icon: Icon(
                                          Icons.camera_alt,
                                          size: isSmallScreen ? 20 : 22,
                                        ),
                                        label: Text(
                                          'Take Photo',
                                          style: GoogleFonts.poppins(
                                            fontSize: isSmallScreen ? 14 : 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kFruityAccent,
                                          foregroundColor: kTextOnAccent,
                                          padding: EdgeInsets.symmetric(
                                            vertical: isSmallScreen ? 14 : 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              kBorderRadius,
                                            ),
                                          ),
                                          elevation: 4,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: isSmallScreen ? 10 : 12),
                                  Expanded(
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      curve: Curves.easeInOut,
                                      child: OutlinedButton.icon(
                                        onPressed: pickImageGallery,
                                        icon: Icon(
                                          Icons.photo_library,
                                          size: isSmallScreen ? 20 : 22,
                                        ),
                                        label: Text(
                                          'Gallery',
                                          style: GoogleFonts.poppins(
                                            fontSize: isSmallScreen ? 14 : 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: kFruityAccent,
                                          side: const BorderSide(
                                            color: kBorderSecondary,
                                            width: kBorderWidth,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: isSmallScreen ? 14 : 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              kBorderRadius,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: isSmallScreen ? 18 : 22),

                              // Available Classes Carousel
                              Container(
                                decoration: kStyledCardDecoration(),
                                padding: EdgeInsets.all(
                                  isSmallScreen ? 18 : 22,
                                ),
                                child: _buildClassCarousel(isSmallScreen),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 1),
    );
  }
}

// Statistics Page
class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  Map<String, int> _labelCounts = {};
  Map<String, double> _avgConfidence = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    final counts = await FirestoreService.instance.getLabelCounts();
    final avgConf = await FirestoreService.instance.getAverageConfidence();

    setState(() {
      _labelCounts = counts;
      _avgConfidence = avgConf;
      _isLoading = false;
    });
  }

  List<Color> _generateColors(int count) {
    return List.generate(count, (index) {
      final hue = (index * 360 / count) % 360;
      return HSVColor.fromAHSV(1.0, hue, 0.7, 0.9).toColor();
    });
  }

  double _calculateChartWidth() {
    if (_avgConfidence.isEmpty) {
      return 500.0;
    }
    if (_avgConfidence.length <= 1) {
      return 320.0;
    }
    if (_avgConfidence.length > 4) {
      return math.max(500.0, _avgConfidence.length * 120.0);
    }
    return 500.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(currentIndex: 3),
      appBar: AppBar(
        title: Text(
          'Graphs',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: kFruityAccent,
        foregroundColor: kTextOnAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: kSecondaryGradient),
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: kFruityAccent))
            : _labelCounts.isEmpty
            ? Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  padding: const EdgeInsets.all(32),
                  decoration: kStyledCardDecoration(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bar_chart_outlined,
                        size: 64,
                        color: kFruityAccent,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No data available yet',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: kTextDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start scanning items!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          color: kTextMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Statistics Summary Card - Centered
                        Container(
                          decoration: kStyledCardDecoration(),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(
                                  icon: Icons.qr_code_scanner,
                                  value:
                                      '${_labelCounts.values.reduce((a, b) => a + b)}',
                                  label: 'Total Scanned',
                                ),
                                Container(
                                  width: 1,
                                  height: 60,
                                  color: Colors.grey[300],
                                ),
                                _buildStatItem(
                                  icon: Icons.category,
                                  value: '${_labelCounts.length}',
                                  label: 'Classes',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Pie Chart Section
                        Container(
                          decoration: kStyledCardDecoration(),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Scan Distribution by Class',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: kTextDark,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Center(
                                  child: Container(
                                    constraints: const BoxConstraints(
                                      maxWidth: 280,
                                      maxHeight: 280,
                                    ),
                                    child: PieChart(
                                      PieChartData(
                                        sections: _buildPieSections(),
                                        centerSpaceRadius: 50,
                                        sectionsSpace: 3,
                                        startDegreeOffset: -90,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Professional organized legend for pie chart
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Distribution Details',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: kTextDark,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ..._labelCounts.entries.map((entry) {
                                        final index = _labelCounts.keys
                                            .toList()
                                            .indexOf(entry.key);
                                        final colors = _generateColors(
                                          _labelCounts.length,
                                        );
                                        final total = _labelCounts.values
                                            .reduce((a, b) => a + b);
                                        final percentage =
                                            (entry.value / total * 100);
                                        return Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: colors[index].withOpacity(
                                                0.3,
                                              ),
                                              width: 1.5,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: colors[index]
                                                    .withOpacity(0.1),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 16,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  color: colors[index],
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 2,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: colors[index]
                                                          .withOpacity(0.4),
                                                      blurRadius: 4,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  entry.key,
                                                  style: GoogleFonts.quicksand(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: kTextDark,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: colors[index]
                                                          .withOpacity(0.15),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      '${percentage.toStringAsFixed(1)}%',
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                colors[index],
                                                          ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: kFruityAccent
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      '${entry.value}',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                kFruityAccent,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Line Chart Section
                        Container(
                          decoration: kStyledCardDecoration(),
                          clipBehavior: Clip.none,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 24,
                              top: 24,
                              right: 24,
                              bottom: 24,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Average Accuracy by Class',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: kTextDark,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Make chart scrollable horizontally
                                Container(
                                  height: 260,
                                  padding: const EdgeInsets.fromLTRB(
                                    18,
                                    16,
                                    18,
                                    0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                        top: 8,
                                        bottom: 0,
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: SizedBox(
                                          width: _calculateChartWidth(),
                                          child: LineChart(
                                            LineChartData(
                                              minX: _avgConfidence.length == 1
                                                  ? -0.5
                                                  : 0,
                                              maxX: _avgConfidence.length == 1
                                                  ? 0.5
                                                  : (_avgConfidence.length - 1)
                                                        .toDouble(),
                                              minY: 0,
                                              maxY: 100,
                                              lineBarsData: [
                                                LineChartBarData(
                                                  spots: _buildLineSpots(),
                                                  isCurved: true,
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      kFruityAccent.withOpacity(
                                                        0.95,
                                                      ),
                                                      kFruityAccent.withOpacity(
                                                        0.75,
                                                      ),
                                                    ],
                                                  ),
                                                  barWidth: 4,
                                                  isStrokeCapRound: true,
                                                  dotData: FlDotData(
                                                    show: true,
                                                    getDotPainter:
                                                        (
                                                          spot,
                                                          percent,
                                                          barData,
                                                          index,
                                                        ) {
                                                          return FlDotCirclePainter(
                                                            radius: 4.5,
                                                            color: Colors.white,
                                                            strokeWidth: 3,
                                                            strokeColor:
                                                                kFruityAccent,
                                                          );
                                                        },
                                                  ),
                                                  belowBarData: BarAreaData(
                                                    show: true,
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        kFruityAccent
                                                            .withOpacity(0.18),
                                                        kFruityAccent
                                                            .withOpacity(0.04),
                                                      ],
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              lineTouchData: LineTouchData(
                                                touchTooltipData: LineTouchTooltipData(
                                                  getTooltipColor:
                                                      (touchedSpot) =>
                                                          kFruityAccent,
                                                  tooltipRoundedRadius: 8,
                                                  tooltipPadding:
                                                      const EdgeInsets.all(8),
                                                  fitInsideHorizontally: true,
                                                  fitInsideVertically: true,
                                                  getTooltipItems:
                                                      (
                                                        List<LineBarSpot>
                                                        touchedBarSpots,
                                                      ) {
                                                        return touchedBarSpots.map((
                                                          barSpot,
                                                        ) {
                                                          final index = barSpot
                                                              .x
                                                              .toInt();
                                                          if (index <
                                                              _avgConfidence
                                                                  .length) {
                                                            final label =
                                                                _avgConfidence
                                                                    .keys
                                                                    .toList()[index];
                                                            final percentage =
                                                                _avgConfidence[label]!;
                                                            return LineTooltipItem(
                                                              '$label\n${percentage.toStringAsFixed(1)}%',
                                                              TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                              ),
                                                            );
                                                          }
                                                          return null;
                                                        }).toList();
                                                      },
                                                ),
                                              ),
                                              titlesData: FlTitlesData(
                                                leftTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: true,
                                                    reservedSize: 64,
                                                    interval: 20,
                                                    getTitlesWidget: (value, meta) {
                                                      return Transform.translate(
                                                        offset: const Offset(
                                                          0,
                                                          6,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                right: 12,
                                                              ),
                                                          child: Text(
                                                            '${value.toInt()}%',
                                                            style:
                                                                GoogleFonts.quicksand(
                                                                  fontSize: 11,
                                                                  color:
                                                                      kTextMedium,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                bottomTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: true,
                                                    reservedSize: 60,
                                                    interval: 1,
                                                    getTitlesWidget: (value, meta) {
                                                      if (value.toInt() <
                                                          _avgConfidence
                                                              .length) {
                                                        final label =
                                                            _avgConfidence.keys
                                                                .toList()[value
                                                                .toInt()];
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                top: 8,
                                                              ),
                                                          child: SizedBox(
                                                            width: 90,
                                                            child: Text(
                                                              label,
                                                              style: GoogleFonts.quicksand(
                                                                fontSize: 10,
                                                                color:
                                                                    kTextMedium,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      return const Text('');
                                                    },
                                                  ),
                                                ),
                                                rightTitles: const AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: false,
                                                  ),
                                                ),
                                                topTitles: const AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: false,
                                                  ),
                                                ),
                                              ),
                                              gridData: FlGridData(
                                                show: true,
                                                drawVerticalLine: false,
                                                drawHorizontalLine: true,
                                                horizontalInterval: 20,
                                                getDrawingHorizontalLine:
                                                    (value) {
                                                      final emphasizeEdge =
                                                          value == 0 ||
                                                          value == 100;
                                                      return FlLine(
                                                        color: emphasizeEdge
                                                            ? kTextMedium
                                                                  .withOpacity(
                                                                    0.3,
                                                                  )
                                                            : kTextMedium
                                                                  .withOpacity(
                                                                    0.12,
                                                                  ),
                                                        strokeWidth:
                                                            emphasizeEdge
                                                            ? 1.4
                                                            : 1,
                                                        dashArray: emphasizeEdge
                                                            ? null
                                                            : [4, 6],
                                                      );
                                                    },
                                              ),
                                              clipData: const FlClipData(
                                                left: false,
                                                top: false,
                                                right: false,
                                                bottom: false,
                                              ),
                                              borderData: FlBorderData(
                                                show: true,
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: kTextMedium
                                                        .withOpacity(0.2),
                                                    width: 1.2,
                                                  ),
                                                  left: BorderSide(
                                                    color: kTextMedium
                                                        .withOpacity(0.2),
                                                    width: 1.2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Professional organized legend below the chart
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Accuracy Details',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: kTextDark,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ..._avgConfidence.entries.map((entry) {
                                        final percentage = entry.value;
                                        final index = _avgConfidence.keys
                                            .toList()
                                            .indexOf(entry.key);
                                        final colors = _generateColors(
                                          _avgConfidence.length,
                                        );
                                        return Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: colors[index].withOpacity(
                                                0.3,
                                              ),
                                              width: 1.5,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: colors[index]
                                                    .withOpacity(0.1),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 16,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  color: colors[index],
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 2,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: colors[index]
                                                          .withOpacity(0.4),
                                                      blurRadius: 4,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  entry.key,
                                                  style: GoogleFonts.quicksand(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: kTextDark,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: colors[index]
                                                      .withOpacity(0.15),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  '${percentage.toStringAsFixed(1)}%',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                    color: colors[index],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 3),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: kFruityAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 32, color: kFruityAccent),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: kTextDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.quicksand(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: kTextMedium,
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildPieSections() {
    final colors = _generateColors(_labelCounts.length);
    final total = _labelCounts.values.reduce((a, b) => a + b);

    return _labelCounts.entries.map((entry) {
      final index = _labelCounts.keys.toList().indexOf(entry.key);
      final percentage = (entry.value / total * 100);

      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        color: colors[index],
        radius: 90,
        titlePositionPercentageOffset: 0.6,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend() {
    final colors = _generateColors(_labelCounts.length);

    return Wrap(
      spacing: 16,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: _labelCounts.entries.map((entry) {
        final index = _labelCounts.keys.toList().indexOf(entry.key);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: colors[index],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${entry.key}',
                style: GoogleFonts.quicksand(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kTextDark,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${entry.value})',
                style: GoogleFonts.quicksand(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: kTextMedium,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<FlSpot> _buildLineSpots() {
    return _avgConfidence.entries.map((entry) {
      final index = _avgConfidence.keys.toList().indexOf(entry.key);
      final rawPercentage = entry.value;
      final clampedPercentage = rawPercentage.clamp(0.0, 100.0).toDouble();
      return FlSpot(index.toDouble(), clampedPercentage);
    }).toList();
  }
}

// History Page
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final data = await FirestoreService.instance.getAllScans();
    setState(() {
      _history = data;
    });
  }

  Future<void> _deleteItem(String id) async {
    await FirestoreService.instance.deleteScan(id);
    _loadHistory();
  }

  Future<void> _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All History'),
        content: const Text(
          'Are you sure you want to delete all scan history?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirestoreService.instance.deleteAllScans();
      _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(currentIndex: 2),
      appBar: AppBar(
        title: Text(
          'Scan History',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: kFruityAccent,
        foregroundColor: kTextOnAccent,
        elevation: 0,
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearAll,
              tooltip: 'Clear All',
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: kSecondaryGradient),
        child: _history.isEmpty
            ? Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  padding: const EdgeInsets.all(32),
                  decoration: kStyledCardDecoration(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.history_outlined,
                        size: 64,
                        color: kFruityAccent,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No scan history yet',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: kTextDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start scanning to see your history',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          color: kTextMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final item = _history[index];
                  // Handle Firestore Timestamp
                  DateTime dateTime;
                  if (item['date_time'] is Timestamp) {
                    dateTime = (item['date_time'] as Timestamp).toDate();
                  } else if (item['date_time'] is String) {
                    // Fallback for old data format
                    dateTime = DateTime.parse(item['date_time']);
                  } else {
                    dateTime = DateTime.now();
                  }
                  final formattedDate = DateFormat(
                    'MMM dd, yyyy hh:mm a',
                  ).format(dateTime);
                  final confidenceValue =
                      (item['confidence'] as num?)?.toDouble() ?? 0.0;

                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: kStyledBoxDecoration(
                          backgroundColor: Colors.white,
                          borderColor: kBorderSecondary,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Image Thumbnail
                              if (item['image_path'] != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    File(item['image_path']),
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.broken_image,
                                          color: Colors.grey[400],
                                          size: 30,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              else
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey[400],
                                    size: 30,
                                  ),
                                ),
                              const SizedBox(width: 16),

                              // Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['label'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: kTextDark,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: kFruityAccent.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Accuracy: ${confidenceValue.toStringAsFixed(0)}%',
                                        style: GoogleFonts.quicksand(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: kFruityAccent,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      formattedDate,
                                      style: GoogleFonts.quicksand(
                                        fontSize: 11,
                                        color: kTextLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Delete Button
                              IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                    size: 22,
                                  ),
                                ),
                                onPressed: () =>
                                    _deleteItem(item['id'] as String),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 2),
    );
  }
}

class FirestoreService {
  FirestoreService._privateConstructor();

  static final FirestoreService instance =
      FirestoreService._privateConstructor();

  final CollectionReference<Map<String, dynamic>> _scans = FirebaseFirestore
      .instance
      .collection('scans');

  Future<void> insertScan(Map<String, dynamic> data) async {
    final scanNumber = await _getNextScanNumber();
    await _scans.add({...data, 'scan_number': scanNumber});
  }

  Future<int> _getNextScanNumber() async {
    try {
      final snapshot = await _scans
          .orderBy('scan_number', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return 1;
      }

      final data = snapshot.docs.first.data();
      final current = (data['scan_number'] as int?) ?? 0;
      return current + 1;
    } catch (e) {
      // Fallback in case ordering by scan_number fails on older documents
      final snapshot = await _scans.get();
      if (snapshot.docs.isEmpty) return 1;

      int maxNumber = 0;
      for (final doc in snapshot.docs) {
        final n = (doc.data()['scan_number'] as int?) ?? 0;
        if (n > maxNumber) maxNumber = n;
      }
      return maxNumber + 1;
    }
  }

  Future<List<Map<String, dynamic>>> getAllScans() async {
    final snapshot = await _scans.orderBy('date_time', descending: true).get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {...data, 'id': doc.id};
    }).toList();
  }

  Future<void> deleteScan(String id) async {
    await _scans.doc(id).delete();
  }

  Future<void> deleteAllScans() async {
    final batch = FirebaseFirestore.instance.batch();
    final snapshot = await _scans.get();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<Map<String, int>> getLabelCounts() async {
    final snapshot = await _scans.get();
    final Map<String, int> counts = {};
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final label = (data['label'] ?? '') as String;
      if (label.isEmpty) continue;
      counts[label] = (counts[label] ?? 0) + 1;
    }
    return counts;
  }

  Future<Map<String, double>> getAverageConfidence() async {
    final snapshot = await _scans.get();
    final Map<String, List<double>> confidenceBuckets = {};

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final label = (data['label'] ?? '') as String;
      final confidence = (data['confidence'] as num?)?.toDouble();
      if (label.isEmpty || confidence == null) continue;

      final clamped = confidence.clamp(0.0, 100.0).toDouble();
      confidenceBuckets.putIfAbsent(label, () => []).add(clamped);
    }

    final Map<String, double> averages = {};
    confidenceBuckets.forEach((label, values) {
      if (values.isNotEmpty) {
        final total = values.reduce((a, b) => a + b);
        final avg = (total / values.length).clamp(0.0, 100.0).toDouble();
        averages[label] = avg;
      }
    });
    return averages;
  }
}

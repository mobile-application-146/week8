import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// Root of the app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food App',
      theme: ThemeData(primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

// Splash Screen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => FoodListScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: FlutterLogo(size: 100)),
    );
  }
}

// Food Items
class FoodItem {
  final String name;
  final String description;
  final String imageUrl;
  bool isFavorite;

  FoodItem({
    required this.name,
    required this.description,
    required this.imageUrl,
    this.isFavorite = false,
  });
}

// Food List Screen
class FoodListScreen extends StatefulWidget {
  @override
  _FoodListScreenState createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  List<FoodItem> foodItems = [
    FoodItem(
      name: 'Pizza',
      description: 'Classic Cheese Pizza',
      imageUrl: 'images/pizza.jpeg',
    ),
    FoodItem(
      name: 'Burger',
      description: 'Spicy Zinger Burger',
      imageUrl: 'images/burger.jpeg',
    ),
    FoodItem(
      name: 'Pasta',
      description: 'Creamy Italian pasta',
      imageUrl: 'images/pasta.jpeg',
    ),
  ];

  void toggleFavorite(int index) {
    setState(() {
      foodItems[index].isFavorite = !foodItems[index].isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Food List")),
      body: ListView.builder(
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          return FoodItemWidget(
            foodItem: foodItems[index],
            onToggleFavorite: () => toggleFavorite(index),
          );
        },
      ),
    );
  }
}

// Food Item Widget with Heart Animation
class FoodItemWidget extends StatefulWidget {
  final FoodItem foodItem;
  final VoidCallback onToggleFavorite;

  const FoodItemWidget({
    required this.foodItem,
    required this.onToggleFavorite,
  });

  @override
  _FoodItemWidgetState createState() => _FoodItemWidgetState();
}

class _FoodItemWidgetState extends State<FoodItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  void _handleDoubleTap() {
    _controller.forward();
    widget.onToggleFavorite();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  widget.foodItem.imageUrl,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.foodItem.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      widget.foodItem.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onDoubleTap: _handleDoubleTap,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Icon(
                    Icons.favorite,
                    color:
                        widget.foodItem.isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

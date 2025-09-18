import 'package:flutter/material.dart';
import 'package:location_favorites/views/add_location_view.dart';
import 'package:location_favorites/views/favorites_list_view.dart';

class HomeScreenBottomNav extends StatefulWidget {
  @override
  _HomeScreenBottomNavState createState() => _HomeScreenBottomNavState();
}

class _HomeScreenBottomNavState extends State<HomeScreenBottomNav>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _navAnimationController;

  final List<Widget> _pages = [
    AddLocationView(),
    FavoritesListView(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    
    // Animation controller only for navigation bar indicators
    _navAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _navAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _navAnimationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      // Smooth page transition without blinking
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey.shade500,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _currentIndex == 0
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _currentIndex == 0
                        ? Icons.add_location_rounded
                        : Icons.add_location_outlined,
                  ),
                ),
                label: 'Add Location',
              ),
              BottomNavigationBarItem(
                icon: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _currentIndex == 1
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _currentIndex == 1
                        ? Icons.favorite_rounded
                        : Icons.favorite_outline_rounded,
                  ),
                ),
                label: 'My Favorites',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Alternative version with even smoother custom bottom navigation
class SmoothHomeScreen extends StatefulWidget {
  @override
  _SmoothHomeScreenState createState() => _SmoothHomeScreenState();
}

class _SmoothHomeScreenState extends State<SmoothHomeScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _indicatorController;

  final List<Widget> _pages = [
    AddLocationView(),
    FavoritesListView(),
  ];

  final List<IconData> _icons = [
    Icons.add_location_rounded,
    Icons.favorite_rounded,
  ];

  final List<IconData> _outlinedIcons = [
    Icons.add_location_outlined,
    Icons.favorite_outline_rounded,
  ];

  final List<String> _labels = [
    'Add Location',
    'My Favorites',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    
    _indicatorController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    
    _indicatorController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _indicatorController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      _indicatorController.reset();
      setState(() {
        _currentIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
      _indicatorController.forward();
    }
  }

  Widget _buildNavItem(int index) {
    final isSelected = _currentIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isSelected ? _icons[index] : _outlinedIcons[index],
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade500,
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade500,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                child: Text(_labels[index]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          if (index != _currentIndex) {
            _indicatorController.reset();
            setState(() {
              _currentIndex = index;
            });
            _indicatorController.forward();
          }
        },
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 70,
            child: Row(
              children: List.generate(
                _pages.length,
                (index) => _buildNavItem(index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
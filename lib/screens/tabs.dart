import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/providers/favorite_provider.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/main_drawer.dart';
import 'package:meals_app/providers/filters_provider.dart';


const kInitialFilters = {
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegeterian: false,
    Filter.vegan: false,
  };

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectePageIndex = 0;
  // final List<Meal> _favoriteMeals = [];
  Map<Filter, bool> _selectedFilters = kInitialFilters; 

  // void _showInfoMessage(String message) {
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message)),
  //   );
  // }

  // void _toggleMealFavoriteStatus(Meal meal) {
  //   final isExisting = _favoriteMeals.contains(meal);
  //   if (isExisting) {
  //     setState(() {
  //       _favoriteMeals.remove(meal);
  //     });
  //     _showInfoMessage('Meal is no longer a favorite.');
  //   } else {
  //     setState(() {
  //       _favoriteMeals.add(meal);
  //     });
  //     _showInfoMessage('Meal Marked as a farvorite!');
  //   }
  // }

  void _selectPage(int idx) {
    setState(() {
      _selectePageIndex = idx;
    });
  }

  void _setScreen(String id) async {
    Navigator.pop(context);
    if (id == 'filters') {
      await Navigator.push<Map<Filter,bool>>(
        context,
        MaterialPageRoute(
          builder: (context) => const FiltersScreen(),
        ),
      );
      // setState(() {
      //   _selectedFilters = result ?? kInitialFilters;//in case result is null we will keep the default values
      // });
    }
    // } else {
    //   //this is the case when we want to close the drawer and show the categories screen.
    //   Navigator.pop(context);
    // }
  }

  @override
  Widget build(BuildContext context) {
    // final meals = ref.watch(mealsProvider);//re execute build when the data changes
    // final activeFilters = ref.watch(filtersProvider);

    final availableMeals = ref.watch(FilteredMealsProvider);
    Widget activePage = CategoriesScreen(
       availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectePageIndex == 1) {
      final  favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(
        meals: favoriteMeals,
      );

      ///here we are reusing the meals_screen in order to display the favorite meals
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          currentIndex:
              _selectePageIndex, //in order to have the highlight of the icon when selecting
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.set_meal), label: 'Categories'),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
          ]),
    );
  }
}

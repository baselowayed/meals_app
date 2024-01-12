import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/category_grid_item.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/meal.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availableMeals});

  // final void Function(Meal meal) onToggleFavorite;
  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  // "with" allows us to add a socalled Mixin to a class, as another class merged with this class behinds the scenes and offer certain features
  late AnimationController
      _animationController; //will have a value when its used for the first time but currently it is not a variable

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController
        .forward(); //this will start the animation / use repeat to play the animation in a loop
  }

  @override
  void dispose() {
    _animationController
        .dispose(); //this makes sure that this animationcontroller is removed from the device memory once this widget here is removed(avoiding memory overflows)
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        child: GridView(
            //complex way of saying I can set the number of the columns I wanna have here default = 2
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            children: [
              //availableCategories.map((category) => CategoryGridItem(category: category)).toList()
              for (final category in availableCategories)
                CategoryGridItem(
                  category: category,
                  onSelectCategory: () {
                    _selectCategory(context, category);
                  },
                )
            ]),
        builder: (contex, child) => SlideTransition(
              //# 2 way of explicit animation
              position: Tween(
                begin: const Offset(0, 0.3), //30% offset
                end: const Offset(0, 0),
              ).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.easeInOut,
                ),
              ),
              child: child,
            )
        //Padding(//#1 way of explicit animation
        //   padding: EdgeInsets.only(top: 100 - _animationController.value * 100),
        //   child: child,
        // ),
        );
  }
}

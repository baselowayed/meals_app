import 'package:flutter/material.dart';
import 'package:meals_app/main.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/meal_details.dart';
import 'package:meals_app/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, this.title, required this.meals});

  final String? title; // we made it optional so when using this screen for the fovorites we won't have 2 titles
  final List<Meal> meals;
  // final void Function(Meal) onToggleFavorite;

  void onSelectMeal(BuildContext context, Meal meal){
    Navigator.push(context,  MaterialPageRoute(
        builder: (ctx) => MealDetailsScreen(
          meal: meal,
        ),
      ),);
  }

  @override
  Widget build(BuildContext context) {

    Widget content = Center(child: Column(children: [
        Text('This category is still empty', style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: Theme.of(context).colorScheme.onBackground),),
        const SizedBox(height: 16),
        Text('Try selecting a different category', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onBackground),)
      ],),);
     
    if(meals.isNotEmpty){
      content = Center(
        child: ListView.builder(
          itemCount: meals.length,
          itemBuilder: (ctx, index) => MealItem(meal: meals[index], onSelectMeal: (meal){onSelectMeal(ctx,meal);},),
          ),
        );
    }

    if(title == null){
      return content;
    } 
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: content
    );
  }
}

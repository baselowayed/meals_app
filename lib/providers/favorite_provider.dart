import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';

class FavoriteMealsNotifier extends StateNotifier<List<Meal>>{
  FavoriteMealsNotifier(): super([]);

  bool toggleMealFavoriteState(Meal meal){
    final isMealFavorite = state.contains(meal);
    if(isMealFavorite){
      state = state.where((m){
        return m.id != meal.id;
      }).toList();
      return false;
    }else{
      state = [...state, meal];//... means import/include all the elements
      return true;
    }
  }
}

final favoriteMealsProvider = StateNotifierProvider<FavoriteMealsNotifier,List<Meal>>((ref){
  return FavoriteMealsNotifier();
});
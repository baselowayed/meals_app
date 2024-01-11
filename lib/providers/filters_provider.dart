import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/meals_provider.dart';


enum Filter {
  glutenFree,
  lactoseFree,
  vegeterian,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<Filter,bool>>{
  FiltersNotifier(): super({
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegeterian: false,
    Filter.vegan: false,
  });

  void setFilters(Map<Filter,bool> chosenFilters){
   state = chosenFilters; 
  }
  void setFilter(Filter filter , bool isActive){
    //don't change the current instead we have to reassign it.
    state = {...state, filter: isActive};
  }
}

final filtersProvider = StateNotifierProvider<FiltersNotifier, Map<Filter,bool>>((ref){
  return FiltersNotifier();
});


final FilteredMealsProvider = Provider((ref){//this is an example of a provider that depends on another providers
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);
  return  meals.where((meal){
      if(activeFilters[Filter.glutenFree]! && !meal.isGlutenFree){
        return false;
      }
      if(activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree){
        return false;
      }
      if(activeFilters[Filter.vegeterian]! && !meal.isVegetarian){
        return false;
      }
      if(activeFilters[Filter.vegan]! && !meal.isVegan){
        return false;
      }
      return true;
    }).toList();
});

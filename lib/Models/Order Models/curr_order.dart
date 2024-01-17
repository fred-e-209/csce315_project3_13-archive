import 'smoothie_order.dart';
import 'snack_order.dart';

/// Object representing the current order that the GUI is referencing
class curr_order {

  //Vector for storing snack names
  List<snack_order> snacks = [];

  //Vector for storing smoothie orders
  List<smoothie_order> smoothies = [];

  //The name of the employee who took the order
//  String employee;

  //The total price of the order
  double price = 0.0;



  ///    Constructor for curr_order objects with no employee name specified. Initializes
  ///    snack and smoothie vectors.
  curr_order(){
    snacks = [];
    smoothies = [];
  }


  ///    Adds a snack to the snack vector.
  ///    @param snack_name the name of the snack to be added
  void addSnack(snack_order snack){
    price += snack.price;
    snacks.add(snack);
  }

  ///    Adds a smoothie_order object to the smoothie vector.
  ///    @param smoothie the smoothie_order object to be added
  void addSmoothie(smoothie_order smoothie){
    price += smoothie.getCost();
    smoothies.add(smoothie);
  }

  ///    Sorts the IDs of the smoothies and sorts the IDs of the snacks
  void reorderIndexes(int startingIndex)
  {
    for (smoothie_order smoothie in [...smoothies]) {
      if (smoothie.table_index >= startingIndex) {
        smoothie.table_index -= 1;

      }
    }
    for (snack_order snack in [...snacks]){
      if (snack.table_index >= startingIndex){
        snack.table_index -= 1;
      }
    }
  }

  ///    Removes an item from the current order
  ///    @param index the index of the item to be removed
  smoothie_order remove(int index)
  {
       for (smoothie_order smoothie in smoothies) {
         if (smoothie.table_index == index) {
           smoothie_order copy = smoothie;
           price -= smoothie.getCost();
           smoothies.remove(smoothie);
           return copy;
         }
       }
       for (snack_order snack in snacks) {
         if (snack.table_index == index) {
           price -= snack.price;
           snacks.remove(snack);
         }
       }
    reorderIndexes(index);
    return smoothie_order(smoothie: "Error", curr_size: "", curr_price: 0, table_index: 0);

  }



  ///    Returns the vector of snack names.
  ///    @return the vector of snack names
  List<snack_order> getSnacks(){
    return snacks;
  }



  ///    Returns the vector of smoothie_order objects.
  ///    @return the vector of smoothie_order objects
  List<smoothie_order> getSmoothies(){
    return smoothies;
  }


  ///    Returns the total number of items in the order.
  ///    @return the total number of items in the order
  int numItems(){
    return snacks.length + smoothies.length;
  }

  /// Clears the snack and smoothie vectors.
  void clear()
  {
    price = 0;
    snacks.clear();
    smoothies.clear();
  }


}
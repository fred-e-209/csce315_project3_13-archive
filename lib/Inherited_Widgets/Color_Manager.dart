import 'package:flutter/material.dart';

/// Widget used to manage the color filter that is set on the app
/// Allows for us to switch between multiple color presets
class Color_Manager extends InheritedWidget {
  final Color primary_color;
  final Color secondary_color;
  final Color background_color;
  final Color text_color;
  final Color active_color;
  final Color hover_color;
  final Color inactive_color;
  final Color active_size_color;
  final Color active_confirm_color;
  final Color active_deny_color;

  final Function reset_colors;
  final Function option_protanopia;
  final Function option_deuteranopia;
  final Function option_tritanopia;

  final int selected_option_index;



  Color_Manager({required this.selected_option_index, required this.primary_color, required this.secondary_color, required this.background_color, required this.text_color, required this.active_color, required this.inactive_color, required this.hover_color, required this.active_size_color, required this.active_confirm_color, required this.active_deny_color, required this.option_tritanopia, required this.option_deuteranopia, required this.option_protanopia , required this.reset_colors, required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(Color_Manager old) {
    if((primary_color != old.primary_color) ||
        (secondary_color != old.secondary_color) ||
        (background_color != old.background_color) ||
        (text_color != old.text_color) ||
        (active_color != old.active_color) ||
        (inactive_color != old.inactive_color) ||
        (active_size_color != old.active_size_color) ||
        (active_confirm_color != old.active_confirm_color) ||
        (active_deny_color != old.active_deny_color)||
        (hover_color != old.hover_color)||
        (selected_option_index != old.selected_option_index)
    ){
      return true;
    }else {
      return false;
    }
  }

  static Color_Manager of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Color_Manager>() ?? Color_Manager(selected_option_index: 0 ,child: const Text("Color manager failed"), primary_color: Colors.blue, secondary_color: Colors.blue, background_color : Colors.blue, text_color : Colors.blue, active_color : Colors.blue, inactive_color : Colors.blue, active_size_color : Colors.blue, active_confirm_color : Colors.blue, active_deny_color : Colors.blue, hover_color: Colors.blue,  option_tritanopia: (){}, option_deuteranopia: (){}, option_protanopia: (){}, reset_colors: (){},);
}
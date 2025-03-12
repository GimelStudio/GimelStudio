import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class GsDropdown extends StatefulWidget {
  const GsDropdown({
    super.key,
    this.isEnabled = true,
    this.width,
    this.height,
    required this.currentItem,
    required this.items,
    required this.onChange,
  });

  final bool isEnabled;
  final double? width;
  final double? height;
  final String currentItem;
  final List<String> items;
  final ValueChanged<String?> onChange;

  @override
  State<GsDropdown> createState() => _GsDropdownState();
}

class _GsDropdownState extends State<GsDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      enabled: widget.isEnabled,
      initialSelection: widget.currentItem,
      width: widget.width,
      menuHeight: widget.height,
      enableSearch: false,
      enableFilter: true,
      expandedInsets: EdgeInsets.zero,
      onSelected: (String? value) => widget.onChange.call(value),
      trailingIcon: PhosphorIcon(
        PhosphorIcons.caretDown(PhosphorIconsStyle.light),
        color: widget.isEnabled ? Colors.white70 : Colors.white70.withAlpha(153),
        size: 10.0,
      ),
      selectedTrailingIcon: PhosphorIcon(
        PhosphorIcons.caretUp(PhosphorIconsStyle.light),
        color: widget.isEnabled ? Colors.white70 : Colors.white70.withAlpha(153),
        size: 10.0,
      ),
      textStyle: TextStyle(
        color: widget.isEnabled ? Colors.white70 : Colors.white70.withAlpha(153),
        fontSize: 12.0,
        height: 1.1,
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Color(0xFF1F1F1F)),
        visualDensity: VisualDensity.compact,
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
        surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
      ),
      inputDecorationTheme: InputDecorationTheme(
        suffixIconConstraints: BoxConstraints.tightFor(height: 30.0),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF363636))),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF363636))),
        disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF363636).withAlpha(153))),
      ),
      dropdownMenuEntries: widget.items.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(
          value: value,
          label: value,
          style: MenuItemButton.styleFrom(
            backgroundColor: Color(0xFF1F1F1F),
            foregroundColor: Colors.white70,
            textStyle: TextStyle(
              fontSize: 12.0,
            ),
            visualDensity: VisualDensity(horizontal: 0.6, vertical: 0.0),
            minimumSize: Size(70.0, 28.0),
          ),
        );
      }).toList(),
    );
  }
}

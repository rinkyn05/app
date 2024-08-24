import 'package:flutter/material.dart';

import '../config/lang/app_localization.dart';

class DropdownWidget extends StatefulWidget {
  final List<String> options;
  final String? selectedValue;
  final String labelText;
  final void Function(String?)? onChanged;

  const DropdownWidget({
    super.key,
    required this.options,
    this.selectedValue,
    required this.labelText,
    required this.onChanged,
  });

  @override
  DropdownWidgetState createState() => DropdownWidgetState();
}

class DropdownWidgetState extends State<DropdownWidget> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return DropdownButtonFormField(
      iconEnabledColor: theme.iconTheme.color,
      selectedItemBuilder: (BuildContext context) {
        return widget.options.map<Widget>((String item) {
          return Text(
            item,
            style: TextStyle(
              fontFamily: "MB",
              color: theme.textTheme.titleLarge!.color,
            ),
          );
        }).toList();
      },
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: theme.textTheme.titleLarge,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: theme.primaryColor,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: theme.primaryColor,
            width: 8,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: theme.primaryColor,
            width: 6,
          ),
        ),
      ),
      items: widget.options.map((option) {
        return DropdownMenuItem(
          value: option,
          child: Text(
            option,
            style: TextStyle(
              fontFamily: "MB",
              color: theme.textTheme.titleLarge!.color,
            ),
          ),
        );
      }).toList(),
      value: widget.selectedValue,
      onChanged: widget.onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!
              .translate('selectOptionValidation');
        }
        return null;
      },
    );
  }
}

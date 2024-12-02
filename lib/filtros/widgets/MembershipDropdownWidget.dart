import 'package:flutter/material.dart';
import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart'; // Ajusta la importación según tu estructura

class MembershipDropdownWidget extends StatefulWidget {
  final String langKey;
final Function(String) onChanged;

const MembershipDropdownWidget({
  Key? key,
  required this.langKey,
  required this.onChanged, // Añadido aquí
}) : super(key: key);


  @override
  _MembershipDropdownWidgetState createState() =>
      _MembershipDropdownWidgetState();
}

class _MembershipDropdownWidgetState extends State<MembershipDropdownWidget> {
  String? _membershipEsp;
  String? _membershipEng;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            AppLocalizations.of(context)!.translate('exerciseMembership'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildMembershipSelector(),
        if (_membershipEsp != null || _membershipEng != null)
          _buildSelectedMembership(),
      ],
    );
  }

  Widget _buildMembershipSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = ['Gratis', 'Premium'];
    List<String> optionsEng = ['Free', 'Premium'];

    Map<String, String> membershipMapEspToEng = {
      'Gratis': 'Free',
      'Premium': 'Premium',
    };

    Map<String, String> membershipMapEngToEsp = {
      'Free': 'Gratis',
      'Premium': 'Premium',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String? selectedValue = isEsp ? _membershipEsp : _membershipEng;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightBlueAccentColor,
          width: 2,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            AppLocalizations.of(context)!.translate('selectMembership'),
          ),
          onChanged: (String? newValue) {
            setState(() {
              if (isEsp) {
                _membershipEsp = newValue!;
                _membershipEng = membershipMapEspToEng[newValue]!;
              } else {
                _membershipEng = newValue!;
                _membershipEsp = membershipMapEngToEsp[newValue]!;
              }
            });
          },
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          value: selectedValue,
        ),
      ),
    );
  }

  Widget _buildSelectedMembership() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";
    String membershipName = isEsp ? _membershipEsp! : _membershipEng!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Chip(
        label: Text(membershipName),
        onDeleted: () {
          setState(() {
            _membershipEsp = null;
            _membershipEng = null;
          });
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../config/lang/app_localization.dart'; // Importa el sistema de localización.
import '../../config/utils/appcolors.dart'; // Importa los colores personalizados de la app.

// Este widget permite seleccionar el tipo de membresía en un Dropdown (Gratis o Premium).
class MembershipDropdownWidget extends StatefulWidget {
  final String langKey; // Clave para la localización del idioma.
  final Function(String) onChanged; // Callback al seleccionar una opción.
  final Function(String?)
      onSelectionChanged; // Callback adicional para notificar cambios en la selección.

  const MembershipDropdownWidget({
    Key? key,
    required this.langKey,
    required this.onChanged,
    required this.onSelectionChanged, // Nueva función callback.
  }) : super(key: key);

  @override
  _MembershipDropdownWidgetState createState() =>
      _MembershipDropdownWidgetState();
}

class _MembershipDropdownWidgetState extends State<MembershipDropdownWidget> {
  String? _membershipEsp; // Variable para la membresía en español.
  String? _membershipEng; // Variable para la membresía en inglés.

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título del selector.
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            // Traducción del título desde AppLocalizations.
            AppLocalizations.of(context)!.translate('exerciseMembership'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildMembershipSelector(), // Dropdown selector de membresía.
        if (_membershipEsp != null || _membershipEng != null)
          _buildSelectedMembership(), // Muestra un chip con la selección actual.
      ],
    );
  }

  // Construye el Dropdown para seleccionar la membresía.
  Widget _buildMembershipSelector() {
    // Obtiene el idioma actual del dispositivo.
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp =
        currentLocale.languageCode == "es"; // Verifica si el idioma es español.

    // Opciones para el Dropdown en ambos idiomas.
    List<String> optionsEsp = ['Gratis', 'Premium'];
    List<String> optionsEng = ['Free', 'Premium'];

    // Mapas de conversión entre español e inglés.
    Map<String, String> membershipMapEspToEng = {
      'Gratis': 'Free',
      'Premium': 'Premium',
    };
    Map<String, String> membershipMapEngToEsp = {
      'Free': 'Gratis',
      'Premium': 'Premium',
    };

    // Asigna las opciones y el valor seleccionado basado en el idioma actual.
    List<String> options = isEsp ? optionsEsp : optionsEng;
    String? selectedValue = isEsp ? _membershipEsp : _membershipEng;

    // Contenedor estilizado para el Dropdown.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade400, // Fondo gris.
        borderRadius: BorderRadius.circular(20), // Bordes redondeados.
        border: Border.all(
          color: AppColors.lightBlueAccentColor, // Borde azul claro.
          width: 2,
        ),
      ),
      child: DropdownButtonHideUnderline(
        // Oculta la línea subrayada por defecto del Dropdown.
        child: DropdownButton<String>(
          isExpanded: true, // Ocupa todo el ancho del contenedor.
          hint: Text(
            // Texto de sugerencia traducido.
            AppLocalizations.of(context)!.translate('selectMembership'),
          ),
          onChanged: (String? newValue) {
            // Actualiza los valores seleccionados y los sincroniza en ambos idiomas.
            setState(() {
              if (isEsp) {
                _membershipEsp = newValue!;
                _membershipEng = membershipMapEspToEng[newValue]!;
              } else {
                _membershipEng = newValue!;
                _membershipEsp = membershipMapEngToEsp[newValue]!;
              }
              // Notifica el cambio al padre a través de los callbacks.
              widget.onChanged(isEsp ? _membershipEsp! : _membershipEng!);
              widget
                  .onSelectionChanged(newValue); // Notifica con el nuevo valor.
            });
          },
          // Crea las opciones del Dropdown.
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          value: selectedValue, // Valor actual del Dropdown.
        ),
      ),
    );
  }

  // Muestra un Chip con la membresía seleccionada.
  Widget _buildSelectedMembership() {
    // Determina el idioma actual y muestra el nombre de la membresía correspondiente.
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";
    String membershipName = isEsp ? _membershipEsp! : _membershipEng!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Chip(
        label: Text(membershipName), // Muestra el nombre de la membresía.
        onDeleted: () {
          // Elimina la selección actual.
          setState(() {
            _membershipEsp = null;
            _membershipEng = null;
            widget.onSelectionChanged(
                null); // Notifica que la selección fue eliminada.
          });
        },
      ),
    );
  }
}

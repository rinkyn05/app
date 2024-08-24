class Rutina {
  final String idRutina;
  final String nombreRutina;
  final int intervalo;
  final List<EjercicioRutina> ejercicios;

  Rutina({
    required this.idRutina,
    required this.nombreRutina,
    required this.intervalo,
    required this.ejercicios,
  });

  factory Rutina.fromMap(Map<String, dynamic> data, String documentId) {
    var listaEjercicios = List.from(data['ejercicios'] ?? [])
        .map((e) => EjercicioRutina.fromMap(e as Map<String, dynamic>))
        .toList();

    return Rutina(
      idRutina: documentId,
      nombreRutina: data['nombreRutina'] ?? '',
      intervalo: data['intervalo'] as int? ?? 10,
      ejercicios: listaEjercicios,
    );
  }

  String get duracionTotal {
    final totalSegundos = ejercicios.fold<int>(0, (total, ejercicio) {
      final duracionParts = ejercicio.duracion.split(':');
      return total +
          (int.tryParse(duracionParts[0]) ?? 0) * 60 +
          (int.tryParse(duracionParts[1]) ?? 0);
    });
    final minutos = totalSegundos ~/ 60;
    final segundos = totalSegundos % 60;
    return '${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}';
  }

  int get caloriasTotal => ejercicios.fold<int>(
      0, (total, ejercicio) => total + (int.tryParse(ejercicio.calorias) ?? 0));
}

class EjercicioRutina {
  final String imagen;
  final String nombre;
  final String duracion;
  final String calorias;

  EjercicioRutina({
    required this.imagen,
    required this.nombre,
    required this.duracion,
    required this.calorias,
  });

  factory EjercicioRutina.fromMap(Map<String, dynamic> data) {
    return EjercicioRutina(
      imagen: data['imagen'] ?? '',
      nombre: data['nombre'] ?? '',
      duracion: data['duracion'] ?? '00:00',
      calorias: data['calorias'] ?? '0',
    );
  }
}

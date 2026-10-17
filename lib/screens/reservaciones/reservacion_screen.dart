import 'package:flutter/material.dart';

class ReservacionScreen extends StatefulWidget {
  const ReservacionScreen({super.key});

  @override
  State<ReservacionScreen> createState() => _ReservacionScreenState();
}

class _ReservacionScreenState extends State<ReservacionScreen> {
  DateTime? _fechaSeleccionada;
  TimeOfDay? _horaSeleccionada;
  int _numeroPersonas = 2;
  final TextEditingController _notasController = TextEditingController();

  @override
  void dispose() {
    _notasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reservar Mesa')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Número de personas', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton.outlined(
                icon: const Icon(Icons.remove),
                onPressed: _numeroPersonas > 1 ? () => setState(() => _numeroPersonas--) : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('$_numeroPersonas personas', style: const TextStyle(fontSize: 16)),
              ),
              IconButton.outlined(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() => _numeroPersonas++),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade300)),
            leading: const Icon(Icons.calendar_month),
            title: Text(_fechaSeleccionada == null ? 'Seleccionar Fecha' : '${_fechaSeleccionada!.day}/${_fechaSeleccionada!.month}/${_fechaSeleccionada!.year}'),
            onTap: () async {
              final fecha = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
              );
              if (fecha != null) setState(() => _fechaSeleccionada = fecha);
            },
          ),
          const SizedBox(height: 12),
          ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade300)),
            leading: const Icon(Icons.access_time),
            title: Text(_horaSeleccionada == null ? 'Seleccionar Hora' : _horaSeleccionada!.format(context)),
            onTap: () async {
              final hora = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 14, minute: 0),
              );
              if (hora != null) setState(() => _horaSeleccionada = hora);
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _notasController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Instrucciones o peticiones especiales (opcional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 30),
          FilledButton(
            onPressed: (_fechaSeleccionada != null && _horaSeleccionada != null)
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reservación enviada con éxito')),
                    );
                  }
                : null,
            child: const Text('Confirmar Reservación'),
          ),
        ],
      ),
    );
  }
}
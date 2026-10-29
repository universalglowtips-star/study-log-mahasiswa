import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../core/formatters.dart';
import '../models/course_schedule.dart';
import '../providers/study_provider.dart';

class ScheduleFormScreen extends StatefulWidget {
  const ScheduleFormScreen({super.key, this.course});

  /// null = tambah baru, terisi = edit.
  final CourseSchedule? course;

  @override
  State<ScheduleFormScreen> createState() => _ScheduleFormScreenState();
}

class _ScheduleFormScreenState extends State<ScheduleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _code;
  late final TextEditingController _sks;
  late final TextEditingController _className;
  late final TextEditingController _lecturer;
  late final TextEditingController _room;
  late int _day;
  late int _start;
  late int _end;
  String? _timeError;

  bool get _isEdit => widget.course != null;

  @override
  void initState() {
    super.initState();
    final c = widget.course;
    _name = TextEditingController(text: c?.name);
    _code = TextEditingController(text: c?.code);
    _sks = TextEditingController(
      text: (c != null && c.sks > 0) ? '${c.sks}' : '',
    );
    _className = TextEditingController(text: c?.className);
    _lecturer = TextEditingController(text: c?.lecturer);
    _room = TextEditingController(text: c?.room);
    _day = c?.day ?? DateTime.now().weekday;
    _start = c?.startMinutes ?? 8 * 60;
    _end = c?.endMinutes ?? 9 * 60 + 40;
  }

  @override
  void dispose() {
    _name.dispose();
    _code.dispose();
    _sks.dispose();
    _className.dispose();
    _lecturer.dispose();
    _room.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null;

  Future<void> _pickTime({required bool isStart}) async {
    final current = isStart ? _start : _end;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current ~/ 60, minute: current % 60),
    );
    if (picked == null) return;
    setState(() {
      final minutes = picked.hour * 60 + picked.minute;
      if (isStart) {
        _start = minutes;
      } else {
        _end = minutes;
      }
      _timeError = null;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_end <= _start) {
      setState(() => _timeError = 'Jam selesai harus setelah jam mulai');
      return;
    }

    final provider = context.read<StudyProvider>();
    final navigator = Navigator.of(context);
    final course = CourseSchedule(
      id: widget.course?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: _name.text.trim(),
      code: _code.text.trim(),
      sks: int.tryParse(_sks.text.trim()) ?? 0,
      className: _className.text.trim().toUpperCase(),
      lecturer: _lecturer.text.trim(),
      room: _room.text.trim(),
      day: _day,
      startMinutes: _start,
      endMinutes: _end,
    );

    final conflict = provider.findConflict(course);
    if (conflict != null) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Jadwal bentrok'),
          content: Text(
            'Bertabrakan dengan "${conflict.name}" '
            '(${formatMinutes(conflict.startMinutes)}–'
            '${formatMinutes(conflict.endMinutes)}). Tetap simpan?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Tetap simpan'),
            ),
          ],
        ),
      );
      if (proceed != true) return;
    }

    await provider.upsertCourse(course);
    navigator.pop();
  }

  Future<void> _delete() async {
    final provider = context.read<StudyProvider>();
    final navigator = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus jadwal?'),
        content: Text('"${widget.course!.name}" akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await provider.deleteCourse(widget.course!.id);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Jadwal' : 'Tambah Jadwal'),
        actions: [
          if (_isEdit)
            IconButton(
              tooltip: 'Hapus',
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Mata kuliah'),
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validator: _required,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _code,
              decoration: const InputDecoration(labelText: 'Kode MK (opsional)'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _sks,
                    decoration: const InputDecoration(labelText: 'SKS'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _className,
                    decoration: const InputDecoration(labelText: 'Kelas'),
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lecturer,
              decoration: const InputDecoration(labelText: 'Dosen (opsional)'),
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _room,
              decoration: const InputDecoration(labelText: 'Ruangan (opsional)'),
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: _day,
              decoration: const InputDecoration(labelText: 'Hari'),
              items: [
                for (var d = 1; d <= 7; d++)
                  DropdownMenuItem(value: d, child: Text(dayName(d))),
              ],
              onChanged: (v) => setState(() => _day = v ?? _day),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickTime(isStart: true),
                    icon: const Icon(Icons.schedule),
                    label: Text('Mulai ${formatMinutes(_start)}'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickTime(isStart: false),
                    icon: const Icon(Icons.schedule),
                    label: Text('Selesai ${formatMinutes(_end)}'),
                  ),
                ),
              ],
            ),
            if (_timeError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_timeError!, style: TextStyle(color: errorColor)),
              ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/student_profile.dart';
import '../providers/study_provider.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _nim;
  late final TextEditingController _major;
  late final TextEditingController _campus;
  late final TextEditingController _className;
  late int _semester;

  @override
  void initState() {
    super.initState();
    final p = context.read<StudyProvider>().profile;
    _name = TextEditingController(text: p?.name);
    _nim = TextEditingController(text: p?.nim);
    _major = TextEditingController(text: p?.major);
    _campus = TextEditingController(text: p?.campus);
    _className = TextEditingController(text: p?.className);
    _semester = p?.semester ?? 1;
  }

  @override
  void dispose() {
    _name.dispose();
    _nim.dispose();
    _major.dispose();
    _campus.dispose();
    _className.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<StudyProvider>();
    final navigator = Navigator.of(context);

    await provider.saveProfile(
      StudentProfile(
        name: _name.text.trim(),
        nim: _nim.text.trim(),
        major: _major.text.trim(),
        campus: _campus.text.trim(),
        className: _className.text.trim().toUpperCase(),
        semester: _semester,
      ),
    );
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Mahasiswa')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Nama lengkap'),
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validator: _required,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nim,
              decoration: const InputDecoration(labelText: 'NIM'),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.next,
              validator: _required,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _major,
              decoration: const InputDecoration(labelText: 'Jurusan / Prodi'),
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validator: _required,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _campus,
              decoration: const InputDecoration(labelText: 'Nama kampus'),
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validator: _required,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _className,
              decoration: const InputDecoration(labelText: 'Kelas'),
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.characters,
              validator: _required,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: _semester,
              decoration: const InputDecoration(labelText: 'Semester'),
              items: [
                for (var s = 1; s <= 14; s++)
                  DropdownMenuItem(value: s, child: Text('Semester $s')),
              ],
              onChanged: (v) => setState(() => _semester = v ?? _semester),
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

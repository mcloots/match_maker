import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../repositories/profile_repository.dart';
import '../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final locationController = TextEditingController();
  final interestsController = TextEditingController();
  final imageUrlController = TextEditingController();
  final repository = ProfileRepository();
  final authService = AuthService();
  bool isLoading = true;
  bool isSaving = false;
  String? loadError;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    locationController.dispose();
    interestsController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() {
      isLoading = true;
      loadError = null;
    });
    try {
      final profile = await repository.fetchMyProfile();
      if (!mounted) return;
      if (profile != null) {
        nameController.text = profile.name;
        ageController.text = profile.age.toString();
        locationController.text = profile.location;
        interestsController.text = profile.interests.join(', ');
        imageUrlController.text = profile.imageUrl;
      }
    } catch (_) {
      if (mounted) {
        setState(() => loadError = 'Profiel laden mislukt. Probeer opnieuw.');
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _saveProfile() async {
    if (isSaving || !formKey.currentState!.validate()) return;
    setState(() => isSaving = true);
    try {
      final profile = Profile(
        id: authService.currentUser!.uid,
        name: nameController.text.trim(),
        age: int.parse(ageController.text.trim()),
        location: locationController.text.trim(),
        imageUrl: imageUrlController.text.trim(),
        interests: interestsController.text
            .split(',')
            .map((interest) => interest.trim())
            .where((interest) => interest.isNotEmpty)
            .toList(),
      );
      await repository.saveProfile(profile);
      if (mounted) _showMessage('Profiel opgeslagen.');
    } catch (_) {
      if (mounted) _showMessage('Opslaan mislukt. Probeer opnieuw.');
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  Future<void> _signOut() async {
    if (isSaving) return;
    setState(() => isSaving = true);
    try {
      await authService.signOut();
    } catch (_) {
      if (mounted) _showMessage('Uitloggen mislukt. Probeer opnieuw.');
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (loadError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(loadError!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _loadProfile,
              child: const Text('Opnieuw proberen'),
            ),
            TextButton(
              onPressed: isSaving ? null : _signOut,
              child: const Text('Uitloggen'),
            ),
          ],
        ),
      );
    }
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Jouw profiel', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 24),
                TextFormField(
                  controller: nameController,
                  enabled: !isSaving,
                  decoration: const InputDecoration(labelText: 'Naam'),
                  validator: (value) => (value?.trim() ?? '').isEmpty
                      ? 'Vul je naam in.'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: ageController,
                  enabled: !isSaving,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Leeftijd'),
                  validator: (value) {
                    final age = int.tryParse(value?.trim() ?? '');
                    return age == null || age < 18 || age > 120
                        ? 'Vul een leeftijd van 18 tot 120 in.'
                        : null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: locationController,
                  enabled: !isSaving,
                  decoration: const InputDecoration(labelText: 'Woonplaats'),
                  validator: (value) => (value?.trim() ?? '').isEmpty
                      ? 'Vul je woonplaats in.'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: interestsController,
                  enabled: !isSaving,
                  decoration: const InputDecoration(
                    labelText: 'Interesses',
                    helperText: 'Bijvoorbeeld: Koffie, Reizen, Muziek',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: imageUrlController,
                  enabled: !isSaving,
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Foto-URL (optioneel)',
                    helperText: 'Een publieke link naar een afbeelding.',
                  ),
                  validator: (value) {
                    final url = value?.trim() ?? '';
                    if (url.isEmpty) return null;
                    final uri = Uri.tryParse(url);
                    if (uri == null ||
                        !['http', 'https'].contains(uri.scheme) ||
                        uri.host.isEmpty) {
                      return 'Vul een geldige http- of https-URL in.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: isSaving ? null : _saveProfile,
                  child: Text(isSaving ? 'Even wachten...' : 'Profiel opslaan'),
                ),
                TextButton(
                  onPressed: isSaving ? null : _signOut,
                  child: const Text('Uitloggen'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

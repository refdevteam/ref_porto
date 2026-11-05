import 'package:flutter/foundation.dart';
import 'package:porto/features/contacts/models/contact_data.dart' as con;
import 'package:porto/features/experiences/models/experience_data.dart' as exp;
import 'package:porto/features/projects/models/projects_data.dart' as proj;
import 'package:porto/features/studies/models/study_data.dart' as std;
import 'package:supabase_flutter/supabase_flutter.dart';

const String _defaultBio =
    'Mobile Developer (Flutter) and UI/UX Enthusiast based in Kediri, Indonesia, specializing in building intuitive and scalable digital products. With over two years of experience in the software industry, I have evolved from full-stack web development to focusing on high-performance mobile application engineering. I actively build, maintain, and monitor robust application ecosystems using Flutter, Firebase, and Laravel. I am deeply passionate about bridging the gap between functional product development and user-centered design to deliver seamless digital experiences.';

/// Sumber data portfolio. Tampilan selalu diawali data lokal (instan sekaligus
/// fallback offline), lalu direvalidate dari Supabase di belakang — bila fetch
/// gagal, data lokal tetap dipakai tanpa gangguan.
class AppData {
  AppData._();

  static final AppData instance = AppData._();

  static const String supabaseUrl = 'https://gxgwxkxhfjsewvcpaong.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd4Z3d4a3hoZmpzZXd2Y3Bhb25nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTM2ODA4NDksImV4cCI6MjEwOTI1Njg0OX0.i44Fh8DMVBLnYnCI6ZbH9sGWRUu9x5FEeYidM9wCEeo';

  final ValueNotifier<List<proj.ProjectsData>> projects =
      ValueNotifier<List<proj.ProjectsData>>(proj.projects);
  final ValueNotifier<List<exp.ExperienceData>> experiences =
      ValueNotifier<List<exp.ExperienceData>>(exp.experiences);
  final ValueNotifier<List<std.StudyData>> studies =
      ValueNotifier<List<std.StudyData>>(std.studies);
  final ValueNotifier<con.ContactData> contact =
      ValueNotifier<con.ContactData>(con.contact);
  final ValueNotifier<String> bio = ValueNotifier<String>(_defaultBio);

  String? _lastTrackedPath;

  /// Catat kunjungan halaman ke tabel `visits` (fire & forget, diam bila
  /// gagal). Path yang sama berurutan tidak dihitung dua kali.
  Future<void> trackVisit(String path) async {
    if (path.isEmpty || path == '/splash' || path == _lastTrackedPath) return;
    _lastTrackedPath = path;
    try {
      await Supabase.instance.client.from('visits').insert({'page': path});
    } on Exception {
      // Analytics tidak boleh mengganggu aplikasi.
    }
  }

  /// Ambil data terbaru dari Supabase. Diam bila gagal — data lokal tetap.
  Future<void> load() async {
    try {
      final SupabaseClient client = Supabase.instance.client;
      final List<Object?> rows = await Future.wait<Object?>([
        client.from('projects').select().order('sort_order', ascending: true),
        client
            .from('experiences')
            .select()
            .order('sort_order', ascending: true),
        client.from('studies').select().order('sort_order', ascending: true),
        client.from('contact').select().limit(1),
        client.from('profile').select().limit(1),
      ]).timeout(const Duration(seconds: 5));

      final List<proj.ProjectsData> projectRows = _maps(rows[0])
          .map(proj.ProjectsData.fromJson)
          .toList();
      final List<exp.ExperienceData> experienceRows = _maps(rows[1])
          .map(exp.ExperienceData.fromJson)
          .toList();
      final List<std.StudyData> studyRows =
          _maps(rows[2]).map(std.StudyData.fromJson).toList();
      final List<Map<String, dynamic>> contactRows = _maps(rows[3]);
      final List<Map<String, dynamic>> profileRows = _maps(rows[4]);

      if (projectRows.isNotEmpty) projects.value = projectRows;
      if (experienceRows.isNotEmpty) experiences.value = experienceRows;
      if (studyRows.isNotEmpty) studies.value = studyRows;
      if (contactRows.isNotEmpty) contact.value = con.ContactData.fromJson(contactRows.first);
      if (profileRows.isNotEmpty) {
        final Object? bioRow = profileRows.first['bio'];
        if (bioRow is String && bioRow.isNotEmpty) bio.value = bioRow;
      }
    } on Exception {
      // Offline / Supabase tak terjangkau → data lokal tetap dipakai.
    }
  }

  List<Map<String, dynamic>> _maps(Object? rows) =>
      rows is List ? rows.whereType<Map<String, dynamic>>().toList() : const [];
}

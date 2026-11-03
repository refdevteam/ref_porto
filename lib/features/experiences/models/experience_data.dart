import 'package:flutter/foundation.dart';

/// Satu entri pengalaman yang tampil di dalam kartu experience.
@immutable
class ExperienceData {
  const ExperienceData({
    required this.position,
    required this.officeName,
    required this.duration,
    required this.description,
    this.logoAsset,
  });

  /// Posisi pekerjaan — tampil sebagai headline kartu.
  final String position;

  /// Nama kantor / tempat bekerja.
  final String officeName;

  /// Durasi kerja, mis. `Jan 2024 – Present`.
  final String duration;

  /// Deskripsi yang dibuka lewat tombol dropdown di dalam kartu.
  final String description;

  /// Aset logo office; `null` → memakai placeholder ikon gedung.
  final String? logoAsset;

  factory ExperienceData.fromJson(Map<String, dynamic> json) => ExperienceData(
        position: json['position'] as String,
        officeName: json['office_name'] as String,
        duration: json['duration'] as String,
        description: json['description'] as String,
        logoAsset: json['logo_url'] as String?,
      );
}

/// Data contoh — ganti dengan data asli saat sudah siap.
const List<ExperienceData> experiences = <ExperienceData>[
  ExperienceData(
    position: 'Mobile Developer (Flutter)',
    officeName: 'Charoen Pokphand Indonesia - Full Time',
    duration: 'Jun 2024 – Present',
    logoAsset: 'assets/cpi.png',
    description: 'Developing cross-platform mobile applications end-to-end, from gathering requirements to shipping on the Play Store and App Store for Company needs. Focused on clean architecture, smooth animations, and maintainable Flutter code.',
  ),
  ExperienceData(
    position: 'Full-stack Developer',
    officeName: 'Saraga - Freelance',
    duration: 'Feb 2024 – May 2024',
    logoAsset: 'assets/saraga.png',
    description: "In this project, I focused on enhancing the overall user experience through targeted web optimization and pixel-perfect UI/UX implementation directly from Figma designs. My role extended to maintaining continuous operational stability by proactively tracking production errors and debugging live incidents in real time. I also strengthened the project's quality assurance by documenting system anomalies and negative outcomes, ensuring reliable and uninterrupted performance across the application.",
  ),
  ExperienceData(
    position: 'Product Annotator',
    officeName: 'TELUS International - Freelance',
    duration: 'Agt 2021 – Dec 2021',
    logoAsset: 'assets/telus.png',
    description: 'I previously worked as a freelancer at Telus International for the Indonesian Website Annotation program for 5 months, in the role of: Website Annotator.',
  ),
  ExperienceData(
    position: 'Full-stack Developer',
    officeName: 'PT. Albea Rigid Packaging Surabaya - Internship',
    duration: 'Feb 2020 – Jul 2020',
    logoAsset: 'assets/albea.png',
    description: 'I worked as an intern as full-stack web developer, where I handled an occupational health and safety (OHS/K3) reporting feature using the Bootstrap and Laravel frameworks.',
  ),
];

import 'package:flutter/foundation.dart';

/// Satu entri pendidikan yang tampil di dalam kartu study.
@immutable
class StudyData {
  const StudyData({
    required this.institutionName,
    required this.major,
    required this.duration,
    required this.description,
    this.gpa,
    this.photos = const <String>[],
    this.logoAsset,
  });

  /// Nama kampus / sekolah — tampil sebagai headline kartu.
  final String institutionName;

  /// Jurusan / gelar — tampil di bawah headline.
  final String major;

  /// Periode studi, mis. `2019 – 2023`.
  final String duration;

  /// IPK; `null` → pill IPK disembunyikan.
  final String? gpa;

  /// Deskripsi yang dibuka lewat tombol dropdown di dalam kartu.
  final String description;

  /// Aset foto dokumentasi; tampil di bawah deskripsi saat dibuka.
  final List<String> photos;

  /// Aset logo institusi; `null` → memakai placeholder ikon sekolah.
  final String? logoAsset;
}

/// Data contoh — ganti dengan data asli saat sudah siap.
const List<StudyData> studies = <StudyData>[
  StudyData(
    institutionName: 'State Polytechnic of Madiun',
    major: 'D3 - Computer Control Engineering',
    duration: '2018 - 2021',
    gpa: 'IPK: 3.45',
    description: 'TKK Study Program focuses on the Process of Realizing Vocational Higher Education in the field of Computer Control Expertise, industrial control and appropriate technology that is quality, science and technology based, innovation and nationally competitive.',
    logoAsset: 'assets/pnm.png',
    photos: [],
  ),
  StudyData(
    institutionName: 'Electronic Engineering Polytechnic Institute of Surabaya',
    major: 'D4 - Informatics Engineering',
    duration: '2022 - 2024',
    gpa: 'IPK: 3.44',
    description: 'Graduates of the Applied Informatics Engineering Study Program are equipped with technical skills and expertise, so that they have competence in the fields of computer programming, development of information systems and database technology, development of software engineering both on desktop, web and mobile devices, as well as computer networks. In addition to technical abilities, Graduates of the Applied Informatics Engineering Study Program are also equipped with non-technical abilities (soft skills), in the form of knowledge and insight into social and religious life, supporting anti-corruption movements, leadership, ethics and communication skills in fostering good cooperation according to field needs work, so that they become graduates who have quality and intellectual integrity with the characters of Honesty, Originality, Enthusiasm, and Politeness.',
    logoAsset: 'assets/pens.png',
    photos: [],
  ),
];

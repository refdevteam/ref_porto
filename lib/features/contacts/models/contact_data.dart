class ContactData {
  const ContactData({
    required this.email,
    required this.linkedinUrl,
    required this.location,
    required this.latitude,
    required this.longitude,
  });

  final String email;

  final String linkedinUrl;

  final String location;

  final double latitude;

  final double longitude;

  factory ContactData.fromJson(Map<String, dynamic> json) => ContactData(
        email: json['email'] as String,
        linkedinUrl: json['linkedin_url'] as String,
        location: json['location'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
      );
}

const ContactData contact = ContactData(
  email: 'mrifkirezafahlevi@gmail.com',
  linkedinUrl: 'https://www.linkedin.com/in/mohammad-rifki-reza-fahlevi/',
  location: 'Kediri, East Java, Indonesia',
  latitude: -7.8111057,
  longitude: 112.0046051,
);

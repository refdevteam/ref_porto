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
}

const ContactData contact = ContactData(
  email: 'mrifkirezafahlevi@gmail.com',
  linkedinUrl: 'https://www.linkedin.com/in/mohammad-rifki-reza-fahlevi/',
  location: 'Kediri, East Java, Indonesia',
  latitude: -7.8111057,
  longitude: 112.0046051,
);

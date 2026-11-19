// ============================================================
//  TOUTES VOS INFORMATIONS PERSONNELLES SONT ICI.
//  Modifiez uniquement ce fichier pour personnaliser l'application.
// ============================================================

class Experience {
  final String title;
  final String place;
  final String period;
  final String description;
  const Experience({
    required this.title,
    required this.place,
    required this.period,
    required this.description,
  });
}

class Education {
  final String degree;
  final String school;
  final String period;
  const Education({
    required this.degree,
    required this.school,
    required this.period,
  });
}

class FamilyMember {
  final String name;
  final String relation;
  final String job;
  final String photo;
  const FamilyMember({
    required this.name,
    required this.relation,
    required this.job,
    required this.photo,
  });
}

// --- Identifiants de connexion ---
const String loginUsername = 'admin';
const String loginPassword = '1234';

// --- Identité ---
const String fullName = 'Grace Munduwandi';
const String jobTitle = 'Étudiant en Informatique de Gestion – ISIG Goma';
const String profilePhoto = 'assets/images/photo.jpg';
const String aboutMe =
    'Étudiant en informatique de gestion à l\'ISIG Goma, je développe des '
    'applications web et desktop. Curieux et motivé, je cherche à approfondir '
    'mes compétences, notamment dans le développement mobile.';

// --- Formation ---
const List<Education> educations = [
  Education(
    degree: 'Informatique de Gestion',
    school: 'ISIG Goma',
    period: 'Depuis 2023 – 2024',
  ),
];

// --- Expériences (stages, projets, emplois) ---
const List<Experience> experiences = [
  Experience(
    title: 'Projet – Application mobile CV',
    place: 'Projet universitaire',
    period: '2026',
    description:
        'Application Flutter présentant mon CV, ma famille et mes contacts, '
        'avec page de connexion et navigation.',
  ),
];

// --- Compétences ---
const List<String> technicalSkills = [
  'HTML',
  'CSS',
  'JavaScript',
  'C#',
  'Applications web',
  'Applications desktop',
];

const List<String> languages = [
  'Swahili',
  'Français',
  'Anglais',
];

// --- Centres d'intérêt ---
const List<String> interests = [
  'Informatique',
  'Programmation',
];

// --- Famille ---
const List<FamilyMember> family = [
  FamilyMember(
    name: 'Tresor Munduwandi',
    relation: 'petit frère',
    job: 'entrepreneur',
    photo: 'assets/images/Screenshot_20260916-155432.jpg',
  ),
  FamilyMember(
    name: 'Eloge Munduwandi',
    relation: 'Grande sœur',
    job: 'Infirmière',
    photo: 'assets/images/eloge.jpg',
  ),
  FamilyMember(
    name: 'Erick Baroki',
    relation: 'Un frère',
    job: 'Entrepreneur',
    photo: 'assets/images/erick.jpg',
  ),
];

// --- Contact ---
const String phone = '0975065374';
const String email = 'gracemunduwandi4@gmail.com';
const String address = 'Goma, RD Congo';
const String linkedinUrl = 'https://www.linkedin.com/in/gracemund';
const String githubUrl = 'https://github.com/gracemunduwandi4-tech';

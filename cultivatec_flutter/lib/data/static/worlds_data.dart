import 'package:flutter/material.dart';

/// Universe definitions matching the React app.
class UniverseInfo {
  final int index;
  final String name;
  final IconData icon;
  final String subtitle;
  final Color primaryColor;
  final Color secondaryColor;
  final bool available;

  const UniverseInfo({
    required this.index,
    required this.name,
    required this.icon,
    required this.subtitle,
    required this.primaryColor,
    required this.secondaryColor,
    this.available = false,
  });
}

// Top-level progression is themed as ranks of an "Academia Robótica":
// the student climbs from Cadete to Maestro. Each rank maps to a school
// level (kept in the subtitle so families still know what fits their child).
const List<UniverseInfo> universeInfos = [
  UniverseInfo(
    index: 0,
    name: 'Cadete',
    icon: Icons.shield_rounded,
    subtitle: 'Primaria · Tus primeros pasos en robótica',
    primaryColor: Color(0xFF22C55E),
    secondaryColor: Color(0xFF16A34A),
    available: false,
  ),
  UniverseInfo(
    index: 1,
    name: 'Explorador',
    icon: Icons.travel_explore_rounded,
    subtitle: 'Secundaria · Explora 6 mundos de robótica',
    primaryColor: Color(0xFF2563EB),
    secondaryColor: Color(0xFF1D4ED8),
    available: true,
  ),
  UniverseInfo(
    index: 2,
    name: 'Ingeniero',
    icon: Icons.engineering_rounded,
    subtitle: 'Preparatoria · Robótica técnica avanzada',
    primaryColor: Color(0xFF7C3AED),
    secondaryColor: Color(0xFF6D28D9),
    available: false,
  ),
  UniverseInfo(
    index: 3,
    name: 'Maestro',
    icon: Icons.military_tech_rounded,
    subtitle: 'Universidad · Robótica industrial y de investigación',
    primaryColor: Color(0xFFDC2626),
    secondaryColor: Color(0xFFB91C1C),
    available: false,
  ),
];

/// World configuration matching the React app (6 worlds for Universe 2).
class WorldInfo {
  final String id;
  final String name;
  final IconData icon;
  final String description;
  final Color accentColor;
  final Color accentDark;
  final List<Color> gradientColors;
  final String bgPattern;
  final String? unlockType;
  final int unlockRequirement;
  final List<SectionInfo> sections;

  const WorldInfo({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.accentColor,
    required this.accentDark,
    required this.gradientColors,
    required this.bgPattern,
    this.unlockType,
    this.unlockRequirement = 0,
    required this.sections,
  });
}

class SectionInfo {
  final int startIdx;
  final String title;
  final String subtitle;
  final Color color;
  final Color colorLight;
  final IconData icon;

  const SectionInfo({
    required this.startIdx,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.colorLight,
    required this.icon,
  });
}

const List<WorldInfo> worldInfos = [
  WorldInfo(
    id: 'world_1',
    name: 'El Taller del Inventor',
    icon: Icons.build,
    description: '¡Descubre los fundamentos de la robótica desde cero!',
    accentColor: Color(0xFF2563EB),
    accentDark: Color(0xFF1D4ED8),
    gradientColors: [Color(0xFF1D4ED8), Color(0xFF2563EB), Color(0xFF3B82F6)],
    bgPattern: '',
    sections: [
      SectionInfo(startIdx: 0, title: '🤖 Introducción', subtitle: '¡Descubre el increíble mundo de los robots!', color: Color(0xFF58CC02), colorLight: Color(0xFFD7FFB8), icon: Icons.rocket_launch),
      SectionInfo(startIdx: 3, title: '🔬 Fundamentos', subtitle: 'Electricidad, electrónica y mecánica', color: Color(0xFF2563EB), colorLight: Color(0xFFDBEAFE), icon: Icons.bolt),
      SectionInfo(startIdx: 6, title: '💻 Programación', subtitle: 'Lógica, código y Arduino', color: Color(0xFF1CB0F6), colorLight: Color(0xFFD0ECFB), icon: Icons.videogame_asset),
      SectionInfo(startIdx: 9, title: '🛠️ Prácticas', subtitle: 'Proyectos físicos paso a paso', color: Color(0xFFFF9600), colorLight: Color(0xFFFFECD0), icon: Icons.build),
      SectionInfo(startIdx: 12, title: '🧠 Avanzado', subtitle: 'Control, diseño y más', color: Color(0xFF60A5FA), colorLight: Color(0xFFF0DEFF), icon: Icons.emoji_events),
    ],
  ),
  WorldInfo(
    id: 'world_2',
    name: 'La Fábrica de Autómatas',
    icon: Icons.factory,
    description: 'Construye robots reales con sensores, motores y IA básica.',
    accentColor: Color(0xFFD97706),
    accentDark: Color(0xFFB45309),
    gradientColors: [Color(0xFFB45309), Color(0xFFD97706), Color(0xFFF59E0B)],
    bgPattern: '',
    sections: [
      SectionInfo(startIdx: 0, title: '🦾 Sensores', subtitle: 'Ojos y oídos del robot', color: Color(0xFFD97706), colorLight: Color(0xFFFEF3C7), icon: Icons.cell_tower),
      SectionInfo(startIdx: 3, title: '⚡ Motores', subtitle: 'Movimiento y fuerza', color: Color(0xFFB45309), colorLight: Color(0xFFFEF3C7), icon: Icons.build),
      SectionInfo(startIdx: 6, title: '🤖 Control', subtitle: 'Lógica de control', color: Color(0xFFF59E0B), colorLight: Color(0xFFFFFBEB), icon: Icons.videogame_asset),
      SectionInfo(startIdx: 9, title: '🏗️ Construcción', subtitle: 'Ensamblaje y diseño', color: Color(0xFFD97706), colorLight: Color(0xFFFEF3C7), icon: Icons.factory),
      SectionInfo(startIdx: 12, title: '🏆 Proyectos', subtitle: 'Desafíos finales', color: Color(0xFFB45309), colorLight: Color(0xFFFEF3C7), icon: Icons.emoji_events),
    ],
  ),
  WorldInfo(
    id: 'world_3',
    name: 'La Selva Cibernética',
    icon: Icons.eco,
    description: 'Biorobótica: donde la naturaleza inspira la tecnología.',
    accentColor: Color(0xFF059669),
    accentDark: Color(0xFF065F46),
    gradientColors: [Color(0xFF065F46), Color(0xFF059669), Color(0xFF10B981)],
    bgPattern: '',
    sections: [
      SectionInfo(startIdx: 0, title: '🦎 Bio-inspiración', subtitle: 'Robots que imitan la naturaleza', color: Color(0xFF059669), colorLight: Color(0xFFD1FAE5), icon: Icons.pets),
      SectionInfo(startIdx: 3, title: '🧠 Inteligencia', subtitle: 'IA y aprendizaje', color: Color(0xFF065F46), colorLight: Color(0xFFD1FAE5), icon: Icons.psychology),
      SectionInfo(startIdx: 6, title: '🦾 Prótesis', subtitle: 'Robótica médica', color: Color(0xFF10B981), colorLight: Color(0xFFECFDF5), icon: Icons.fitness_center),
      SectionInfo(startIdx: 9, title: '🐙 Soft Robotics', subtitle: 'Robots blandos', color: Color(0xFF059669), colorLight: Color(0xFFD1FAE5), icon: Icons.bug_report),
      SectionInfo(startIdx: 12, title: '🏆 Expedición', subtitle: 'Misión final', color: Color(0xFF065F46), colorLight: Color(0xFFD1FAE5), icon: Icons.emoji_events),
    ],
  ),
  WorldInfo(
    id: 'world_4',
    name: 'La Estación Orbital',
    icon: Icons.flight,
    description: 'Robótica espacial: rovers, satélites, IA y misiones interplanetarias.',
    accentColor: Color(0xFF6366F1),
    accentDark: Color(0xFF4338CA),
    gradientColors: [Color(0xFF312E81), Color(0xFF4338CA), Color(0xFF6366F1)],
    bgPattern: '',
    unlockType: 'friends',
    unlockRequirement: 5,
    sections: [
      SectionInfo(startIdx: 0, title: '🛸 Exploración', subtitle: 'Robótica espacial', color: Color(0xFF6366F1), colorLight: Color(0xFFE0E7FF), icon: Icons.rocket_launch),
      SectionInfo(startIdx: 3, title: '📡 Comunicación', subtitle: 'Satélites y antenas', color: Color(0xFF4338CA), colorLight: Color(0xFFE0E7FF), icon: Icons.cell_tower),
      SectionInfo(startIdx: 6, title: '🤖 IA Espacial', subtitle: 'Autonomía en el espacio', color: Color(0xFF6366F1), colorLight: Color(0xFFEEF2FF), icon: Icons.psychology),
      SectionInfo(startIdx: 9, title: '🏗️ Construcción', subtitle: 'Bases orbitales', color: Color(0xFF4338CA), colorLight: Color(0xFFE0E7FF), icon: Icons.construction),
      SectionInfo(startIdx: 12, title: '🏆 Misión Final', subtitle: 'El reto definitivo', color: Color(0xFF312E81), colorLight: Color(0xFFE0E7FF), icon: Icons.emoji_events),
    ],
  ),
  WorldInfo(
    id: 'world_5',
    name: 'El Desierto de los Rovers',
    icon: Icons.landscape,
    description: 'Robótica autónoma: diseña rovers como los de NASA y SpaceX.',
    accentColor: Color(0xFFD97706),
    accentDark: Color(0xFF92400E),
    gradientColors: [Color(0xFF92400E), Color(0xFFB45309), Color(0xFFD97706)],
    bgPattern: '',
    unlockType: 'friends',
    unlockRequirement: 15,
    sections: [
      SectionInfo(startIdx: 0, title: '🏜️ Navegación', subtitle: 'Exploración autónoma', color: Color(0xFFD97706), colorLight: Color(0xFFFEF3C7), icon: Icons.explore),
      SectionInfo(startIdx: 3, title: '👁️ Visión', subtitle: 'Sensores avanzados', color: Color(0xFFB45309), colorLight: Color(0xFFFEF3C7), icon: Icons.visibility),
      SectionInfo(startIdx: 6, title: '🧠 IA Rover', subtitle: 'Decisiones autónomas', color: Color(0xFFD97706), colorLight: Color(0xFFFFFBEB), icon: Icons.psychology),
      SectionInfo(startIdx: 9, title: '🛡️ Resiliencia', subtitle: 'Supervivencia extrema', color: Color(0xFF92400E), colorLight: Color(0xFFFEF3C7), icon: Icons.security),
      SectionInfo(startIdx: 12, title: '🏆 Expedición', subtitle: 'Misión al desierto', color: Color(0xFFB45309), colorLight: Color(0xFFFEF3C7), icon: Icons.emoji_events),
    ],
  ),
  WorldInfo(
    id: 'world_6',
    name: 'La Bahía de la Aero-Biosfera',
    icon: Icons.grass,
    description: 'Drones agrícolas, invernaderos robóticos, biosensores y robótica ecológica.',
    accentColor: Color(0xFF059669),
    accentDark: Color(0xFF065F46),
    gradientColors: [Color(0xFF065F46), Color(0xFF047857), Color(0xFF059669)],
    bgPattern: '',
    unlockType: 'friends',
    unlockRequirement: 25,
    sections: [
      SectionInfo(startIdx: 0, title: '🌱 Agri-Tech', subtitle: 'Drones agrícolas', color: Color(0xFF059669), colorLight: Color(0xFFD1FAE5), icon: Icons.toys),
      SectionInfo(startIdx: 3, title: '💧 Riego', subtitle: 'Sistemas inteligentes', color: Color(0xFF047857), colorLight: Color(0xFFD1FAE5), icon: Icons.water_drop),
      SectionInfo(startIdx: 6, title: '🌡️ Sensores', subtitle: 'Monitoreo ambiental', color: Color(0xFF065F46), colorLight: Color(0xFFECFDF5), icon: Icons.star),
      SectionInfo(startIdx: 9, title: '🏠 Invernaderos', subtitle: 'Robótica agro', color: Color(0xFF059669), colorLight: Color(0xFFD1FAE5), icon: Icons.star),
      SectionInfo(startIdx: 12, title: '🏆 Ecosistema', subtitle: 'Proyecto final', color: Color(0xFF065F46), colorLight: Color(0xFFD1FAE5), icon: Icons.emoji_events),
    ],
  ),
];

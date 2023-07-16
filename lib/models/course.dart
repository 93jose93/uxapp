

import 'package:flutter/material.dart';

class Course {
  final String title, description, iconSrc;
  final Color bgColor;

  Course({
    required this.title,
    this.description =
        "There are many variations of passages of Lorem Ipsum available.",
    this.iconSrc = "assets/icons/ios.svg",
    this.bgColor = const Color(0xFF7553F6),
  });
}

List<Course> courses = [
  Course(title: "Animación en Flutter UI"),
  Course(
    title: "Animación en Flutter",
    iconSrc: "assets/icons/code.svg",
    bgColor: const Color(0xFF80A4FF),
  ),
];

List<Course> recentCourses = [
  Course(title: "Estado del curso"),
  Course(
    title: "Animación",
    iconSrc: "assets/icons/code.svg",
    bgColor: const Color(0XFF9CC5FF),
  ),
  Course(title: "Estado del curso"),
  Course(
    title: "Animación",
    iconSrc: "assets/icons/code.svg",
    bgColor: const Color(0XFF9CC5FF),
  ),
];
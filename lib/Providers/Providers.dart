import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final questionControllerProvider =
    StateProvider.autoDispose((ref) => TextEditingController());
final answerControllerProvider =
    StateProvider.autoDispose((ref) => TextEditingController());
final imageUrlProvider = StateProvider<String?>((ref) => null);
final initialQuestionProvider = StateProvider<String>((ref) => '');
final initialAnswerProvider = StateProvider<String>((ref) => '');

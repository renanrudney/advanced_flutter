import 'package:advanced_flutter/domain/entities/next_event_player.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  String initialsOf(String name) => NextEventPlayer(id: '', name: name, isConfirmed: true).initials;

  test('should return the first letter of the first and last names', () {
    expect(initialsOf('Renan Rudney'), 'RR');
    expect(initialsOf('Rodrigo Manguinho'), 'RM');
    expect(initialsOf('Ingrid Mota da Silva'), 'IS');
  });

  test('should return the first letters of the first name', () {
    expect(initialsOf('Renan'), 'RE');
    expect(initialsOf('R'), 'R');
  });

  test('should return "-" when name is empty', () {
    expect(initialsOf(''), '-');
  });

  test('should convert to uppercase', () {
    expect(initialsOf('renan rudney'), 'RR');
    expect(initialsOf('renan'), 'RE');
    expect(initialsOf('r'), 'R');
  });

  test('should ignore extra whitespaces', () {
    expect(initialsOf('Renan Rudney '), 'RR');
    expect(initialsOf(' Renan Rudney'), 'RR');
    expect(initialsOf('Renan  Rudney'), 'RR');
    expect(initialsOf(' Renan  Rudney '), 'RR');
    expect(initialsOf(' Renan '), 'RE');
    expect(initialsOf(' R '), 'R');
    expect(initialsOf(' '), '-');
    expect(initialsOf('  '), '-');
  });
}

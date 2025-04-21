import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/fakes.dart';

final class EditUserViewModel {
  final bool isNaturalPerson;

  EditUserViewModel({
    required this.isNaturalPerson
  });
}

final class EditUserPage extends StatelessWidget {
  final Future<EditUserViewModel> Function() loadUserData;

  const EditUserPage({
    super.key,
    required this.loadUserData
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EditUserViewModel>(
      future: loadUserData(),
      builder: (context, snapshot) {
        return Scaffold(
          body: Column(
            children: [
              RadioListTile(
                title: const Text('Pessoa física'),
                value: true,
                groupValue: snapshot.data?.isNaturalPerson,
                onChanged: (value) {}
              ),
              RadioListTile(
                title: const Text('Pessoa jurídica'),
                value: false,
                groupValue: snapshot.data?.isNaturalPerson,
                onChanged: (value) {}
              ),
            ],
          )
        );
      }
    );
  }
}

final class LoadUserDataSpy {
  var isCalled = false;
  var response = EditUserViewModel(isNaturalPerson: anyBool());

  Future<EditUserViewModel> call() async {
    isCalled = true;
    return response;
  }
}

void main() {
  late LoadUserDataSpy loadUserData;
  late Widget sut;

  setUp(() {
    loadUserData = LoadUserDataSpy();
    sut = MaterialApp(home: EditUserPage(loadUserData: loadUserData.call));
  });

  testWidgets('should load user data on page init', (tester) async {
    await tester.pumpWidget(sut);
    expect(loadUserData.isCalled, true);
  });

  testWidgets('should check natural person', (tester) async {
    loadUserData.response = EditUserViewModel(isNaturalPerson: true);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.widget<RadioListTile>(find.ancestor(of: find.text('Pessoa física'), matching: find.byType(RadioListTile<bool>))).checked, true);
    expect(tester.widget<RadioListTile>(find.ancestor(of: find.text('Pessoa jurídica'), matching: find.byType(RadioListTile<bool>))).checked, false);
  });

  testWidgets('should check legal person', (tester) async {
    loadUserData.response = EditUserViewModel(isNaturalPerson: false);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.widget<RadioListTile>(find.ancestor(of: find.text('Pessoa física'), matching: find.byType(RadioListTile<bool>))).checked, false);
    expect(tester.widget<RadioListTile>(find.ancestor(of: find.text('Pessoa jurídica'), matching: find.byType(RadioListTile<bool>))).checked, true);
  });
}

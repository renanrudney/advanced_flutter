import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/fakes.dart';

final class EditUserViewModel {
  bool isNaturalPerson;
  bool showCpf;
  bool showCnpj;
  String? cpf;
  String? cnpj;

  EditUserViewModel({
    required this.isNaturalPerson,
    required this.showCpf,
    required this.showCnpj,
    this.cpf,
    this.cnpj
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
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) return const Center(child: Text('Erro'));
        final viewModel = snapshot.data!;
        return Scaffold(
          body: Column(
            children: [
              RadioListTile(
                title: const Text('Pessoa física'),
                value: true,
                groupValue: viewModel.isNaturalPerson,
                onChanged: (value) {}
              ),
              RadioListTile(
                title: const Text('Pessoa jurídica'),
                value: false,
                groupValue: viewModel.isNaturalPerson,
                onChanged: (value) {}
              ),
              if (viewModel.showCpf) TextFormField(
                keyboardType: TextInputType.numberWithOptions(),
                initialValue: viewModel.cpf,
                decoration: const InputDecoration(labelText: 'CPF'),
              ),
              if (viewModel.showCnpj) TextFormField(
                keyboardType: TextInputType.numberWithOptions(),
                initialValue: viewModel.cnpj,
                decoration: const InputDecoration(labelText: 'CNPJ'),
              ),
            ],
          )
        );
      }
    );
  }
}

final class LoadUserDataSpy {
  var callsCount = 0;
  Error? _error;
  var _response = EditUserViewModel(isNaturalPerson: anyBool(), showCpf: anyBool(), showCnpj: anyBool());

  void mockResponse({ bool? isNaturalPerson, bool? showCpf, bool? showCnpj, String? cpf, String? cnpj }) {
    _response = EditUserViewModel(
      isNaturalPerson: isNaturalPerson ?? anyBool(),
      showCpf: showCpf ?? anyBool(),
      showCnpj: showCnpj ?? anyBool(),
      cpf: cpf,
      cnpj: cnpj
    );
  }

  void mockError() => _error = Error();

  Future<EditUserViewModel> call() async {
    callsCount++;
    if (_error != null) throw _error!;
    return _response;
  }
}

void main() {
  late LoadUserDataSpy loadUserData;
  late Widget sut;
  late String cpf;
  late String cnpj;

  setUp(() {
    cpf = anyString();
    cnpj = anyString();
    loadUserData = LoadUserDataSpy();
    sut = MaterialApp(home: EditUserPage(loadUserData: loadUserData.call));
  });

  testWidgets('should load user data on page init', (tester) async {
    await tester.pumpWidget(sut);
    expect(loadUserData.callsCount, 1);
  });

  testWidgets('should handle spinner on load', (tester) async {
    await tester.pumpWidget(sut);
    expect(tester.spinnerFinder, findsOneWidget);
    await tester.pump();
    expect(tester.spinnerFinder, findsNothing);
  });

  testWidgets('should handle spinner on error', (tester) async {
    loadUserData.mockError();
    await tester.pumpWidget(sut);
    expect(tester.spinnerFinder, findsOneWidget);
    await tester.pump();
    expect(tester.spinnerFinder, findsNothing);
  });

  testWidgets('should show error', (tester) async {
    loadUserData.mockError();
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.errorFinder, findsOneWidget);
  });

  testWidgets('should check natural person', (tester) async {
    loadUserData.mockResponse(isNaturalPerson: true);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.naturalPersonRadio.checked, true);
    expect(tester.legalPersonRadio.checked, false);
  });

  testWidgets('should check legal person', (tester) async {
    loadUserData.mockResponse(isNaturalPerson: false);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.naturalPersonRadio.checked, false);
    expect(tester.legalPersonRadio.checked, true);
  });

  testWidgets('should show CPF', (tester) async {
    loadUserData.mockResponse(showCpf: true);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.cpfFinder, findsOneWidget);
  });

  testWidgets('should hide CPF', (tester) async {
    loadUserData.mockResponse(showCpf: false);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.cpfFinder, findsNothing);
  });

  testWidgets('should show CNPJ', (tester) async {
    loadUserData.mockResponse(showCnpj: true);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.cnpjFinder, findsOneWidget);
  });

  testWidgets('should hide CNPJ', (tester) async {
    loadUserData.mockResponse(showCnpj: false);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.cnpjFinder, findsNothing);
  });

  testWidgets('should fill CPF', (tester) async {
    loadUserData.mockResponse(cpf: cpf, showCpf: true);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.cpfTextField.initialValue, cpf);
  });

  testWidgets('should clear CPF', (tester) async {
    loadUserData.mockResponse(cpf: null, showCpf: true);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.cpfTextField.initialValue, isEmpty);
  });

  testWidgets('should fill CNPJ', (tester) async {
    loadUserData.mockResponse(cnpj: cnpj, showCnpj: true);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.cnpjTextField.initialValue, cnpj);
  });

  testWidgets('should clear CNPJ', (tester) async {
    loadUserData.mockResponse(cnpj: null, showCnpj: true);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.cnpjTextField.initialValue, isEmpty);
  });
}

extension EditUserPageExtension on WidgetTester {
  Finder get naturalPersonFinder => find.ancestor(of: find.text('Pessoa física'), matching: find.byType(RadioListTile<bool>));
  Finder get legalPersonFinder => find.ancestor(of: find.text('Pessoa jurídica'), matching: find.byType(RadioListTile<bool>));
  Finder get cpfFinder => find.ancestor(of: find.text('CPF'), matching: find.byType(TextFormField));
  Finder get cnpjFinder => find.ancestor(of: find.text('CNPJ'), matching: find.byType(TextFormField));
  Finder get spinnerFinder => find.byType(CircularProgressIndicator);
  Finder get errorFinder => find.text('Erro');
  RadioListTile get naturalPersonRadio => widget(naturalPersonFinder);
  RadioListTile get legalPersonRadio => widget(legalPersonFinder);
  TextFormField get cpfTextField => widget(cpfFinder);
  TextFormField get cnpjTextField => widget(cnpjFinder);
}

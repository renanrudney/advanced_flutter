import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/fakes.dart';

final class EditUserViewModel {
  bool isNaturalPerson;
  bool showCpf;
  bool showCnpj;
  bool isCpfValid;
  bool isCnpjValid;
  bool isFormValid;
  String? cpf;
  String? cnpj;

  EditUserViewModel({
    required this.isNaturalPerson,
    required this.showCpf,
    required this.showCnpj,
    required this.isCpfValid,
    required this.isCnpjValid,
    required this.isFormValid,
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
                decoration: InputDecoration(
                  labelText: 'CPF',
                  errorText: viewModel.isCpfValid ? null : 'Valor inválido'
                ),
              ),
              if (viewModel.showCnpj) TextFormField(
                keyboardType: TextInputType.numberWithOptions(),
                initialValue: viewModel.cnpj,
                decoration: InputDecoration(
                  labelText: 'CNPJ',
                  errorText: viewModel.isCnpjValid ? null : 'Valor inválido'
                ),
              ),
              ElevatedButton(
                onPressed: viewModel.isFormValid ?  () {} : null,
                child: Text('Salvar')
              )
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
  var _response = EditUserViewModel(isNaturalPerson: anyBool(), showCpf: anyBool(), showCnpj: anyBool(), isCpfValid: anyBool(), isCnpjValid: anyBool(), isFormValid: anyBool());

  void mockResponse({ bool? isNaturalPerson, bool? showCpf, bool? showCnpj, String? cpf, String? cnpj, bool? isCpfValid, bool? isCnpjValid, bool? isFormValid }) {
    _response = EditUserViewModel(
      isNaturalPerson: isNaturalPerson ?? anyBool(),
      showCpf: showCpf ?? anyBool(),
      showCnpj: showCnpj ?? anyBool(),
      isCpfValid: isCpfValid ?? anyBool(),
      isCnpjValid: isCnpjValid ?? anyBool(),
      isFormValid: isFormValid ?? anyBool(),
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

  testWidgets('should show CPF error', (tester) async {
    loadUserData.mockResponse(showCpf: true, isCpfValid: false);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.cpfErrorFinder, findsOneWidget);
  });

  testWidgets('should hide CPF error', (tester) async {
    loadUserData.mockResponse(showCpf: true, isCpfValid: true);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.cpfErrorFinder, findsNothing);
  });

  testWidgets('should show CNPJ error', (tester) async {
    loadUserData.mockResponse(showCnpj: true, isCnpjValid: false);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.cnpjErrorFinder, findsOneWidget);
  });

  testWidgets('should hide CNPJ error', (tester) async {
    loadUserData.mockResponse(showCnpj: true, isCnpjValid: true);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.cnpjErrorFinder, findsNothing);
  });

  testWidgets('should enable save button', (tester) async {
    loadUserData.mockResponse(isFormValid: true);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.saveButton.onPressed, isNotNull);
  });

  testWidgets('should disable save button', (tester) async {
    loadUserData.mockResponse(isFormValid: false);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.saveButton.onPressed, isNull);
  });
}

extension EditUserPageExtension on WidgetTester {
  Finder get naturalPersonFinder => find.ancestor(of: find.text('Pessoa física'), matching: find.byType(RadioListTile<bool>));
  Finder get legalPersonFinder => find.ancestor(of: find.text('Pessoa jurídica'), matching: find.byType(RadioListTile<bool>));
  Finder get cpfFinder => find.ancestor(of: find.text('CPF'), matching: find.byType(TextFormField));
  Finder get cnpjFinder => find.ancestor(of: find.text('CNPJ'), matching: find.byType(TextFormField));
  Finder get spinnerFinder => find.byType(CircularProgressIndicator);
  Finder get errorFinder => find.text('Erro');
  Finder get cpfErrorFinder => find.descendant(of: cpfFinder, matching: find.text('Valor inválido'));
  Finder get cnpjErrorFinder => find.descendant(of: cnpjFinder, matching: find.text('Valor inválido'));
  Finder get saveButtonFinder => find.ancestor(of: find.text('Salvar'), matching: find.byType(ElevatedButton));
  RadioListTile get naturalPersonRadio => widget(naturalPersonFinder);
  RadioListTile get legalPersonRadio => widget(legalPersonFinder);
  TextFormField get cpfTextField => widget(cpfFinder);
  TextFormField get cnpjTextField => widget(cnpjFinder);
  ElevatedButton get saveButton => widget(saveButtonFinder);
}

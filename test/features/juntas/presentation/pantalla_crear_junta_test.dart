import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronda/features/juntas/presentation/pantalla_crear_junta.dart';
import 'package:ronda/l10n/idiomas.dart';
import 'package:ronda/l10n/textos.dart';

/// Este archivo existe por un error concreto que llegó hasta el usuario.
///
/// El botón de "¿Qué día empieza?" abría un `showDatePicker` con
/// `locale: Locale('es')`, pero la app no declaraba los delegados de
/// localización. Resultado: pantalla roja con "No MaterialLocalizations found"
/// en lugar del calendario. Los tests de dominio no podían verlo porque el
/// fallo estaba en el armado de la app, no en la lógica.
Widget _app(Widget hijo) {
  return ProviderScope(
    child: MaterialApp(
      localizationsDelegates: Idiomas.delegados,
      supportedLocales: Idiomas.soportados,
      locale: Idiomas.espanol,
      home: hijo,
    ),
  );
}

void main() {
  // La pantalla por defecto de los tests es de 800x600 y el formulario no entra:
  // el botón de guardar queda sin construir y los toques no llegan. Se usa el
  // tamaño de un teléfono de verdad, que es donde esto va a correr.
  Future<void> pantallaDeTelefono(WidgetTester t) async {
    await t.binding.setSurfaceSize(const Size(1080, 2400));
    addTearDown(() => t.binding.setSurfaceSize(null));
  }

  testWidgets('el formulario se dibuja con sus cuatro preguntas', (t) async {
    await pantallaDeTelefono(t);
    await t.pumpWidget(_app(const PantallaCrearJunta()));

    expect(find.text(Textos.nombreDeLaJunta), findsOneWidget);
    expect(find.text(Textos.cuantoPoneCadaUna), findsOneWidget);
    expect(find.text(Textos.cadaCuanto), findsOneWidget);
    expect(find.text(Textos.cuandoEmpieza), findsOneWidget);
  });

  testWidgets('las tres frecuencias se ofrecen y se pueden elegir', (t) async {
    await pantallaDeTelefono(t);
    await t.pumpWidget(_app(const PantallaCrearJunta()));

    expect(find.text('Cada semana'), findsOneWidget);
    expect(find.text('Cada quince días'), findsOneWidget);
    expect(find.text('Cada mes'), findsOneWidget);

    await t.tap(find.text('Cada semana'));
    await t.pump();
  });

  // El test que faltaba.
  testWidgets('el calendario ABRE al tocar el día de inicio', (t) async {
    await pantallaDeTelefono(t);
    await t.pumpWidget(_app(const PantallaCrearJunta()));

    final boton = find.byIcon(Icons.calendar_today);
    expect(boton, findsOneWidget);

    await t.tap(boton);
    await t.pumpAndSettle();

    expect(
      find.byType(DatePickerDialog),
      findsOneWidget,
      reason: 'sin los delegados de localización esto revienta en vez de abrir',
    );
  });

  testWidgets('el calendario sale en español, no en inglés', (t) async {
    await pantallaDeTelefono(t);
    await t.pumpWidget(_app(const PantallaCrearJunta()));

    await t.tap(find.byIcon(Icons.calendar_today));
    await t.pumpAndSettle();

    // "Aceptar" y "Cancelar" los dibuja Flutter, no nosotros: si aparecen en
    // español es que los delegados están puestos de verdad.
    expect(find.text('Cancelar'), findsOneWidget);
    expect(find.text('OK'), findsNothing);
  });

  testWidgets('elegir una fecha la deja escrita en el botón', (t) async {
    await pantallaDeTelefono(t);
    await t.pumpWidget(_app(const PantallaCrearJunta()));

    await t.tap(find.byIcon(Icons.calendar_today));
    await t.pumpAndSettle();
    await t.tap(find.text('Cancelar'));
    await t.pumpAndSettle();

    // Vuelve al formulario sin romperse y con la fecha de hoy todavía puesta.
    expect(find.byType(DatePickerDialog), findsNothing);
    expect(find.byIcon(Icons.calendar_today), findsOneWidget);
  });

  testWidgets('sin nombre ni monto, guardar avisa en vez de crear', (t) async {
    await pantallaDeTelefono(t);
    await t.pumpWidget(_app(const PantallaCrearJunta()));

    await t.tap(find.text(Textos.guardar));
    await t.pumpAndSettle();

    expect(find.text(Textos.faltaNombre), findsOneWidget);
    expect(find.text(Textos.faltaMonto), findsOneWidget);
  });

  testWidgets('un monto que no se entiende no pasa la validación', (t) async {
    await pantallaDeTelefono(t);
    await t.pumpWidget(_app(const PantallaCrearJunta()));

    await t.enterText(find.byType(TextFormField).first, 'Junta del mercado');
    await t.enterText(find.byType(TextFormField).last, '0');
    await t.tap(find.text(Textos.guardar));
    await t.pumpAndSettle();

    expect(find.text(Textos.montoInvalido), findsOneWidget);
  });
}

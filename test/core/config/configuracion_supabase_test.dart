import 'package:flutter_test/flutter_test.dart';
import 'package:ronda/core/config/configuracion_supabase.dart';

/// Estos tests corren sin --dart-define, que es justo el caso que interesa:
/// comprobar que la app sabe decir que le falta en vez de reventar.
void main() {
  group('ConfiguracionSupabase sin --dart-define', () {
    test('no esta completa', () {
      expect(ConfiguracionSupabase.estaCompleta, isFalse);
    });

    test('nombra las dos variables que faltan', () {
      expect(
        ConfiguracionSupabase.faltantes,
        containsAll(<String>['SUPABASE_URL', 'SUPABASE_ANON_KEY']),
      );
    });

    test(
      'los nombres publicados son los que se pasan por linea de comando',
      () {
        expect(ConfiguracionSupabase.nombreUrl, 'SUPABASE_URL');
        expect(ConfiguracionSupabase.nombreClave, 'SUPABASE_ANON_KEY');
      },
    );
  });
}

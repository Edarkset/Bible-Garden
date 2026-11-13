/// Configuração vinda do build (`--dart-define=...`). Nada secreto aqui: a
/// chave "anon" do Supabase é pública por natureza e o RLS protege os dados.
abstract final class Env {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
  );

  /// Sincronização só existe quando o projeto Supabase está configurado.
  static bool get syncEnabled =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}

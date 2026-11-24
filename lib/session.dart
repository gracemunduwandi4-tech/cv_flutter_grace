/// Garde en mémoire le compte connecté pendant que l'application est ouverte.
class Session {
  static int? userId;
  static String? email;

  static bool get isLoggedIn => userId != null;

  static void clear() {
    userId = null;
    email = null;
  }
}

import 'package:day_22_riverpod_exercise/core/enum/auth_type.dart';
import 'package:day_22_riverpod_exercise/core/firebase/fire_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication_view_model.g.dart';

@Riverpod(keepAlive: true)
class AuthenticationViewModel extends _$AuthenticationViewModel {
  @override
  FutureOr<User?> build() {
    return currentUser;
  }

  User? get currentUser => ref.watch(firebaseAuthProvider).currentUser;

  Future<void> authUser({
    required String email,
    required String password,
    required AuthType authType,
  }) async {
    state = AsyncLoading();

    try {
      final authProvider = ref.read(firebaseAuthProvider);

      switch (authType) {
        case AuthType.login:
          await authProvider.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        case AuthType.register:
          await authProvider.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
      }

      state = AsyncData(currentUser);
    } on FirebaseAuthException catch (e) {
      state = AsyncError(e, StackTrace.current);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> logout() async {
    state = AsyncLoading();

    try {
      await ref.read(firebaseAuthProvider).signOut();
      state = AsyncData(currentUser);
    } on FirebaseAuthException catch (e) {
      state = AsyncError(e, StackTrace.current);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

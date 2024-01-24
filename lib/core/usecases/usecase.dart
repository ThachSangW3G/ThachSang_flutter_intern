abstract class Usecase<Type, Params> {
  Future<Type> call({Params params});
}

abstract class UseCaseWithoutParams<Type> {
  const UseCaseWithoutParams();

  Future<Type> call();
}

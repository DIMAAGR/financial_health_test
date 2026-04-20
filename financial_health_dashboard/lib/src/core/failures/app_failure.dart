sealed class AppFailure {
  const AppFailure(this.message);

  final String message;
}

class NetworkFailure extends AppFailure {
  const NetworkFailure([
    super.message = 'Não foi possível conectar ao serviço.',
  ]);
}

class ServerFailure extends AppFailure {
  const ServerFailure([
    super.message = 'O serviço retornou uma falha inesperada.',
  ]);
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}

class StorageFailure extends AppFailure {
  const StorageFailure([
    super.message = 'Não foi possível acessar os dados locais.',
  ]);
}

class ParsingFailure extends AppFailure {
  const ParsingFailure([
    super.message = 'Os dados retornaram em um formato inválido.',
  ]);
}

class UnknownFailure extends AppFailure {
  const UnknownFailure([
    super.message = 'Não foi possível concluir a operação.',
  ]);
}

class AmountValueFailure extends AppFailure {
  const AmountValueFailure([
    super.message = 'Valor inserido na operação deve ser maior que zero.',
  ]);
}

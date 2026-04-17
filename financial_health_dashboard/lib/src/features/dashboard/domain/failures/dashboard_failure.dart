class DashboardFailure {
  const DashboardFailure(this.message);

  final String message;
}

class DashboardNetworkFailure extends DashboardFailure {
  const DashboardNetworkFailure([
    super.message = 'Não foi possível conectar ao serviço financeiro.',
  ]);
}

class DashboardServerFailure extends DashboardFailure {
  const DashboardServerFailure([
    super.message = 'O serviço financeiro retornou uma falha inesperada.',
  ]);
}

class DashboardValidationFailure extends DashboardFailure {
  const DashboardValidationFailure(super.message);
}

class DashboardStorageFailure extends DashboardFailure {
  const DashboardStorageFailure([
    super.message = 'Não foi possível acessar os dados locais do dashboard.',
  ]);
}

class DashboardParsingFailure extends DashboardFailure {
  const DashboardParsingFailure([
    super.message = 'Os dados financeiros retornaram em um formato inválido.',
  ]);
}

class DashboardUnknownFailure extends DashboardFailure {
  const DashboardUnknownFailure([
    super.message = 'Não foi possível concluir a operação no dashboard.',
  ]);
}

class DashboardAmountValueFailure extends DashboardFailure {
  const DashboardAmountValueFailure([
    super.message = 'Valor inserido na operação deve ser maior que zero.',
  ]);
}

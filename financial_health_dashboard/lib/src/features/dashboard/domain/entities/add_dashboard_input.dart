abstract class AddDashboardInput {
  const AddDashboardInput({required this.amount, required this.title});

  final double amount;
  final String title;

  String get normalizedTitle => title.trim();
}

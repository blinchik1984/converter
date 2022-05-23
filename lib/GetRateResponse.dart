class InitRateResponse {
  final double rate;
  final String? errorMessage;
  final String updatedAt;

  InitRateResponse({
    required this.rate,
    required this.errorMessage,
    required this.updatedAt,
  });
}
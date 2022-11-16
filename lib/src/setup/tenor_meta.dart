class TenorMeta {
  String apiKey;
  String? clientKey;
  String? locale;
  String? country;

  TenorMeta({required this.apiKey, this.clientKey, this.locale, this.country});
}

TenorMeta? tenorMeta;
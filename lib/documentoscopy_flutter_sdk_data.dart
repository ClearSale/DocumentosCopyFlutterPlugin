class CSDocumentosCopyResult {
  final String documentType;
  final String sessionId;

  CSDocumentosCopyResult(this.documentType, this.sessionId);

  factory CSDocumentosCopyResult.fromJson(Map<String, dynamic> json) {
    return CSDocumentosCopyResult(
      json['documentType'],
      json['sessionId'],
    );
  }
}
class WsResponseModel {
  final String? message;
  final bool success;
  final dynamic data;
  final EnumResponse? enumResponse;

  WsResponseModel(
      {this.message, required this.success, this.data, this.enumResponse});
}

enum EnumResponse { DATA_OK, INTERNAL_SERVER_ERROR, NEW_USER }
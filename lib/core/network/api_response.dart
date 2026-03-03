class ApiResponse<T> {
  final T? data;
  final String? message;
  final int? statusCode;
  final bool isSuccess;

  ApiResponse._({
    this.data,
    this.message,
    this.statusCode,
    required this.isSuccess
  });

  factory ApiResponse.success({T? data, int? statusCode}) {
    return ApiResponse._(
      data: data,
      statusCode: statusCode,
      isSuccess: true
    );
  }

  factory ApiResponse.error({String? message, int? statusCode}) {
    return ApiResponse._(
      message: message,
      statusCode: statusCode,
      isSuccess: false
    );
  }


}
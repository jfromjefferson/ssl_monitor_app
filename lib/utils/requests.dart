import 'package:dio/dio.dart';

Future<Map<String, dynamic>> authUser({
  required String url,
  required Map<String, dynamic> data,
}) async {
  Dio dio = Dio();
  dio.options.connectTimeout = 10000;
  dio.options.headers['Api-key'] = data['apiKey'];
  dio.options.headers['Username'] = data['username'];
  dio.options.headers['Password'] = data['password'];

  try {
    Response<dynamic> response = await dio.get(url);

    return {
      'success': response.statusCode == 200,
      'response': response.data,
    };
  } on DioError catch (e) {
    return {
      'success': false,
      'response': e.response?.data,
    };
  }
}

Future<Map<String, dynamic>> createUser({
  required String url,
  required Map<String, dynamic> data,
}) async {
  Dio dio = Dio();
  dio.options.connectTimeout = 10000;
  dio.options.headers['Api-key'] = data['apiKey'];

  try {
    Response<dynamic> response = await dio.post(url, data: data);

    return {
      'success': response.statusCode == 200,
      'response': response.data,
    };
  } on DioError catch (e) {
    return {
      'success': false,
      'response': e.response?.data,
    };
  }
}

Future<Map<String, dynamic>> postData({
  required String url,
  required Map<String, dynamic> data,
}) async {
  Dio dio = Dio();
  dio.options.connectTimeout = 10000;
  dio.options.headers['Api-key'] = data['apiKey'];
  dio.options.headers['Sys-user-uuid'] = data['SysUserUuid'];

  try {
    Response<dynamic> response = await dio.post(url, data: data);

    return {
      'success': response.statusCode == 200,
      ...response.data,
    };
  } on DioError catch (e) {
    return {
      'success': false,
      'response': e.response?.data,
    };
  }
}

Future<Map<String, dynamic>> fetchData({required String url}) async {
  Dio dio = Dio();
  dio.options.connectTimeout = 10000;

  try {
    Response<dynamic> response = await dio.get(url);

    return {
      'success': response.statusCode == 200,
      'response': response.data,
    };
  } on DioError catch (e) {
    return {
      'success': false,
      'response': e.response?.data,
    };
  }
}

class Requests {
  late Dio dio;

  Requests() {
    dio = Dio();
    dio.options.connectTimeout = 10000;
  }

  Future<Map<String, dynamic>> get({
    required String url,
    int? timeout,
    Map<String, dynamic>? headers,
  }) async {
    if (timeout != null) {
      dio.options.connectTimeout = timeout;
    }

    if (headers != null) {
      headers.forEach((key, value) {
        dio.options.headers[key] = value;
      });
    }

    try {
      Response<dynamic> response = await dio.get(url);

      return {
        'success': response.statusCode == 200,
        ...response.data,
      };
    } on DioError catch (e) {
      return {
        'success': false,
        'response_error': e.response?.data,
      };
    }
  }

  Future<Map<String, dynamic>> post({
    required String url,
    int? timeout,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    if (timeout != null) {
      dio.options.connectTimeout = timeout;
    }

    if (headers != null) {
      headers.forEach((key, value) {
        dio.options.headers[key] = value;
      });
    }

    try {
      Response<dynamic> response = await dio.post(url, data: data);

      return {
        'success': response.statusCode == 200,
        ...response.data,
      };
    } on DioError catch (e) {
      return {
        'success': false,
        'response_error': e.response?.data,
      };
    }
  }

  Future<Map<String, dynamic>> put({
    required String url,
    int? timeout,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    if (timeout != null) {
      dio.options.connectTimeout = timeout;
    }

    if (headers != null) {
      headers.forEach((key, value) {
        dio.options.headers[key] = value;
      });
    }

    try {
      Response<dynamic> response = await dio.put(url, data: data);

      return {
        'success': response.statusCode == 200,
        ...response.data,
      };
    } on DioError catch (e) {
      return {
        'success': false,
        'response_error': e.response?.data,
      };
    }
  }

  Future<Map<String, dynamic>> delete({
    required String url,
    int? timeout,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    if (timeout != null) {
      dio.options.connectTimeout = timeout;
    }

    if (headers != null) {
      headers.forEach((key, value) {
        dio.options.headers[key] = value;
      });
    }

    try {
      Response<dynamic> response = await dio.delete(url, data: data);

      return {
        'success': response.statusCode == 200,
        ...response.data,
      };
    } on DioError catch (e) {
      return {
        'success': false,
        'response_error': e.response?.data,
      };
    }
  }
}

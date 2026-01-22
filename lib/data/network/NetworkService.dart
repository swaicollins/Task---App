import 'package:task/core/model/request/LoginRequest/LoginRequest.dart';
import 'package:task/core/model/request/createTasksRequest/CreateTasksRequest.dart';
import 'package:task/core/model/response/GetTasksResponse/GetTasksResponse.dart';
import 'package:task/core/model/response/LoginResponse/LoginResponse.dart';
import 'package:task/core/model/response/createTasksResponse/CreateTasksResponse.dart';
import 'package:task/core/model/response/deleteTaskResponse/DeleteTaskResponse.dart';
import '../../core/model/request/register/RegisterRequest.dart';
import '../../core/model/request/updateTasksRequest/UpdateTaskRequest.dart';
import '../../core/model/response/RegisterResponse/RegisterResponse.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/model/response/getTasksById/GetTasksByIdResponse.dart';
import '../../core/model/response/updateTaskResponse/UpdateTaskResponse.dart';

class NetworkService {
  static final BASE_URL = "http://10.0.2.2:81/api";

  static final register = BASE_URL + "/auth/register";
  static final login = BASE_URL + "/auth/login";
  static final getTask = BASE_URL + "/tasks";
  static final createTask = BASE_URL + "/tasks";
  static final getTasksId = BASE_URL + "/tasks";
  static final updateTasksId = BASE_URL + "/tasks";
  static final deleteTasks = BASE_URL + "/tasks";

  Future<RegisterResponse> registerUser(RegisterRequest request) async {
    var uri = Uri.parse(register);
    Map<String, String> requestHeaders = {'Accept': 'application/json'};
    try {
      var response = await http.post(
        uri,
        body: request.toJson(),
        headers: requestHeaders,
      );
      print("!!!!!!!!!!!!!!!!!!!${response}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("################${response.statusCode}");
        return RegisterResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Error ${response.body}");
      }
    } catch (e) {
      throw Exception("Error $e");
    }
  }

  Future<LoginResponse> loginUser(LoginRequest request) async {
    var uri = Uri.parse(login);

    var response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }

  Future<List<GetTasksResponse>> getTasks(String token) async {
    var uri = Uri.parse(getTask);
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'content-type': 'application/json',
      'authorization': token,
    };
    try {
      var response = await http.get(uri, headers: requestHeaders);
      print(response.body);
      print(response.request);
      print(response.headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body) as List<dynamic>;
        var res = data.map((e) => GetTasksResponse.fromJson(e)).toList();
        return res;
      } else {
        throw Exception("Error ${response.body}");
      }
    } catch (e) {
      throw Exception("Error $e");
    }
  }

  Future<CreateTasksResponse> createTasks(
    CreateTasksRequest createTaskRequest,
    String token,
  ) async {
    var uri = Uri.parse(createTask);
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'content-type': 'application/json',
      'authorization': token,
    };
    print(">>>>>>>>>>>>>>>>>>>>>>${createTaskRequest.toJson()}");
    var response = await http.post(
      uri,
      body: json.encode(createTaskRequest),
      headers: requestHeaders,
    );
    print("++++++++++++++++++++++${json.decode(response.body)}");
    print(
      "=====================================>${CreateTasksRequest.fromJson(jsonDecode(response.body))}",
    );
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateTasksResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Error ${response.body}");
      }
    } catch (e) {
      throw Exception("Error $e");
    }
  }

  Future<GetTasksByIdResponse> getTaskById(String token, int id) async {
    var uri = Uri.parse("$getTasksId/$id");
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'content-type': 'application/json',
      'authorization': token,
    };
    try {
      var response = await http.delete(uri, headers: requestHeaders);
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${response.body}");
      print("*************************************${response.body}");
      print(
        "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${GetTasksByIdResponse.fromJson(jsonDecode(response.body))}",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return GetTasksByIdResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Error ${response.body}");
      }
    } catch (e) {
      throw Exception("Error $e");
    }
  }

  Future<UpdateTaskResponse> updateTask(
    UpdateTaskRequest updateTaskRequest,
    String token,
    int id,
  ) async {
    var uri = Uri.parse("$updateTasksId/$id");
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'content-type': 'application/json',
      'authorization': token,
    };
    print(">>>>>>>>>>>>>>>>>>>>>>${updateTaskRequest.toJson()}");
    var response = await http.post(
      uri,
      body: json.encode(updateTaskRequest),
      headers: requestHeaders,
    );
    print("++++++++++++++++++++++${json.decode(response.body)}");
    print(
      "=====================================>${CreateTasksRequest.fromJson(jsonDecode(response.body))}",
    );
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UpdateTaskResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Error ${response.body}");
      }
    } catch (e) {
      throw Exception("Error $e");
    }
  }

  Future<DeleteTaskResponse> deleteTask(String token, int id) async {
    var uri = Uri.parse("$deleteTasks/$id");
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'content-type': 'application/json',
      'authorization': token,
    };
    var response = await http.put(uri, headers: requestHeaders);
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return DeleteTaskResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Error ${response.body}");
      }
    } catch (e) {
      throw Exception("Error $e");
    }
  }
}

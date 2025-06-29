import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService{
  static String baseUrl = dotenv.env['BASE_URL']??" ";

  //add a user in database
  Future<String?> addUser(String name) async{
    try{
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'name':name}),
      );

      if(response.statusCode == 200 || response.statusCode == 201){
        print(response.body);
        return jsonDecode(response.body)['_id'];
      }
      else{
        print('there is some error in api with status ${response.statusCode} -  ${response.body}');
      }
    }catch(e){
      print(e);
    }
    return null;
  }

  //add a trip in database
  Future<String?> createTrip(String name,String createdBy,List<String> members) async{
    try{
      final response = await http.post(
          Uri.parse('$baseUrl/trips'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({'name':name, 'createdBy':createdBy, 'members':members}),
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        print(response.body);

        return jsonDecode(response.body)['_id'];
      }
      else{
        print('there is some error in api with status ${response.statusCode} -  ${response.body}');
      }
    }catch(e){
      print(e);
    }
    return null;
  }

  //add a transaction in database
  Future<void> addTransaction(String tripId,String paidBy,double amount,List<Map<String,dynamic>> distributedTo,String description) async{
    try{
      final response = await http.post(
        Uri.parse('$baseUrl/transactions'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'tripId' : tripId,
          'paidBy' : paidBy,
          'amount' : amount,
          'description' : description,
          'distributedTo' : distributedTo
        })
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        print(response.body);
      }
      else{
        print('there is some error in api with status ${response.statusCode} -  ${response.body}');
      }
    }catch(e){
      print(e);
    }
  }

  //fetch data from transactions
  Future<List<Map<String,dynamic>>> getTransactions(String tripId) async{
    final response = await http.get(Uri.parse('$baseUrl/transactions/$tripId'));
    if(response.statusCode == 200 || response.statusCode == 201){
      print(response.body);
    }
    else{
      print('there is some error in api with status ${response.statusCode} -  ${response.body}');
    }
    return List<Map<String,dynamic>>.from(jsonDecode(response.body));
  }

  //fetch data from trips
  Future<Map<String,dynamic>> getTripInfo(String tripId) async{
    final response = await http.get(Uri.parse('$baseUrl/trips/$tripId'));
    return jsonDecode(response.body);
  }

  //fetch data from users
  Future<List<Map<String,dynamic>>> getUsers() async{
    final response = await http.get(Uri.parse('$baseUrl/users/'));
    return List<Map<String,dynamic>>.from(jsonDecode(response.body));
  }

  //add new member in trip / someone join the group
  Future<void> addMemberToTrip(String tripId, String userId) async {
    final url = Uri.parse("$baseUrl/trip/$tripId/addMember");

    try {
      final response = await http.post(
        url,
        body: jsonEncode({"userId": userId}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        print("Member added successfully: ${response.body}");
      } else {
        print("Failed to add member: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

}
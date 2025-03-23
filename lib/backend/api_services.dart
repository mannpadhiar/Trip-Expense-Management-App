import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService{
  static const String baseUrl = 'https://trip-expense-management-app.onrender.com';

  //add a user in database
  Future<String?> addUser(String name,String email) async{
    try{
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'name':name,'email':email}),
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
  Future<void> createTrip(String name,String createdBy,List<String> members) async{
    try{
      final response = await http.post(
          Uri.parse('$baseUrl/trips'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({'name':name, 'createdBy':createdBy, 'members':members}),
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

  //add a transaction in database
  Future<void> addTransaction(String tripId,String paidBy,double amount,List<Map<String,dynamic>> distributedTo) async{
    try{
      final response = await http.post(
        Uri.parse('$baseUrl/transactions'),
        headers: {"Content-Type": "application/json"},
        body: {
          'tripId' : tripId,
          'paidBy' : paidBy,
          'amount' : amount,
          'distributedTo' : distributedTo
        }
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
    return jsonDecode(response.body);
  }

  //fetch data from trips
  Future<List<Map<String,dynamic>>> getTrips(String tripId) async{
    final response = await http.get(Uri.parse('$baseUrl/trips/$tripId'));
    return jsonDecode(response.body);
  }

  //fetch data from users
  Future<List<Map<String,dynamic>>> getUsers() async{
    final response = await http.get(Uri.parse('$baseUrl/users/'));
    return List<Map<String,dynamic>>.from(jsonDecode(response.body));
  }
}
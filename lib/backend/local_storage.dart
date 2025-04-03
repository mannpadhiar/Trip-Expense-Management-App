import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlDatabase{
  late Database _database;
  late Database _userDatabase;
  late Database _tripDatabase;

  Future<void> initDatabase() async{
    try{
      _database = await openDatabase(
        join(await getDatabasesPath(),'trip_information.db'),
        version: 1,
        onCreate: (db, version) async{
          return await db.execute('''
          CREATE TABLE tripInformation(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tripName TEXT,
            tripId TEXT,
            userName TEXT,
            userEmail TEXT,
            userId TEXT,
            totalMembers INTEGER,
            TotalAmount decimal(10,2)
          )
        ''');
        },
      );
    }catch(e){
      print('Got error while creating SQL database : $e');
    }
  }

  Future<List<Map<String,dynamic>>> fetchInfo() async{
    try{
      List<Map<String,dynamic>> information = await _database.query('tripInformation');
      return information;
    }catch(e){
      print('Got error while fetching info from SQL : $e');
    }
    return [];
  }

  Future<void> addTripInfo(Map<String, dynamic> tripInfo) async {
    try {
      await _database.insert('tripInformation', tripInfo);
    } catch (e) {
      print('Error inserting trip info: $e');
    }
  }

  Future<void> deleteTripInfo(int id) async {
    try {
      await _database.delete(
        'tripInformation',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting trip info: $e');
    }
  }


  //for storing user information
  Future<void> initDatabaseUser() async{
    try{
      _userDatabase = await openDatabase(
        join(await getDatabasesPath(),'user_database.db'),
        version: 1,
        onCreate: (db, version) async{
          return await db.execute('''
            CREATE TABLE userDatabase(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              userId TEXT,
              userName TEXT,
              userEmail
            )
          ''');
        },
      );
      await fetchInfoFromUser();
    }catch(e){
      print('Got error while creating user SQL database : $e');
    }
  }

  Future<List<Map<String,dynamic>>> fetchInfoFromUser() async{
    final info = await _userDatabase.query('userDatabase');
    return info;
  }

  Future<void> addDataUserSqlDatabase(Map<String,dynamic> user) async{
    try{
      await _userDatabase.insert('userDatabase', user);
    }catch(e){
      print('error while adding data in database : $e');
    }
  }


  //for storing trip info
  Future<void> initDatabaseTrip() async{
    try{
      _tripDatabase = await openDatabase(
        join(await getDatabasesPath(),'trip_database.db'),
        version: 1,
        onCreate: (db, version) async{
          return await db.execute('''
            CREATE TABLE tripDatabase(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              userId TEXT,
              tripId TEXT,
              tripName TEXT
            )
          ''');
        },
      );
      await fetchInfoFromTrip();
    }catch(e){
      print('Got error while creating trip SQL database : $e');
    }
  }

  Future<List<Map<String,dynamic>>> fetchInfoFromTrip() async{
    final info = await _tripDatabase.query('tripDatabase');
    return info;
  }

  Future<void> addDataTripSqlDatabase(Map<String,dynamic> user) async{
    try{
      await _tripDatabase.insert('tripDatabase', user);
    }catch(e){
      print('error while adding data in database : $e');
    }
  }

}
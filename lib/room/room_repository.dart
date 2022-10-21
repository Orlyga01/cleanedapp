import 'package:cloud_firestore/cloud_firestore.dart';
import 'room_model.dart';

class FirebaseUserRoomsRepository {
  late String userid;
  late DocumentReference _userDoc;
  late FirebaseFirestore _db;
  static final FirebaseUserRoomsRepository _dbUserRooms =
      FirebaseUserRoomsRepository._internal();
  FirebaseUserRoomsRepository._internal();
  factory FirebaseUserRoomsRepository({required String userid}) {
    _dbUserRooms.userid = userid;
    _dbUserRooms._db = FirebaseFirestore.instance;
    _dbUserRooms._userDoc = _dbUserRooms._db.collection("users").doc("123");
    return _dbUserRooms;
  }
  Future<void> addInitialRoomsList({List<Room>? rooms}) async {
    if (rooms == null) {
      WriteBatch batch = _db.batch();
      rooms = [];
      for (var element in RoomType.values) {
        int? imp = RoomTypes[element]!.importance;
        if (imp != null && imp > 5) {
          rooms.add(
            Room.empty
              ..type = element
              ..title = RoomTypes[element]!.name!,
          );
        }
      }
      List<Map<String, dynamic>> toSave = [];
      for (var element in rooms) {
        toSave.add(element.toJson());
      }
      return _userDoc.update({"rooms": toSave});
      // batch.commit();
    }
  }

  Future<void> add(Room room) {
    return _userDoc.update({
      "rooms": FieldValue.arrayUnion([room.toJson()])
      //return _userDoc.set(room.toJson());
    });
  }

// This includes all actions such as add update and remove
  Future<void> update(List<Room> lrooms) async {
    
    // // return _userDoc.set(room.toJson());
    // // final int index = lrooms.indexWhere(( (room) =>room.id == room.id));
    // // if (index > -1 ) {

    // // }
    // WriteBatch batch = _db.batch();
    // //batch.set();
    // // _userDoc.rooms.where("rooms", "array-contains", room.toJson());
    // Map<String, dynamic> roomJ = room.toJson();
    // batch.update(_userDoc, {
    //   "rooms": FieldValue.arrayRemove([roomJ])
    // });
    // batch.update(_userDoc, {
    //   "rooms": FieldValue.arrayUnion([roomJ])
    // });
    // _userDoc.update({
    //   "rooms": FieldValue.arrayUnion([
    //     {
    //       "Price": 3000,
    //       "Paid": true,
    //     }
    //   ])
    // });
  }
}

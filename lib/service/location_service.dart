import '../models/location_model.dart';
import '../database/database_helper.dart';

class LocationService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<LocationModel>> getFavoriteLocations() async {
    try {
      return await _databaseHelper.getAllLocations();
    } catch (e) {
      throw Exception('Failed to get locations: $e');
    }
  }

  Future<LocationModel?> getLocationById(String id) async {
    try {
      return await _databaseHelper.getLocationById(id);
    } catch (e) {
      throw Exception('Failed to get location: $e');
    }
  }

  Future<bool> addLocation(LocationModel location) async {
    try {
      final result = await _databaseHelper.insertLocation(location);
      return result > 0;
    } catch (e) {
      throw Exception('Failed to add location: $e');
    }
  }

  Future<bool> updateLocation(LocationModel location) async {
    try {
      final result = await _databaseHelper.updateLocation(location);
      return result > 0;
    } catch (e) {
      throw Exception('Failed to update location: $e');
    }
  }

  Future<bool> deleteLocation(String locationId) async {
    try {
      final result = await _databaseHelper.deleteLocation(locationId);
      return result > 0;
    } catch (e) {
      throw Exception('Failed to delete location: $e');
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:location_favorites/service/location_service.dart';
import 'package:uuid/uuid.dart';
import '../models/location_model.dart';

class LocationViewModel extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final Uuid _uuid = Uuid();

  List<LocationModel> _favoriteLocations = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<LocationModel> get favoriteLocations => _favoriteLocations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  LocationViewModel() {
    loadFavoriteLocations();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> loadFavoriteLocations() async {
    _setLoading(true);
    _setError(null);

    try {
      _favoriteLocations = await _locationService.getFavoriteLocations();
    } catch (e) {
      _setError('Failed to load locations: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addLocation({
    required String name,
    required String description,
    required double latitude,
    required double longitude,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final location = LocationModel(
        id: _uuid.v4(),
        name: name,
        description: description,
        latitude: latitude,
        longitude: longitude,
        createdAt: DateTime.now(),
      );

      final success = await _locationService.addLocation(location);
      if (success) {
        await loadFavoriteLocations(); // Reload to get updated list
      } else {
        _setError('Failed to add location');
      }
      return success;
    } catch (e) {
      _setError('Failed to add location: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateLocation({
    required String id,
    required String name,
    required String description,
    required double latitude,
    required double longitude,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final existingLocation = await _locationService.getLocationById(id);
      if (existingLocation == null) {
        _setError('Location not found');
        return false;
      }

      final updatedLocation = existingLocation.copyWith(
        name: name,
        description: description,
        latitude: latitude,
        longitude: longitude,
      );

      final success = await _locationService.updateLocation(updatedLocation);
      if (success) {
        await loadFavoriteLocations(); // Reload to get updated list
      } else {
        _setError('Failed to update location');
      }
      return success;
    } catch (e) {
      _setError('Failed to update location: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteLocation(String id) async {
    _setLoading(true);
    _setError(null);

    try {
      final success = await _locationService.deleteLocation(id);
      if (success) {
        await loadFavoriteLocations(); // Reload to get updated list
      } else {
        _setError('Failed to delete location');
      }
      return success;
    } catch (e) {
      _setError('Failed to delete location: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
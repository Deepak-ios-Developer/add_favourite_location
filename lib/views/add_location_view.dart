import 'package:flutter/material.dart';
import 'package:location_favorites/models/location_model.dart';
import 'package:location_favorites/screens/pick_location_screen.dart';
import 'package:provider/provider.dart';

import '../viewmodels/location_viewmodel.dart';

/// Screen to pick a location on Google Maps
/// Add/Edit Location View
class AddLocationView extends StatefulWidget {
  final LocationModel? editLocation;

  const AddLocationView({Key? key, this.editLocation}) : super(key: key);

  @override
  _AddLocationViewState createState() => _AddLocationViewState();
}

class _AddLocationViewState extends State<AddLocationView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.editLocation != null) {
      _nameController.text = widget.editLocation!.name;
      _descriptionController.text = widget.editLocation!.description;
      _latitudeController.text = widget.editLocation!.latitude.toString();
      _longitudeController.text = widget.editLocation!.longitude.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _latitudeController.clear();
    _longitudeController.clear();
  }

  Future<void> _saveLocation() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = Provider.of<LocationViewModel>(context, listen: false);

      bool success;
      if (widget.editLocation != null) {
        success = await viewModel.updateLocation(
          id: widget.editLocation!.id,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          latitude: double.parse(_latitudeController.text),
          longitude: double.parse(_longitudeController.text),
        );
      } else {
        success = await viewModel.addLocation(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          latitude: double.parse(_latitudeController.text),
          longitude: double.parse(_longitudeController.text),
        );
      }

      if (success) {
        _clearForm();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.editLocation != null
                ? 'Location updated successfully!'
                : 'Location added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        if (widget.editLocation != null) {
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(viewModel.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
            viewModel.clearError();
          });
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Location Name',
                              prefixIcon: Icon(Icons.place),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a location name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              prefixIcon: Icon(Icons.description),
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _latitudeController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: const InputDecoration(
                                    labelText: 'Latitude',
                                    prefixIcon: Icon(Icons.gps_fixed),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Required';
                                    }
                                    final val = double.tryParse(value);
                                    if (val == null) return 'Invalid number';
                                    if (val < -90 || val > 90) {
                                      return 'Latitude must be between -90 and 90';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _longitudeController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: const InputDecoration(
                                    labelText: 'Longitude',
                                    prefixIcon: Icon(Icons.gps_fixed),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Required';
                                    }
                                    final val = double.tryParse(value);
                                    if (val == null) return 'Invalid number';
                                    if (val < -180 || val > 180) {
                                      return 'Longitude must be between -180 and 180';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MapPickerScreen(),
                                ),
                              );

                              if (result != null) {
                                setState(() {
                                  _latitudeController.text =
                                      result.latitude.toString();
                                  _longitudeController.text =
                                      result.longitude.toString();
                                });
                              }
                            },
                            icon: const Icon(Icons.map),
                            label: const Text("Pick from Map"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: viewModel.isLoading ? null : _saveLocation,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: viewModel.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            widget.editLocation != null
                                ? 'Update Location'
                                : 'Add Location',
                            style: const TextStyle(fontSize: 16),
                          ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.editLocation == null)
                    OutlinedButton(
                      onPressed: _clearForm,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Clear Form'),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'dart:io';
import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/providers/user_places.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState(){
    return _AddPlaceScreeneState();
  }
}

class _AddPlaceScreeneState extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredPlace = '';
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _savePlace(){
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
    }

    if(_enteredPlace.isEmpty || _selectedImage == null || _selectedLocation == null){
      return;
    }

    ref.read(userPlacesProvider.notifier).addPlace(_enteredPlace, _selectedImage!, _selectedLocation!,);

    Navigator.of(context).pop();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'), 
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                  validator:(value) {
                    if(value == null || value.isEmpty){
                      return 'Enter Place.. ';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredPlace = value!;
                  },
              ),
        
      
              const SizedBox(height: 16,),
      
              ImageInput(onPickImage: (image) {
                _selectedImage = image;
              },),

              const SizedBox(height: 10,),

              LocationInput(onSelectLocation: (location) {
                _selectedLocation = location;
              },),
        
              const SizedBox(height: 16,),
        
              ElevatedButton.icon(
                onPressed: _savePlace, 
                icon: const Icon(Icons.add), 
                label: const Text('Add Place'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
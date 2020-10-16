import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../providers/meals.dart';
import '../providers/categories.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/checkbox_form_field.dart';
import '../widgets/multi_field.dart';
import '../models/meal.dart';

class EditMealScreen extends StatefulWidget {
  static const routeName = '/edit-meal';
  @override
  _EditMealScreenState createState() => _EditMealScreenState();
}

class _EditMealScreenState extends State<EditMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fbKey = GlobalKey<FormBuilderState>();
  final _imgUrlFocusNode = FocusNode();
  var _pageTitle = 'Add Recipe';
  List<String> _categories;
  var _initValues = {
    'title': '',
    'duration': '',
    'imageUrl': '',
    'ingredients': [],
    'categories': [],
    'steps': [],
    'affordability': null,
    'complexity': null,
    'isVegan': false,
    'isVegetarian': false,
    'isGlutenFree': false,
    'isLactoseFree': false,
  };
  var _editedRecipe = Meal(
    id: null,
    categories: [],
    title: '',
    imageUrl: '',
    ingredients: [],
    steps: [],
    duration: 0,
    complexity: null,
    affordability: null,
    isGlutenFree: false,
    isLactoseFree: false,
    isVegan: false,
    isVegetarian: false,
  );
  var _affDropdownValue = Affordability.Cheap;
  var _compDropdownValue = Complexity.Simple;
  var _isInit = false;
  List<String> _newIngredients = [];
  List<String> _newSteps = [];
  // var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final id = ModalRoute.of(context).settings.arguments as String;
      if (id != null) {
        _pageTitle = 'Edit Recipe';
        _editedRecipe = Provider.of<Meals>(context, listen: false).findById(id);
        _initValues = {
          'title': _editedRecipe.title,
          'duration': '${_editedRecipe.duration}',
          'imageUrl': _editedRecipe.imageUrl,
          'ingredients': _editedRecipe.ingredients,
          'categories': _editedRecipe.categories,
          'steps': _editedRecipe.steps,
          'isVegan': _editedRecipe.isVegan,
          'isVegetarian': _editedRecipe.isVegetarian,
          'isGlutenFree': _editedRecipe.isGlutenFree,
          'isLactoseFree': _editedRecipe.isLactoseFree,
        };
        _affDropdownValue = _editedRecipe.affordability;
        _compDropdownValue = _editedRecipe.complexity;
      }
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  void _saveForm() {
    if (!_formKey.currentState.validate() || !_fbKey.currentState.validate())
      return;
    _formKey.currentState.save();
    _editedRecipe = _editedRecipe.copyWith(
        categories: _categories,
        ingredients: _newIngredients,
        steps: _newSteps);
    print(_editedRecipe.toString());
    if (_editedRecipe.id != null) {
      Provider.of<Meals>(context, listen: false)
          .updateMeal(_editedRecipe.id, _editedRecipe);
    } else {
      Provider.of<Meals>(context, listen: false).addMeal(_editedRecipe);
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
    _imgUrlFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _pageTitle,
            style: TextStyle(fontFamily: 'Lato'),
          ),
          leading: IconButton(
            tooltip: 'Cancel',
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            IconButton(
              tooltip: 'Save Changes',
              icon: Icon(Icons.check),
              onPressed: _saveForm,
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    initialValue: _initValues['title'],
                    decoration: InputDecoration(
                      labelText: 'Recipe Title',
                      filled: true,
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_imgUrlFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) return 'Please provide a title!';
                      if (value.length < 4)
                        return 'Recipe name must contain at least 5 characters!';
                      if (RegExp(r'/[$-/:-?{-~!"^_`\[\]]/').hasMatch(value))
                        return 'A recipe title cannot contain any symbols!';
                      return null;
                    },
                    onSaved: (value) {
                      _editedRecipe = _editedRecipe.copyWith(title: value);
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    focusNode: _imgUrlFocusNode,
                    initialValue: _initValues['imageUrl'],
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      labelText: 'Image URL',
                      filled: true,
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      // FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) return 'Please provide a URL!';
                      if (!RegExp(
                              r'(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png)')
                          .hasMatch(value))
                        return 'Please provide a valid image URL';
                      return null;
                    },
                    onSaved: (value) {
                      _editedRecipe = _editedRecipe.copyWith(imageUrl: value);
                    },
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Ingredients',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
                  MultiField(
                    fieldType: 'Ingredient',
                    items: List<String>.from(
                      _initValues['ingredients'],
                    ),
                    newItems: _newIngredients,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Steps',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
                  MultiField(
                    fieldType: 'Step',
                    fieldLength: 2,
                    items: List<String>.from(_initValues['steps']),
                    newItems: _newSteps,
                  ),
                  CustomDropdown(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'Affordability',
                        // helperText:
                        //     'Amount of money needed for the ingredients.',
                      ),
                      value: _affDropdownValue,
                      elevation: 16,
                      onChanged: (newValue) {
                        setState(() {
                          _affDropdownValue = newValue;
                        });
                      },
                      onSaved: (newValue) {
                        _editedRecipe =
                            _editedRecipe.copyWith(affordability: newValue);
                      },
                      items: Affordability.values
                          .map<DropdownMenuItem<Affordability>>(
                        (Affordability value) {
                          return DropdownMenuItem<Affordability>(
                            value: value,
                            child: Text(describeEnum(value)),
                          );
                        },
                      ).toList(),
                    ),
                    icon: Icons.attach_money,
                  ),
                  CustomDropdown(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'Complexity',
                        // helperText:
                        //     'Proficiency in cooking necessary to prepare this meal.',
                        // helperMaxLines: 2,
                      ),
                      value: _compDropdownValue,
                      elevation: 16,
                      onChanged: (newValue) {
                        setState(() {
                          _compDropdownValue = newValue;
                        });
                      },
                      onSaved: (newValue) {
                        _editedRecipe =
                            _editedRecipe.copyWith(complexity: newValue);
                      },
                      items: Complexity.values
                          .map<DropdownMenuItem<Complexity>>(
                              (Complexity value) {
                        return DropdownMenuItem<Complexity>(
                          value: value,
                          child: Text(describeEnum(value)),
                        );
                      }).toList(),
                    ),
                    icon: Icons.fitness_center,
                  ),
                  TextFormField(
                    initialValue: _initValues['duration'],
                    decoration: InputDecoration(
                      labelText: "Duration",
                      icon: Icon(
                        Icons.timer,
                        color: Theme.of(context).accentColor,
                        size: 20.0,
                      ),
                      helperText:
                          'How long it takes to prepare the meal in minutes.',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please provide a duration.';
                      if (int.tryParse(value) == null)
                        return 'Duration must contain only numbers.';
                      if (int.tryParse(value) <= 0)
                        return 'Duration must be larger than 0';
                      return null;
                    },
                    onSaved: (newValue) {
                      _editedRecipe = _editedRecipe.copyWith(
                          duration: int.tryParse(newValue));
                    },
                  ),
                  SizedBox(height: 20),
                  Divider(thickness: 2),
                  FormBuilder(
                    initialValue: {
                      'category_picker': _initValues['categories']
                    },
                    onChanged: (value) {
                      _categories = List<String>.from(value['category_picker']);
                    },
                    key: _fbKey,
                    child: FormBuilderFilterChip(
                      onSaved: (newValue) {
                        _categories = List<String>.from(newValue);
                      },
                      validators: [
                        (value) {
                          if (value.isEmpty || value == null)
                            return 'You must select at least one category!';
                          if (value.length > 3)
                            return 'The maximum number of categories is three!';

                          return null;
                        }
                      ],
                      selectedColor: Theme.of(context).accentColor,
                      attribute: 'category_picker',
                      decoration: InputDecoration(
                        labelText: 'Select up to three categories',
                      ),
                      options: Categories.items()
                          .map(
                            (cat) => FormBuilderFieldOption(
                              value: cat.id,
                              child: Text(cat.title),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ExpandableNotifier(
                    child: ScrollOnExpand(
                      child: ExpandablePanel(
                        iconColor: Colors.grey,
                        header: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Additional information',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        expanded: Column(
                          children: <Widget>[
                            CheckboxFormField(
                              context: context,
                              title: Text('Vegan'),
                              initialValue: _initValues['isVegan'],
                              onSaved: (newValue) {
                                _editedRecipe =
                                    _editedRecipe.copyWith(isVegan: newValue);
                              },
                            ),
                            CheckboxFormField(
                              context: context,
                              title: Text('Vegetarian'),
                              initialValue: _initValues['isVegetarian'],
                              onSaved: (newValue) {
                                _editedRecipe = _editedRecipe.copyWith(
                                    isVegetarian: newValue);
                              },
                            ),
                            CheckboxFormField(
                              context: context,
                              title: Text('Gluten Free'),
                              initialValue: _initValues['isGlutenFree'],
                              onSaved: (newValue) {
                                _editedRecipe = _editedRecipe.copyWith(
                                    isGlutenFree: newValue);
                              },
                            ),
                            CheckboxFormField(
                              context: context,
                              title: Text('Lactose Free'),
                              initialValue: _initValues['isLactoseFree'],
                              onSaved: (newValue) {
                                _editedRecipe = _editedRecipe.copyWith(
                                    isLactoseFree: newValue);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

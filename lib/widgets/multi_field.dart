import 'package:flutter/material.dart';

class MultiField extends StatefulWidget {
  final String fieldType;
  final int fieldLength;
  final List<String> items;
  final List<String> newItems;
  MultiField({this.fieldType, this.fieldLength, this.items, this.newItems});
  @override
  _MultiFieldState createState() => new _MultiFieldState();
}

class _MultiFieldState extends State<MultiField> {
  List<Widget> _childWidgets = [];

  @override
  void initState() {
    if (widget.items == null || widget.items.length <= 0) {
      _childWidgets.insert(
        0,
        MultiFieldChild(
          fieldName: 'Add ${widget.fieldType}',
          fieldLength: widget.fieldLength,
          newItems: widget.newItems,
          key: ValueKey(''),
        ),
      );
    } else {
      widget.items.forEach(
        (element) {
          _childWidgets.add(
            MultiFieldChild(
              fieldName: 'Add ${widget.fieldType}',
              fieldLength: widget.fieldLength,
              initValue: element,
              newItems: widget.newItems,
              key: ValueKey(element),
            ),
          );
        },
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ...List.generate(
          _childWidgets.length,
          (i) {
            return Container(
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _childWidgets[i],
                  if (i == 0 || i < _childWidgets.length - 1)
                    SizedBox(
                      width: 50,
                    ),
                  if (i == _childWidgets.length - 1 && i != 0)
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            print(i);
                            int index = i;
                            var child = _childWidgets[index] as MultiFieldChild;
                            print(child.initValue);
                            _childWidgets.removeAt(i);
                          },
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
        FlatButton.icon(
          onPressed: () {
            setState(
              () {
                _childWidgets.add(
                  MultiFieldChild(
                    fieldName: 'Add ${widget.fieldType}',
                    fieldLength: widget.fieldLength,
                    newItems: widget.newItems,
                  ),
                );
              },
            );
          },
          label: Text('Add ${widget.fieldType}'),
          icon: Icon(
            Icons.add,
            color: Theme.of(context).accentColor,
          ),
        )
      ],
    );
  }
}

class MultiFieldChild extends StatefulWidget {
  final Key key;
  final String fieldName;
  final int fieldLength;
  final String initValue;
  final List<String> newItems;

  MultiFieldChild({
    this.key,
    this.fieldName = '',
    this.fieldLength = 1,
    this.initValue = '',
    this.newItems,
  }) : super(key: key);

  @override
  _MultiFieldChildState createState() => _MultiFieldChildState();
}

class _MultiFieldChildState extends State<MultiFieldChild> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 35),
        child: TextFormField(
          textCapitalization: TextCapitalization.sentences,
          validator: (value) {
            if (value.isEmpty) return 'Please provide a value!';
            if (value.length < 2)
              return 'Ingredient name must contain at least 3 characters!';
            if (RegExp(r'/[$-/:-?{-~!"^_`\[\]]/').hasMatch(value))
              return 'An ingredient cannot contain any symbols!';
            return null;
          },
          onSaved: (newValue) {
            // print(newValue);
            // print(widget.newItems);
            widget.newItems.add(newValue);
          },
          textInputAction: TextInputAction.done,
          initialValue: widget.initValue,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            // icon: Icon(
            //   Icons.phone,
            //   color: Colors.black,
            //   size: 20.0,
            // ),
            labelText: widget.fieldName,
            // fillColor: Colors.grey[200],
          ),
          maxLines: widget.fieldLength,
        ),
      ),
    );
  }
}

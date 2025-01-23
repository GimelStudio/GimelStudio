import 'package:gimelstudio/models/node_base.dart';

// TODO: min and max values for integer/double

/// Base class for all properties.
///
/// A Property is the representation of a single point of
/// data that can changed either be evaluation of an input
/// or by the change of the value directly by the user.
class Property<T> {
  Property({
    required this.id,
    required this.idname,
    required this.label,
    required this.dataType,
    required this.value,
    required this.isExposed,
  });

  /// A unique id.
  String id;

  /// The string by which this property will be referenced.
  /// This should be unique per node type.
  final String idname;

  /// The displayed label for this property.
  String label;

  /// The data type of this property.
  final T dataType;

  /// The current value of the property, which is
  /// used if ``connection`` is null.
  T value;

  /// Whether this property is exposed in the node graph.
  bool isExposed;

  /// The connected node to evaluate the value from.
  /// If this is null, then value is used during evaluation.
  /// (Node object, name of the connected node's Output)
  // TODO: for the purposes of converting to json and back, Node should be the id of the node.
  (Node, String)? connection;

  void setValue(T newValue) {
    value = newValue;
  }

  void setConnection((Node, String) newConnection) {
    connection = newConnection;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idname': idname,
      'label': label,
      'dataType': dataType.toString(), // TODO
      'value': value,
      'isExposed': isExposed,
      'connection': connection,
    };
  }

  Property.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        idname = json['idname'] as String,
        label = json['label'] as String,
        dataType = json['dataType'], // TODO
        value = json['value'],
        isExposed = json['isExposed'] as bool,
        connection = json['connection']; // TODO

  @override
  String toString() {
    return 'Property{id: $id, idname: $idname, label: $label, dataType: $dataType, value: $value, isExposed: $isExposed, connection: $connection}';
  }
}

/// For integer values.
class IntegerProperty<int> extends Property {
  IntegerProperty({
    required super.id,
    required super.idname,
    required super.label,
    required super.dataType,
    required super.value,
    required super.isExposed,
  }) : assert(value is int);

  factory IntegerProperty.clone(Property source, String id) {
    return IntegerProperty<int>(
      id: id,
      idname: source.idname,
      label: source.label,
      dataType: source.dataType,
      value: source.value,
      isExposed: source.isExposed,
    );
  }
}

/// For double values.
class DoubleProperty<double> extends Property {
  DoubleProperty({
    required super.id,
    required super.idname,
    required super.label,
    required super.dataType,
    required super.value,
    required super.isExposed,
  }) : assert(value is double);

  factory DoubleProperty.clone(Property source, String id) {
    return DoubleProperty<double>(
      id: id,
      idname: source.idname,
      label: source.label,
      dataType: source.dataType,
      value: source.value,
      isExposed: source.isExposed,
    );
  }
}

/// For double values.
class PhotoProperty<Photo> extends Property {
  PhotoProperty({
    required super.id,
    required super.idname,
    required super.label,
    required super.dataType,
    required super.value,
    required super.isExposed,
  }) : assert(value is Photo);

  factory PhotoProperty.clone(Property source, String id) {
    return PhotoProperty<Photo>(
      id: id,
      idname: source.idname,
      label: source.label,
      dataType: source.dataType,
      value: source.value,
      isExposed: source.isExposed,
    );
  }
}

// For CanvasItem values.
class CanvasItemProperty<CanvasItem> extends Property {
  CanvasItemProperty({
    required super.id,
    required super.idname,
    required super.label,
    required super.dataType,
    required super.value,
    required super.isExposed,
  }) : assert(value is CanvasItem);

  factory CanvasItemProperty.clone(Property source, String id) {
    return CanvasItemProperty<CanvasItem>(
      id: id,
      idname: source.idname,
      label: source.label,
      dataType: source.dataType,
      value: source.value,
      isExposed: source.isExposed,
    );
  }
}

// For CanvasItemFill values.
class CanvasItemFillProperty<CanvasItemFill> extends Property {
  CanvasItemFillProperty({
    required super.id,
    required super.idname,
    required super.label,
    required super.dataType,
    required super.value,
    required super.isExposed,
  }) : assert(value is CanvasItemFill);

  factory CanvasItemFillProperty.clone(Property source, String id) {
    return CanvasItemFillProperty<CanvasItemFill>(
      id: id,
      idname: source.idname,
      label: source.label,
      dataType: source.dataType,
      value: source.value,
      isExposed: source.isExposed,
    );
  }
}

// For CanvasItemBorder values.
class CanvasItemBorderProperty<CanvasItemBorder> extends Property {
  CanvasItemBorderProperty({
    required super.id,
    required super.idname,
    required super.label,
    required super.dataType,
    required super.value,
    required super.isExposed,
  }) : assert(value is CanvasItemBorder);

  factory CanvasItemBorderProperty.clone(Property source, String id) {
    return CanvasItemBorderProperty<CanvasItemBorder>(
      id: id,
      idname: source.idname,
      label: source.label,
      dataType: source.dataType,
      value: source.value,
      isExposed: source.isExposed,
    );
  }
}

// For CanvasItemBorder values.
class CanvasItemBorderRadiusProperty<CanvasItemBorderRadius> extends Property {
  CanvasItemBorderRadiusProperty({
    required super.id,
    required super.idname,
    required super.label,
    required super.dataType,
    required super.value,
    required super.isExposed,
  }) : assert(value is CanvasItemBorderRadius);

  factory CanvasItemBorderRadiusProperty.clone(Property source, String id) {
    return CanvasItemBorderRadiusProperty<CanvasItemBorderRadius>(
      id: id,
      idname: source.idname,
      label: source.label,
      dataType: source.dataType,
      value: source.value,
      isExposed: source.isExposed,
    );
  }
}

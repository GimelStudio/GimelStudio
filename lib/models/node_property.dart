import 'package:gimelstudio/models/node_base.dart';

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
  /// (NodeBase object, name of the connected node's Output)
  // TODO: for the purposes of converting to json and back, NodeBase should be the id of the node.
  (NodeBase, String)? connection;

  void setValue(T newValue) {
    value = newValue;
  }

  void setConnection((NodeBase, String) newConnection) {
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

/// Integer input for integer values.
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

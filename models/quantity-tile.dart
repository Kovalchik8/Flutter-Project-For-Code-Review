class QuantityTile {
  num count;
  String name;
  QuantityTile(this.count, this.name);

  Map toJson() => {
        'name': name,
        'count': count,
      };

  factory QuantityTile.fromJson(dynamic json) {
    return QuantityTile(json['count'] as num, json['name'] as String);
  }

  @override
  String toString() {
    return '{ ${this.name}, ${this.count} }';
  }
}

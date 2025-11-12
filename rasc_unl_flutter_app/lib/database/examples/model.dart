import 'package:drift/drift.dart';

/// Tabla para items del carrito de compras local
@DataClassName('exampleModel')
class ExampleDriftModel extends Table {
  TextColumn get name => text()(); // Referencia al producto

  @override
  Set<Column> get primaryKey => {name};

  // @override
  // List<String> get customConstraints => [
  //   'CREATE INDEX IF NOT EXISTS idx_cart_item_product_code ON cart_item_drift_model(productCode)',
  // ];
}

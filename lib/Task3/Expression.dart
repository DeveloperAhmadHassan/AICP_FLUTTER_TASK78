class Expression {
  final int id;
  final String expression;
  final String result;
  final String resultDatatype;

  const Expression({
    required this.id,
    required this.expression,
    required this.result,
    required this.resultDatatype,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'expression': expression,
      'result': result,
      'datatype': resultDatatype
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Expression{id: $id, expression: $expression, result: $result, datatype: $resultDatatype}';
  }
}
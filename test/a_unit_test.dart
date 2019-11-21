import 'package:test/test.dart';
import 'package:modules_with_unused_imports/entrypoint_a.dart';
import 'package:modules_with_unused_imports/entrypoint_b.dart';

void main() {
  group('A group of tests', () {
    test('Class A test', () {
      var a = ClassA();
      expect(a.isAwesome, isTrue);
    });

    test('Class B Test', () {
      var b = ClassB();
      expect(b.isAwesome, isTrue);
    });
  });
}

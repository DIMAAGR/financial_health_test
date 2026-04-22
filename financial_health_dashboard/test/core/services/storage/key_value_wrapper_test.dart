import 'package:financial_health_dashboard/src/core/services/storage/key_value_wrapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InMemoryKeyValueWrapper', () {
    test('setString/getString/remove segue contrato do wrapper', () async {
      final wrapper = InMemoryKeyValueWrapper();

      final didSet = await wrapper.setString('k', 'v');
      final value = wrapper.getString('k');
      final didRemove = await wrapper.remove('k');
      final removedValue = wrapper.getString('k');

      expect(didSet, isTrue);
      expect(value, 'v');
      expect(didRemove, isTrue);
      expect(removedValue, isNull);
    });

    test('pode iniciar com valores iniciais', () async {
      final wrapper = InMemoryKeyValueWrapper(initialValues: {'a': '1'});

      expect(wrapper.getString('a'), '1');
      final removed = await wrapper.remove('a');
      expect(removed, isTrue);
      expect(wrapper.getString('a'), isNull);
    });
  });
}

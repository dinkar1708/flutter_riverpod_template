import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod_template/feature/counter/providers/counter_provider.dart';

void main() {
  group('Counter Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial value should be 0', () {
      final counter = container.read(counterProvider);
      expect(counter, equals(0));
    });

    test('increment should increase counter by 1', () {
      final notifier = container.read(counterProvider.notifier);

      notifier.increment();
      expect(container.read(counterProvider), equals(1));

      notifier.increment();
      expect(container.read(counterProvider), equals(2));

      notifier.increment();
      expect(container.read(counterProvider), equals(3));
    });

    test('decrement should decrease counter by 1', () {
      final notifier = container.read(counterProvider.notifier);

      // Set initial value
      notifier.setValue(5);
      expect(container.read(counterProvider), equals(5));

      notifier.decrement();
      expect(container.read(counterProvider), equals(4));

      notifier.decrement();
      expect(container.read(counterProvider), equals(3));
    });

    test('decrement should not go below 0', () {
      final notifier = container.read(counterProvider.notifier);

      expect(container.read(counterProvider), equals(0));

      notifier.decrement();
      expect(container.read(counterProvider), equals(0));

      notifier.decrement();
      expect(container.read(counterProvider), equals(0));
    });

    test('reset should set counter to 0', () {
      final notifier = container.read(counterProvider.notifier);

      notifier.increment();
      notifier.increment();
      notifier.increment();
      expect(container.read(counterProvider), equals(3));

      notifier.reset();
      expect(container.read(counterProvider), equals(0));
    });

    test('setValue should set counter to specific value', () {
      final notifier = container.read(counterProvider.notifier);

      notifier.setValue(42);
      expect(container.read(counterProvider), equals(42));

      notifier.setValue(100);
      expect(container.read(counterProvider), equals(100));

      notifier.setValue(0);
      expect(container.read(counterProvider), equals(0));
    });

    test('multiple operations should work correctly', () {
      final notifier = container.read(counterProvider.notifier);

      notifier.setValue(10);
      expect(container.read(counterProvider), equals(10));

      notifier.increment();
      expect(container.read(counterProvider), equals(11));

      notifier.decrement();
      expect(container.read(counterProvider), equals(10));

      notifier.reset();
      expect(container.read(counterProvider), equals(0));
    });

    test('negative values should be allowed with setValue', () {
      final notifier = container.read(counterProvider.notifier);

      notifier.setValue(-5);
      expect(container.read(counterProvider), equals(-5));

      notifier.increment();
      expect(container.read(counterProvider), equals(-4));
    });

    test('setValue with negative value then decrement should not prevent decrement', () {
      final notifier = container.read(counterProvider.notifier);

      notifier.setValue(-1);
      expect(container.read(counterProvider), equals(-1));

      // Decrement should not work because current state is < 0
      notifier.decrement();
      expect(container.read(counterProvider), equals(-1));
    });
  });

  group('Counter Provider State Management', () {
    test('should create independent instances for different containers', () {
      final container1 = ProviderContainer();
      final container2 = ProviderContainer();

      container1.read(counterProvider.notifier).setValue(5);
      container2.read(counterProvider.notifier).setValue(10);

      expect(container1.read(counterProvider), equals(5));
      expect(container2.read(counterProvider), equals(10));

      container1.dispose();
      container2.dispose();
    });

    test('should reset state when container is disposed and recreated', () {
      var container = ProviderContainer();

      container.read(counterProvider.notifier).setValue(42);
      expect(container.read(counterProvider), equals(42));

      container.dispose();

      // Create new container
      container = ProviderContainer();
      expect(container.read(counterProvider), equals(0));

      container.dispose();
    });
  });
}

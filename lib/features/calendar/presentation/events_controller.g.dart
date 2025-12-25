// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventsControllerHash() => r'07a2fd81a353a2c9edded71393086a1dc408fa67';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$EventsController
    extends BuildlessAutoDisposeAsyncNotifier<List<CalendarEvent>> {
  late final String groupId;

  FutureOr<List<CalendarEvent>> build(
    String groupId,
  );
}

/// See also [EventsController].
@ProviderFor(EventsController)
const eventsControllerProvider = EventsControllerFamily();

/// See also [EventsController].
class EventsControllerFamily extends Family<AsyncValue<List<CalendarEvent>>> {
  /// See also [EventsController].
  const EventsControllerFamily();

  /// See also [EventsController].
  EventsControllerProvider call(
    String groupId,
  ) {
    return EventsControllerProvider(
      groupId,
    );
  }

  @override
  EventsControllerProvider getProviderOverride(
    covariant EventsControllerProvider provider,
  ) {
    return call(
      provider.groupId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'eventsControllerProvider';
}

/// See also [EventsController].
class EventsControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    EventsController, List<CalendarEvent>> {
  /// See also [EventsController].
  EventsControllerProvider(
    String groupId,
  ) : this._internal(
          () => EventsController()..groupId = groupId,
          from: eventsControllerProvider,
          name: r'eventsControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventsControllerHash,
          dependencies: EventsControllerFamily._dependencies,
          allTransitiveDependencies:
              EventsControllerFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  EventsControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
  }) : super.internal();

  final String groupId;

  @override
  FutureOr<List<CalendarEvent>> runNotifierBuild(
    covariant EventsController notifier,
  ) {
    return notifier.build(
      groupId,
    );
  }

  @override
  Override overrideWith(EventsController Function() create) {
    return ProviderOverride(
      origin: this,
      override: EventsControllerProvider._internal(
        () => create()..groupId = groupId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<EventsController, List<CalendarEvent>>
      createElement() {
    return _EventsControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventsControllerProvider && other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EventsControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<CalendarEvent>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _EventsControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<EventsController,
        List<CalendarEvent>> with EventsControllerRef {
  _EventsControllerProviderElement(super.provider);

  @override
  String get groupId => (origin as EventsControllerProvider).groupId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

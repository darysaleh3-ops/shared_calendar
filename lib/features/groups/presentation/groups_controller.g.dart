// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groups_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$groupDetailsHash() => r'220a1f871de58efccef07b48c73e826ced337d7b';

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

/// See also [groupDetails].
@ProviderFor(groupDetails)
const groupDetailsProvider = GroupDetailsFamily();

/// See also [groupDetails].
class GroupDetailsFamily extends Family<AsyncValue<Group?>> {
  /// See also [groupDetails].
  const GroupDetailsFamily();

  /// See also [groupDetails].
  GroupDetailsProvider call(
    String groupId,
  ) {
    return GroupDetailsProvider(
      groupId,
    );
  }

  @override
  GroupDetailsProvider getProviderOverride(
    covariant GroupDetailsProvider provider,
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
  String? get name => r'groupDetailsProvider';
}

/// See also [groupDetails].
class GroupDetailsProvider extends AutoDisposeFutureProvider<Group?> {
  /// See also [groupDetails].
  GroupDetailsProvider(
    String groupId,
  ) : this._internal(
          (ref) => groupDetails(
            ref as GroupDetailsRef,
            groupId,
          ),
          from: groupDetailsProvider,
          name: r'groupDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$groupDetailsHash,
          dependencies: GroupDetailsFamily._dependencies,
          allTransitiveDependencies:
              GroupDetailsFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  GroupDetailsProvider._internal(
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
  Override overrideWith(
    FutureOr<Group?> Function(GroupDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GroupDetailsProvider._internal(
        (ref) => create(ref as GroupDetailsRef),
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
  AutoDisposeFutureProviderElement<Group?> createElement() {
    return _GroupDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupDetailsProvider && other.groupId == groupId;
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
mixin GroupDetailsRef on AutoDisposeFutureProviderRef<Group?> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _GroupDetailsProviderElement
    extends AutoDisposeFutureProviderElement<Group?> with GroupDetailsRef {
  _GroupDetailsProviderElement(super.provider);

  @override
  String get groupId => (origin as GroupDetailsProvider).groupId;
}

String _$availableUsersHash() => r'2ec1c509e496a4bf10fe434a93bf6ad3900199cd';

/// See also [availableUsers].
@ProviderFor(availableUsers)
final availableUsersProvider =
    AutoDisposeFutureProvider<List<AuthUser>>.internal(
  availableUsers,
  name: r'availableUsersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableUsersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableUsersRef = AutoDisposeFutureProviderRef<List<AuthUser>>;
String _$groupMembersHash() => r'6038bd8dd350006151a8bf42522c9c6d1e87201a';

/// See also [groupMembers].
@ProviderFor(groupMembers)
const groupMembersProvider = GroupMembersFamily();

/// See also [groupMembers].
class GroupMembersFamily extends Family<AsyncValue<List<AuthUser>>> {
  /// See also [groupMembers].
  const GroupMembersFamily();

  /// See also [groupMembers].
  GroupMembersProvider call(
    String groupId,
  ) {
    return GroupMembersProvider(
      groupId,
    );
  }

  @override
  GroupMembersProvider getProviderOverride(
    covariant GroupMembersProvider provider,
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
  String? get name => r'groupMembersProvider';
}

/// See also [groupMembers].
class GroupMembersProvider extends AutoDisposeFutureProvider<List<AuthUser>> {
  /// See also [groupMembers].
  GroupMembersProvider(
    String groupId,
  ) : this._internal(
          (ref) => groupMembers(
            ref as GroupMembersRef,
            groupId,
          ),
          from: groupMembersProvider,
          name: r'groupMembersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$groupMembersHash,
          dependencies: GroupMembersFamily._dependencies,
          allTransitiveDependencies:
              GroupMembersFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  GroupMembersProvider._internal(
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
  Override overrideWith(
    FutureOr<List<AuthUser>> Function(GroupMembersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GroupMembersProvider._internal(
        (ref) => create(ref as GroupMembersRef),
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
  AutoDisposeFutureProviderElement<List<AuthUser>> createElement() {
    return _GroupMembersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupMembersProvider && other.groupId == groupId;
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
mixin GroupMembersRef on AutoDisposeFutureProviderRef<List<AuthUser>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _GroupMembersProviderElement
    extends AutoDisposeFutureProviderElement<List<AuthUser>>
    with GroupMembersRef {
  _GroupMembersProviderElement(super.provider);

  @override
  String get groupId => (origin as GroupMembersProvider).groupId;
}

String _$groupsControllerHash() => r'd539e396f96fcad1e57e5427fafb6b968ea194fe';

/// See also [GroupsController].
@ProviderFor(GroupsController)
final groupsControllerProvider =
    AutoDisposeAsyncNotifierProvider<GroupsController, List<Group>>.internal(
  GroupsController.new,
  name: r'groupsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$groupsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GroupsController = AutoDisposeAsyncNotifier<List<Group>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

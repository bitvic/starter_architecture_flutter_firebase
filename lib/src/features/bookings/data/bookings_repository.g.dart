// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookings_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookingsRepositoryHash() => r'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0';

/// See also [bookingsRepository].
@ProviderFor(bookingsRepository)
final bookingsRepositoryProvider = Provider<BookingsRepository>.internal(
  bookingsRepository,
  name: r'bookingsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bookingsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BookingsRepositoryRef = ProviderRef<BookingsRepository>;
String _$userBookingsHash() => r'b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1';

/// See also [userBookings].
@ProviderFor(userBookings)
final userBookingsProvider =
    AutoDisposeStreamProviderFamily<List<Booking>, String>.internal(
  userBookings,
  name: r'userBookingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userBookingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserBookingsRef = AutoDisposeStreamProviderRef<List<Booking>>;

/// See also [userBookings].
class UserBookingsFamily extends Family<AsyncValue<List<Booking>>> {
  /// See also [userBookings].
  const UserBookingsFamily();

  /// See also [userBookings].
  UserBookingsProvider call(
    String userId,
  ) {
    return UserBookingsProvider(
      userId,
    );
  }

  @override
  UserBookingsProvider getProviderOverride(
    covariant UserBookingsProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'userBookingsProvider';
}

/// See also [userBookings].
class UserBookingsProvider
    extends AutoDisposeStreamProvider<List<Booking>> {
  /// See also [userBookings].
  UserBookingsProvider(
    String userId,
  ) : this._internal(
          (ref) => userBookings(
            ref as UserBookingsRef,
            userId,
          ),
          from: userBookingsProvider,
          name: r'userBookingsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userBookingsHash,
          dependencies: UserBookingsFamily._dependencies,
          allTransitiveDependencies:
              UserBookingsFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserBookingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Stream<List<Booking>> Function(UserBookingsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserBookingsProvider._internal(
        (ref) => create(ref as UserBookingsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Booking>> createElement() {
    return _UserBookingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserBookingsProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserBookingsRef on AutoDisposeStreamProviderRef<List<Booking>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserBookingsProviderElement
    extends AutoDisposeStreamProviderElement<List<Booking>>
    with UserBookingsRef {
  _UserBookingsProviderElement(super.provider);

  @override
  String get userId => (origin as UserBookingsProvider).userId;
}

String _$activeBookingsHash() => r'c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2';

/// See also [activeBookings].
@ProviderFor(activeBookings)
final activeBookingsProvider =
    AutoDisposeStreamProviderFamily<List<Booking>, String>.internal(
  activeBookings,
  name: r'activeBookingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeBookingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveBookingsRef = AutoDisposeStreamProviderRef<List<Booking>>;

/// See also [activeBookings].
class ActiveBookingsFamily extends Family<AsyncValue<List<Booking>>> {
  /// See also [activeBookings].
  const ActiveBookingsFamily();

  /// See also [activeBookings].
  ActiveBookingsProvider call(
    String userId,
  ) {
    return ActiveBookingsProvider(
      userId,
    );
  }

  @override
  ActiveBookingsProvider getProviderOverride(
    covariant ActiveBookingsProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'activeBookingsProvider';
}

/// See also [activeBookings].
class ActiveBookingsProvider
    extends AutoDisposeStreamProvider<List<Booking>> {
  /// See also [activeBookings].
  ActiveBookingsProvider(
    String userId,
  ) : this._internal(
          (ref) => activeBookings(
            ref as ActiveBookingsRef,
            userId,
          ),
          from: activeBookingsProvider,
          name: r'activeBookingsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$activeBookingsHash,
          dependencies: ActiveBookingsFamily._dependencies,
          allTransitiveDependencies:
              ActiveBookingsFamily._allTransitiveDependencies,
          userId: userId,
        );

  ActiveBookingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Stream<List<Booking>> Function(ActiveBookingsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActiveBookingsProvider._internal(
        (ref) => create(ref as ActiveBookingsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Booking>> createElement() {
    return _ActiveBookingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveBookingsProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ActiveBookingsRef on AutoDisposeStreamProviderRef<List<Booking>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _ActiveBookingsProviderElement
    extends AutoDisposeStreamProviderElement<List<Booking>>
    with ActiveBookingsRef {
  _ActiveBookingsProviderElement(super.provider);

  @override
  String get userId => (origin as ActiveBookingsProvider).userId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

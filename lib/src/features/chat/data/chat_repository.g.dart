// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatRepositoryHash() => r'd1e2f3g4h5i6j7k8l9m0n1o2p3q4r5s6t7u8v9w0';

/// See also [chatRepository].
@ProviderFor(chatRepository)
final chatRepositoryProvider = Provider<ChatRepository>.internal(
  chatRepository,
  name: r'chatRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatRepositoryRef = ProviderRef<ChatRepository>;
String _$chatHash() => r'e2f3g4h5i6j7k8l9m0n1o2p3q4r5s6t7u8v9w0x1';

/// See also [chat].
@ProviderFor(chat)
final chatProvider = AutoDisposeStreamProviderFamily<Chat?, String>.internal(
  chat,
  name: r'chatProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatRef = AutoDisposeStreamProviderRef<Chat?>;

/// See also [chat].
class ChatFamily extends Family<AsyncValue<Chat?>> {
  /// See also [chat].
  const ChatFamily();

  /// See also [chat].
  ChatProvider call(
    String chatId,
  ) {
    return ChatProvider(
      chatId,
    );
  }

  @override
  ChatProvider getProviderOverride(
    covariant ChatProvider provider,
  ) {
    return call(
      provider.chatId,
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
  String? get name => r'chatProvider';
}

/// See also [chat].
class ChatProvider extends AutoDisposeStreamProvider<Chat?> {
  /// See also [chat].
  ChatProvider(
    String chatId,
  ) : this._internal(
          (ref) => chat(
            ref as ChatRef,
            chatId,
          ),
          from: chatProvider,
          name: r'chatProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$chatHash,
          dependencies: ChatFamily._dependencies,
          allTransitiveDependencies: ChatFamily._allTransitiveDependencies,
          chatId: chatId,
        );

  ChatProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chatId,
  }) : super.internal();

  final String chatId;

  @override
  Override overrideWith(
    Stream<Chat?> Function(ChatRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatProvider._internal(
        (ref) => create(ref as ChatRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chatId: chatId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Chat?> createElement() {
    return _ChatProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatProvider && other.chatId == chatId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chatId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChatRef on AutoDisposeStreamProviderRef<Chat?> {
  /// The parameter `chatId` of this provider.
  String get chatId;
}

class _ChatProviderElement extends AutoDisposeStreamProviderElement<Chat?>
    with ChatRef {
  _ChatProviderElement(super.provider);

  @override
  String get chatId => (origin as ChatProvider).chatId;
}

String _$chatMessagesHash() => r'f3g4h5i6j7k8l9m0n1o2p3q4r5s6t7u8v9w0x1y2';

/// See also [chatMessages].
@ProviderFor(chatMessages)
final chatMessagesProvider =
    AutoDisposeStreamProviderFamily<List<ChatMessage>, String>.internal(
  chatMessages,
  name: r'chatMessagesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatMessagesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatMessagesRef = AutoDisposeStreamProviderRef<List<ChatMessage>>;

/// See also [chatMessages].
class ChatMessagesFamily extends Family<AsyncValue<List<ChatMessage>>> {
  /// See also [chatMessages].
  const ChatMessagesFamily();

  /// See also [chatMessages].
  ChatMessagesProvider call(
    String chatId,
  ) {
    return ChatMessagesProvider(
      chatId,
    );
  }

  @override
  ChatMessagesProvider getProviderOverride(
    covariant ChatMessagesProvider provider,
  ) {
    return call(
      provider.chatId,
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
  String? get name => r'chatMessagesProvider';
}

/// See also [chatMessages].
class ChatMessagesProvider
    extends AutoDisposeStreamProvider<List<ChatMessage>> {
  /// See also [chatMessages].
  ChatMessagesProvider(
    String chatId,
  ) : this._internal(
          (ref) => chatMessages(
            ref as ChatMessagesRef,
            chatId,
          ),
          from: chatMessagesProvider,
          name: r'chatMessagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatMessagesHash,
          dependencies: ChatMessagesFamily._dependencies,
          allTransitiveDependencies:
              ChatMessagesFamily._allTransitiveDependencies,
          chatId: chatId,
        );

  ChatMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chatId,
  }) : super.internal();

  final String chatId;

  @override
  Override overrideWith(
    Stream<List<ChatMessage>> Function(ChatMessagesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatMessagesProvider._internal(
        (ref) => create(ref as ChatMessagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chatId: chatId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<ChatMessage>> createElement() {
    return _ChatMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatMessagesProvider && other.chatId == chatId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chatId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChatMessagesRef on AutoDisposeStreamProviderRef<List<ChatMessage>> {
  /// The parameter `chatId` of this provider.
  String get chatId;
}

class _ChatMessagesProviderElement
    extends AutoDisposeStreamProviderElement<List<ChatMessage>>
    with ChatMessagesRef {
  _ChatMessagesProviderElement(super.provider);

  @override
  String get chatId => (origin as ChatMessagesProvider).chatId;
}

String _$userChatsHash() => r'g4h5i6j7k8l9m0n1o2p3q4r5s6t7u8v9w0x1y2z3';

/// See also [userChats].
@ProviderFor(userChats)
final userChatsProvider =
    AutoDisposeStreamProviderFamily<List<Chat>, String>.internal(
  userChats,
  name: r'userChatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userChatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserChatsRef = AutoDisposeStreamProviderRef<List<Chat>>;

/// See also [userChats].
class UserChatsFamily extends Family<AsyncValue<List<Chat>>> {
  /// See also [userChats].
  const UserChatsFamily();

  /// See also [userChats].
  UserChatsProvider call(
    String userId,
  ) {
    return UserChatsProvider(
      userId,
    );
  }

  @override
  UserChatsProvider getProviderOverride(
    covariant UserChatsProvider provider,
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
  String? get name => r'userChatsProvider';
}

/// See also [userChats].
class UserChatsProvider extends AutoDisposeStreamProvider<List<Chat>> {
  /// See also [userChats].
  UserChatsProvider(
    String userId,
  ) : this._internal(
          (ref) => userChats(
            ref as UserChatsRef,
            userId,
          ),
          from: userChatsProvider,
          name: r'userChatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userChatsHash,
          dependencies: UserChatsFamily._dependencies,
          allTransitiveDependencies: UserChatsFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserChatsProvider._internal(
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
    Stream<List<Chat>> Function(UserChatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserChatsProvider._internal(
        (ref) => create(ref as UserChatsRef),
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
  AutoDisposeStreamProviderElement<List<Chat>> createElement() {
    return _UserChatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserChatsProvider && other.userId == userId;
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
mixin UserChatsRef on AutoDisposeStreamProviderRef<List<Chat>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserChatsProviderElement
    extends AutoDisposeStreamProviderElement<List<Chat>> with UserChatsRef {
  _UserChatsProviderElement(super.provider);

  @override
  String get userId => (origin as UserChatsProvider).userId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

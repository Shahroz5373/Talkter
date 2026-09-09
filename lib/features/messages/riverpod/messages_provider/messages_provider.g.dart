// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MessagesProvider)
final messagesProviderProvider = MessagesProviderFamily._();

final class MessagesProviderProvider
    extends
        $AsyncNotifierProvider<MessagesProvider, List<Map<String, dynamic>>> {
  MessagesProviderProvider._({
    required MessagesProviderFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'messagesProviderProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$messagesProviderHash();

  @override
  String toString() {
    return r'messagesProviderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MessagesProvider create() => MessagesProvider();

  @override
  bool operator ==(Object other) {
    return other is MessagesProviderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$messagesProviderHash() => r'6b0afc2af29563c685e53318bb2daa304d8acd50';

final class MessagesProviderFamily extends $Family
    with
        $ClassFamilyOverride<
          MessagesProvider,
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          FutureOr<List<Map<String, dynamic>>>,
          String
        > {
  MessagesProviderFamily._()
    : super(
        retry: null,
        name: r'messagesProviderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  MessagesProviderProvider call({required String friendId}) =>
      MessagesProviderProvider._(argument: friendId, from: this);

  @override
  String toString() => r'messagesProviderProvider';
}

abstract class _$MessagesProvider
    extends $AsyncNotifier<List<Map<String, dynamic>>> {
  late final _$args = ref.$arg as String;
  String get friendId => _$args;

  FutureOr<List<Map<String, dynamic>>> build({required String friendId});
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<Map<String, dynamic>>>,
              List<Map<String, dynamic>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<Map<String, dynamic>>>,
                List<Map<String, dynamic>>
              >,
              AsyncValue<List<Map<String, dynamic>>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(friendId: _$args));
  }
}

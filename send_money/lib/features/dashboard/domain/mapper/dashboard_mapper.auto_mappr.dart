// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// AutoMapprGenerator
// **************************************************************************

// ignore_for_file: type=lint, unnecessary_cast, unused_local_variable

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_mappr_annotation/auto_mappr_annotation.dart' as _i1;
import 'package:send_money/features/dashboard/data/contracts/transaction_contract.dart'
    as _i2;
import 'package:send_money/features/dashboard/data/contracts/wallet_response_contract.dart'
    as _i4;
import 'package:send_money/features/dashboard/domain/entities/transaction_entity.dart'
    as _i3;
import 'package:send_money/features/dashboard/domain/entities/wallet_entity.dart'
    as _i5;

/// {@template package:send_money/features/dashboard/domain/mapper/dashboard_mapper.dart}
/// Available mappings:
/// - `TransactionContract` → `TransactionEntity`.
/// - `WalletResponseContract` → `WalletEntity`.
/// {@endtemplate}
class $DashboardMapper implements _i1.AutoMapprInterface {
  const $DashboardMapper();

  Type _typeOf<T>() => T;

  List<_i1.AutoMapprInterface> get _delegates => const [];

  /// {@macro AutoMapprInterface:canConvert}
  /// {@macro package:send_money/features/dashboard/domain/mapper/dashboard_mapper.dart}
  @override
  bool canConvert<SOURCE, TARGET>({bool recursive = true}) {
    final sourceTypeOf = _typeOf<SOURCE>();
    final targetTypeOf = _typeOf<TARGET>();
    if ((sourceTypeOf == _typeOf<_i2.TransactionContract>() ||
            sourceTypeOf == _typeOf<_i2.TransactionContract?>()) &&
        (targetTypeOf == _typeOf<_i3.TransactionEntity>() ||
            targetTypeOf == _typeOf<_i3.TransactionEntity?>())) {
      return true;
    }
    if ((sourceTypeOf == _typeOf<_i4.WalletResponseContract>() ||
            sourceTypeOf == _typeOf<_i4.WalletResponseContract?>()) &&
        (targetTypeOf == _typeOf<_i5.WalletEntity>() ||
            targetTypeOf == _typeOf<_i5.WalletEntity?>())) {
      return true;
    }
    if (recursive) {
      for (final mappr in _delegates) {
        if (mappr.canConvert<SOURCE, TARGET>()) {
          return true;
        }
      }
    }
    return false;
  }

  /// {@macro AutoMapprInterface:convert}
  /// {@macro package:send_money/features/dashboard/domain/mapper/dashboard_mapper.dart}
  @override
  TARGET convert<SOURCE, TARGET>(SOURCE? model) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return _convert(model)!;
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.convert(model)!;
      }
    }

    throw Exception('No ${_typeOf<SOURCE>()} -> ${_typeOf<TARGET>()} mapping.');
  }

  /// {@macro AutoMapprInterface:tryConvert}
  /// {@macro package:send_money/features/dashboard/domain/mapper/dashboard_mapper.dart}
  @override
  TARGET? tryConvert<SOURCE, TARGET>(
    SOURCE? model, {
    void Function(Object error, StackTrace stackTrace, SOURCE? source)?
    onMappingError,
  }) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return _safeConvert(model, onMappingError: onMappingError);
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.tryConvert(model, onMappingError: onMappingError);
      }
    }

    return null;
  }

  /// {@macro AutoMapprInterface:convertIterable}
  /// {@macro package:send_money/features/dashboard/domain/mapper/dashboard_mapper.dart}
  @override
  Iterable<TARGET> convertIterable<SOURCE, TARGET>(Iterable<SOURCE?> model) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return model.map<TARGET>((item) => _convert(item)!);
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.convertIterable(model);
      }
    }

    throw Exception('No ${_typeOf<SOURCE>()} -> ${_typeOf<TARGET>()} mapping.');
  }

  /// For iterable items, converts from SOURCE to TARGET if such mapping is configured, into Iterable.
  ///
  /// When an item in the source iterable is null, uses `whenSourceIsNull` if defined or null
  ///
  /// {@macro package:send_money/features/dashboard/domain/mapper/dashboard_mapper.dart}
  @override
  Iterable<TARGET?> tryConvertIterable<SOURCE, TARGET>(
    Iterable<SOURCE?> model, {
    void Function(Object error, StackTrace stackTrace, SOURCE? source)?
    onMappingError,
  }) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return model.map<TARGET?>(
        (item) => _safeConvert(item, onMappingError: onMappingError),
      );
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.tryConvertIterable(model, onMappingError: onMappingError);
      }
    }

    throw Exception('No ${_typeOf<SOURCE>()} -> ${_typeOf<TARGET>()} mapping.');
  }

  /// {@macro AutoMapprInterface:convertList}
  /// {@macro package:send_money/features/dashboard/domain/mapper/dashboard_mapper.dart}
  @override
  List<TARGET> convertList<SOURCE, TARGET>(Iterable<SOURCE?> model) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return convertIterable<SOURCE, TARGET>(model).toList();
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.convertList(model);
      }
    }

    throw Exception('No ${_typeOf<SOURCE>()} -> ${_typeOf<TARGET>()} mapping.');
  }

  /// For iterable items, converts from SOURCE to TARGET if such mapping is configured, into List.
  ///
  /// When an item in the source iterable is null, uses `whenSourceIsNull` if defined or null
  ///
  /// {@macro package:send_money/features/dashboard/domain/mapper/dashboard_mapper.dart}
  @override
  List<TARGET?> tryConvertList<SOURCE, TARGET>(
    Iterable<SOURCE?> model, {
    void Function(Object error, StackTrace stackTrace, SOURCE? source)?
    onMappingError,
  }) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return tryConvertIterable<SOURCE, TARGET>(
        model,
        onMappingError: onMappingError,
      ).toList();
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.tryConvertList(model, onMappingError: onMappingError);
      }
    }

    throw Exception('No ${_typeOf<SOURCE>()} -> ${_typeOf<TARGET>()} mapping.');
  }

  /// {@macro AutoMapprInterface:convertSet}
  /// {@macro package:send_money/features/dashboard/domain/mapper/dashboard_mapper.dart}
  @override
  Set<TARGET> convertSet<SOURCE, TARGET>(Iterable<SOURCE?> model) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return convertIterable<SOURCE, TARGET>(model).toSet();
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.convertSet(model);
      }
    }

    throw Exception('No ${_typeOf<SOURCE>()} -> ${_typeOf<TARGET>()} mapping.');
  }

  /// For iterable items, converts from SOURCE to TARGET if such mapping is configured, into Set.
  ///
  /// When an item in the source iterable is null, uses `whenSourceIsNull` if defined or null
  ///
  /// {@macro package:send_money/features/dashboard/domain/mapper/dashboard_mapper.dart}
  @override
  Set<TARGET?> tryConvertSet<SOURCE, TARGET>(
    Iterable<SOURCE?> model, {
    void Function(Object error, StackTrace stackTrace, SOURCE? source)?
    onMappingError,
  }) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return tryConvertIterable<SOURCE, TARGET>(
        model,
        onMappingError: onMappingError,
      ).toSet();
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.tryConvertSet(model, onMappingError: onMappingError);
      }
    }

    throw Exception('No ${_typeOf<SOURCE>()} -> ${_typeOf<TARGET>()} mapping.');
  }

  TARGET? _convert<SOURCE, TARGET>(
    SOURCE? model, {
    bool canReturnNull = false,
  }) {
    final sourceTypeOf = _typeOf<SOURCE>();
    final targetTypeOf = _typeOf<TARGET>();
    if ((sourceTypeOf == _typeOf<_i2.TransactionContract>() ||
            sourceTypeOf == _typeOf<_i2.TransactionContract?>()) &&
        (targetTypeOf == _typeOf<_i3.TransactionEntity>() ||
            targetTypeOf == _typeOf<_i3.TransactionEntity?>())) {
      if (canReturnNull && model == null) {
        return null;
      }
      return (_map__i2$TransactionContract_To__i3$TransactionEntity(
            (model as _i2.TransactionContract?),
          )
          as TARGET);
    }
    if ((sourceTypeOf == _typeOf<_i4.WalletResponseContract>() ||
            sourceTypeOf == _typeOf<_i4.WalletResponseContract?>()) &&
        (targetTypeOf == _typeOf<_i5.WalletEntity>() ||
            targetTypeOf == _typeOf<_i5.WalletEntity?>())) {
      if (canReturnNull && model == null) {
        return null;
      }
      return (_map__i4$WalletResponseContract_To__i5$WalletEntity(
            (model as _i4.WalletResponseContract?),
          )
          as TARGET);
    }
    throw Exception('No ${model.runtimeType} -> $targetTypeOf mapping.');
  }

  TARGET? _safeConvert<SOURCE, TARGET>(
    SOURCE? model, {
    void Function(Object error, StackTrace stackTrace, SOURCE? source)?
    onMappingError,
  }) {
    if (!useSafeMapping<SOURCE, TARGET>()) {
      return _convert(model, canReturnNull: true);
    }
    try {
      return _convert(model, canReturnNull: true);
    } catch (e, s) {
      onMappingError?.call(e, s, model);
      return null;
    }
  }

  /// {@macro AutoMapprInterface:useSafeMapping}
  /// {@macro package:send_money/features/dashboard/domain/mapper/dashboard_mapper.dart}
  @override
  bool useSafeMapping<SOURCE, TARGET>() {
    return false;
  }

  _i3.TransactionEntity _map__i2$TransactionContract_To__i3$TransactionEntity(
    _i2.TransactionContract? input,
  ) {
    final model = input;
    if (model == null) {
      throw Exception(
        r'Mapping TransactionContract → TransactionEntity failed because TransactionContract was null, and no default value was provided. '
        r'Consider setting the whenSourceIsNull parameter on the MapType<TransactionContract, TransactionEntity> to handle null values during mapping.',
      );
    }
    return _i3.TransactionEntity(
      id: model.id,
      date: model.date,
      time: model.time,
      accountName: model.accountName,
      amount: model.amount,
      type: model.type,
    );
  }

  _i5.WalletEntity _map__i4$WalletResponseContract_To__i5$WalletEntity(
    _i4.WalletResponseContract? input,
  ) {
    final model = input;
    if (model == null) {
      throw Exception(
        r'Mapping WalletResponseContract → WalletEntity failed because WalletResponseContract was null, and no default value was provided. '
        r'Consider setting the whenSourceIsNull parameter on the MapType<WalletResponseContract, WalletEntity> to handle null values during mapping.',
      );
    }
    return _i5.WalletEntity(
      balance: model.balance,
      transactions: model.transactions
          .map<_i3.TransactionEntity>(
            (value) =>
                _map__i2$TransactionContract_To__i3$TransactionEntity(value),
          )
          .toList(),
    );
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transactions_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionsState {

 double get balance; double get income; double get expense; String get monthLabel; double get balanceChangePercent; List<TransactionData> get transactions; TransactionsViewStatus get status; String? get errorMessage; bool get canRetry;
/// Create a copy of TransactionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionsStateCopyWith<TransactionsState> get copyWith => _$TransactionsStateCopyWithImpl<TransactionsState>(this as TransactionsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionsState&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.monthLabel, monthLabel) || other.monthLabel == monthLabel)&&(identical(other.balanceChangePercent, balanceChangePercent) || other.balanceChangePercent == balanceChangePercent)&&const DeepCollectionEquality().equals(other.transactions, transactions)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.canRetry, canRetry) || other.canRetry == canRetry));
}


@override
int get hashCode => Object.hash(runtimeType,balance,income,expense,monthLabel,balanceChangePercent,const DeepCollectionEquality().hash(transactions),status,errorMessage,canRetry);

@override
String toString() {
  return 'TransactionsState(balance: $balance, income: $income, expense: $expense, monthLabel: $monthLabel, balanceChangePercent: $balanceChangePercent, transactions: $transactions, status: $status, errorMessage: $errorMessage, canRetry: $canRetry)';
}


}

/// @nodoc
abstract mixin class $TransactionsStateCopyWith<$Res>  {
  factory $TransactionsStateCopyWith(TransactionsState value, $Res Function(TransactionsState) _then) = _$TransactionsStateCopyWithImpl;
@useResult
$Res call({
 double balance, double income, double expense, String monthLabel, double balanceChangePercent, List<TransactionData> transactions, TransactionsViewStatus status, String? errorMessage, bool canRetry
});




}
/// @nodoc
class _$TransactionsStateCopyWithImpl<$Res>
    implements $TransactionsStateCopyWith<$Res> {
  _$TransactionsStateCopyWithImpl(this._self, this._then);

  final TransactionsState _self;
  final $Res Function(TransactionsState) _then;

/// Create a copy of TransactionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? balance = null,Object? income = null,Object? expense = null,Object? monthLabel = null,Object? balanceChangePercent = null,Object? transactions = null,Object? status = null,Object? errorMessage = freezed,Object? canRetry = null,}) {
  return _then(_self.copyWith(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as double,monthLabel: null == monthLabel ? _self.monthLabel : monthLabel // ignore: cast_nullable_to_non_nullable
as String,balanceChangePercent: null == balanceChangePercent ? _self.balanceChangePercent : balanceChangePercent // ignore: cast_nullable_to_non_nullable
as double,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<TransactionData>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransactionsViewStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,canRetry: null == canRetry ? _self.canRetry : canRetry // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionsState].
extension TransactionsStatePatterns on TransactionsState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionsState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionsState value)  $default,){
final _that = this;
switch (_that) {
case _TransactionsState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionsState value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionsState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double balance,  double income,  double expense,  String monthLabel,  double balanceChangePercent,  List<TransactionData> transactions,  TransactionsViewStatus status,  String? errorMessage,  bool canRetry)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionsState() when $default != null:
return $default(_that.balance,_that.income,_that.expense,_that.monthLabel,_that.balanceChangePercent,_that.transactions,_that.status,_that.errorMessage,_that.canRetry);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double balance,  double income,  double expense,  String monthLabel,  double balanceChangePercent,  List<TransactionData> transactions,  TransactionsViewStatus status,  String? errorMessage,  bool canRetry)  $default,) {final _that = this;
switch (_that) {
case _TransactionsState():
return $default(_that.balance,_that.income,_that.expense,_that.monthLabel,_that.balanceChangePercent,_that.transactions,_that.status,_that.errorMessage,_that.canRetry);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double balance,  double income,  double expense,  String monthLabel,  double balanceChangePercent,  List<TransactionData> transactions,  TransactionsViewStatus status,  String? errorMessage,  bool canRetry)?  $default,) {final _that = this;
switch (_that) {
case _TransactionsState() when $default != null:
return $default(_that.balance,_that.income,_that.expense,_that.monthLabel,_that.balanceChangePercent,_that.transactions,_that.status,_that.errorMessage,_that.canRetry);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionsState implements TransactionsState {
  const _TransactionsState({required this.balance, required this.income, required this.expense, required this.monthLabel, required this.balanceChangePercent, required final  List<TransactionData> transactions, required this.status, this.errorMessage, this.canRetry = false}): _transactions = transactions;


@override final  double balance;
@override final  double income;
@override final  double expense;
@override final  String monthLabel;
@override final  double balanceChangePercent;
 final  List<TransactionData> _transactions;
@override List<TransactionData> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}

@override final  TransactionsViewStatus status;
@override final  String? errorMessage;
@override@JsonKey() final  bool canRetry;

/// Create a copy of TransactionsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionsStateCopyWith<_TransactionsState> get copyWith => __$TransactionsStateCopyWithImpl<_TransactionsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionsState&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.monthLabel, monthLabel) || other.monthLabel == monthLabel)&&(identical(other.balanceChangePercent, balanceChangePercent) || other.balanceChangePercent == balanceChangePercent)&&const DeepCollectionEquality().equals(other._transactions, _transactions)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.canRetry, canRetry) || other.canRetry == canRetry));
}


@override
int get hashCode => Object.hash(runtimeType,balance,income,expense,monthLabel,balanceChangePercent,const DeepCollectionEquality().hash(_transactions),status,errorMessage,canRetry);

@override
String toString() {
  return 'TransactionsState(balance: $balance, income: $income, expense: $expense, monthLabel: $monthLabel, balanceChangePercent: $balanceChangePercent, transactions: $transactions, status: $status, errorMessage: $errorMessage, canRetry: $canRetry)';
}


}

/// @nodoc
abstract mixin class _$TransactionsStateCopyWith<$Res> implements $TransactionsStateCopyWith<$Res> {
  factory _$TransactionsStateCopyWith(_TransactionsState value, $Res Function(_TransactionsState) _then) = __$TransactionsStateCopyWithImpl;
@override @useResult
$Res call({
 double balance, double income, double expense, String monthLabel, double balanceChangePercent, List<TransactionData> transactions, TransactionsViewStatus status, String? errorMessage, bool canRetry
});




}
/// @nodoc
class __$TransactionsStateCopyWithImpl<$Res>
    implements _$TransactionsStateCopyWith<$Res> {
  __$TransactionsStateCopyWithImpl(this._self, this._then);

  final _TransactionsState _self;
  final $Res Function(_TransactionsState) _then;

/// Create a copy of TransactionsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? balance = null,Object? income = null,Object? expense = null,Object? monthLabel = null,Object? balanceChangePercent = null,Object? transactions = null,Object? status = null,Object? errorMessage = freezed,Object? canRetry = null,}) {
  return _then(_TransactionsState(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as double,monthLabel: null == monthLabel ? _self.monthLabel : monthLabel // ignore: cast_nullable_to_non_nullable
as String,balanceChangePercent: null == balanceChangePercent ? _self.balanceChangePercent : balanceChangePercent // ignore: cast_nullable_to_non_nullable
as double,transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<TransactionData>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransactionsViewStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,canRetry: null == canRetry ? _self.canRetry : canRetry // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

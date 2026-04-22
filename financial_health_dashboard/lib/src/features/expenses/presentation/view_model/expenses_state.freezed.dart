// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expenses_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExpensesState {

 double get totalExpense; String get monthLabel; double get expenseChangePercent; List<TransactionData> get transactions; List<CategoryBreakdownData> get categoryBreakdown; ExpensesViewStatus get status; String? get errorMessage; bool get canRetry; ExpensesEffect? get effect; int get effectVersion;
/// Create a copy of ExpensesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpensesStateCopyWith<ExpensesState> get copyWith => _$ExpensesStateCopyWithImpl<ExpensesState>(this as ExpensesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpensesState&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.monthLabel, monthLabel) || other.monthLabel == monthLabel)&&(identical(other.expenseChangePercent, expenseChangePercent) || other.expenseChangePercent == expenseChangePercent)&&const DeepCollectionEquality().equals(other.transactions, transactions)&&const DeepCollectionEquality().equals(other.categoryBreakdown, categoryBreakdown)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.canRetry, canRetry) || other.canRetry == canRetry)&&(identical(other.effect, effect) || other.effect == effect)&&(identical(other.effectVersion, effectVersion) || other.effectVersion == effectVersion));
}


@override
int get hashCode => Object.hash(runtimeType,totalExpense,monthLabel,expenseChangePercent,const DeepCollectionEquality().hash(transactions),const DeepCollectionEquality().hash(categoryBreakdown),status,errorMessage,canRetry,effect,effectVersion);

@override
String toString() {
  return 'ExpensesState(totalExpense: $totalExpense, monthLabel: $monthLabel, expenseChangePercent: $expenseChangePercent, transactions: $transactions, categoryBreakdown: $categoryBreakdown, status: $status, errorMessage: $errorMessage, canRetry: $canRetry, effect: $effect, effectVersion: $effectVersion)';
}


}

/// @nodoc
abstract mixin class $ExpensesStateCopyWith<$Res>  {
  factory $ExpensesStateCopyWith(ExpensesState value, $Res Function(ExpensesState) _then) = _$ExpensesStateCopyWithImpl;
@useResult
$Res call({
 double totalExpense, String monthLabel, double expenseChangePercent, List<TransactionData> transactions, List<CategoryBreakdownData> categoryBreakdown, ExpensesViewStatus status, String? errorMessage, bool canRetry, ExpensesEffect? effect, int effectVersion
});




}
/// @nodoc
class _$ExpensesStateCopyWithImpl<$Res>
    implements $ExpensesStateCopyWith<$Res> {
  _$ExpensesStateCopyWithImpl(this._self, this._then);

  final ExpensesState _self;
  final $Res Function(ExpensesState) _then;

/// Create a copy of ExpensesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalExpense = null,Object? monthLabel = null,Object? expenseChangePercent = null,Object? transactions = null,Object? categoryBreakdown = null,Object? status = null,Object? errorMessage = freezed,Object? canRetry = null,Object? effect = freezed,Object? effectVersion = null,}) {
  return _then(_self.copyWith(
totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as double,monthLabel: null == monthLabel ? _self.monthLabel : monthLabel // ignore: cast_nullable_to_non_nullable
as String,expenseChangePercent: null == expenseChangePercent ? _self.expenseChangePercent : expenseChangePercent // ignore: cast_nullable_to_non_nullable
as double,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<TransactionData>,categoryBreakdown: null == categoryBreakdown ? _self.categoryBreakdown : categoryBreakdown // ignore: cast_nullable_to_non_nullable
as List<CategoryBreakdownData>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExpensesViewStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,canRetry: null == canRetry ? _self.canRetry : canRetry // ignore: cast_nullable_to_non_nullable
as bool,effect: freezed == effect ? _self.effect : effect // ignore: cast_nullable_to_non_nullable
as ExpensesEffect?,effectVersion: null == effectVersion ? _self.effectVersion : effectVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpensesState].
extension ExpensesStatePatterns on ExpensesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpensesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpensesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpensesState value)  $default,){
final _that = this;
switch (_that) {
case _ExpensesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpensesState value)?  $default,){
final _that = this;
switch (_that) {
case _ExpensesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalExpense,  String monthLabel,  double expenseChangePercent,  List<TransactionData> transactions,  List<CategoryBreakdownData> categoryBreakdown,  ExpensesViewStatus status,  String? errorMessage,  bool canRetry,  ExpensesEffect? effect,  int effectVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpensesState() when $default != null:
return $default(_that.totalExpense,_that.monthLabel,_that.expenseChangePercent,_that.transactions,_that.categoryBreakdown,_that.status,_that.errorMessage,_that.canRetry,_that.effect,_that.effectVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalExpense,  String monthLabel,  double expenseChangePercent,  List<TransactionData> transactions,  List<CategoryBreakdownData> categoryBreakdown,  ExpensesViewStatus status,  String? errorMessage,  bool canRetry,  ExpensesEffect? effect,  int effectVersion)  $default,) {final _that = this;
switch (_that) {
case _ExpensesState():
return $default(_that.totalExpense,_that.monthLabel,_that.expenseChangePercent,_that.transactions,_that.categoryBreakdown,_that.status,_that.errorMessage,_that.canRetry,_that.effect,_that.effectVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalExpense,  String monthLabel,  double expenseChangePercent,  List<TransactionData> transactions,  List<CategoryBreakdownData> categoryBreakdown,  ExpensesViewStatus status,  String? errorMessage,  bool canRetry,  ExpensesEffect? effect,  int effectVersion)?  $default,) {final _that = this;
switch (_that) {
case _ExpensesState() when $default != null:
return $default(_that.totalExpense,_that.monthLabel,_that.expenseChangePercent,_that.transactions,_that.categoryBreakdown,_that.status,_that.errorMessage,_that.canRetry,_that.effect,_that.effectVersion);case _:
  return null;

}
}

}

/// @nodoc


class _ExpensesState implements ExpensesState {
  const _ExpensesState({required this.totalExpense, required this.monthLabel, required this.expenseChangePercent, required final  List<TransactionData> transactions, required final  List<CategoryBreakdownData> categoryBreakdown, required this.status, this.errorMessage, this.canRetry = false, this.effect, required this.effectVersion}): _transactions = transactions,_categoryBreakdown = categoryBreakdown;


@override final  double totalExpense;
@override final  String monthLabel;
@override final  double expenseChangePercent;
 final  List<TransactionData> _transactions;
@override List<TransactionData> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}

 final  List<CategoryBreakdownData> _categoryBreakdown;
@override List<CategoryBreakdownData> get categoryBreakdown {
  if (_categoryBreakdown is EqualUnmodifiableListView) return _categoryBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categoryBreakdown);
}

@override final  ExpensesViewStatus status;
@override final  String? errorMessage;
@override@JsonKey() final  bool canRetry;
@override final  ExpensesEffect? effect;
@override final  int effectVersion;

/// Create a copy of ExpensesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpensesStateCopyWith<_ExpensesState> get copyWith => __$ExpensesStateCopyWithImpl<_ExpensesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpensesState&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.monthLabel, monthLabel) || other.monthLabel == monthLabel)&&(identical(other.expenseChangePercent, expenseChangePercent) || other.expenseChangePercent == expenseChangePercent)&&const DeepCollectionEquality().equals(other._transactions, _transactions)&&const DeepCollectionEquality().equals(other._categoryBreakdown, _categoryBreakdown)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.canRetry, canRetry) || other.canRetry == canRetry)&&(identical(other.effect, effect) || other.effect == effect)&&(identical(other.effectVersion, effectVersion) || other.effectVersion == effectVersion));
}


@override
int get hashCode => Object.hash(runtimeType,totalExpense,monthLabel,expenseChangePercent,const DeepCollectionEquality().hash(_transactions),const DeepCollectionEquality().hash(_categoryBreakdown),status,errorMessage,canRetry,effect,effectVersion);

@override
String toString() {
  return 'ExpensesState(totalExpense: $totalExpense, monthLabel: $monthLabel, expenseChangePercent: $expenseChangePercent, transactions: $transactions, categoryBreakdown: $categoryBreakdown, status: $status, errorMessage: $errorMessage, canRetry: $canRetry, effect: $effect, effectVersion: $effectVersion)';
}


}

/// @nodoc
abstract mixin class _$ExpensesStateCopyWith<$Res> implements $ExpensesStateCopyWith<$Res> {
  factory _$ExpensesStateCopyWith(_ExpensesState value, $Res Function(_ExpensesState) _then) = __$ExpensesStateCopyWithImpl;
@override @useResult
$Res call({
 double totalExpense, String monthLabel, double expenseChangePercent, List<TransactionData> transactions, List<CategoryBreakdownData> categoryBreakdown, ExpensesViewStatus status, String? errorMessage, bool canRetry, ExpensesEffect? effect, int effectVersion
});




}
/// @nodoc
class __$ExpensesStateCopyWithImpl<$Res>
    implements _$ExpensesStateCopyWith<$Res> {
  __$ExpensesStateCopyWithImpl(this._self, this._then);

  final _ExpensesState _self;
  final $Res Function(_ExpensesState) _then;

/// Create a copy of ExpensesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalExpense = null,Object? monthLabel = null,Object? expenseChangePercent = null,Object? transactions = null,Object? categoryBreakdown = null,Object? status = null,Object? errorMessage = freezed,Object? canRetry = null,Object? effect = freezed,Object? effectVersion = null,}) {
  return _then(_ExpensesState(
totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as double,monthLabel: null == monthLabel ? _self.monthLabel : monthLabel // ignore: cast_nullable_to_non_nullable
as String,expenseChangePercent: null == expenseChangePercent ? _self.expenseChangePercent : expenseChangePercent // ignore: cast_nullable_to_non_nullable
as double,transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<TransactionData>,categoryBreakdown: null == categoryBreakdown ? _self._categoryBreakdown : categoryBreakdown // ignore: cast_nullable_to_non_nullable
as List<CategoryBreakdownData>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExpensesViewStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,canRetry: null == canRetry ? _self.canRetry : canRetry // ignore: cast_nullable_to_non_nullable
as bool,effect: freezed == effect ? _self.effect : effect // ignore: cast_nullable_to_non_nullable
as ExpensesEffect?,effectVersion: null == effectVersion ? _self.effectVersion : effectVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

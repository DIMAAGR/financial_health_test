// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'incomes_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IncomesState {

 double get totalIncome; String get monthLabel; double get incomeChangePercent; List<TransactionData> get transactions; List<CategoryBreakdownData> get categoryBreakdown; IncomesViewStatus get status; String? get errorMessage; bool get canRetry; IncomesEffect? get effect; int get effectVersion;
/// Create a copy of IncomesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IncomesStateCopyWith<IncomesState> get copyWith => _$IncomesStateCopyWithImpl<IncomesState>(this as IncomesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IncomesState&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.monthLabel, monthLabel) || other.monthLabel == monthLabel)&&(identical(other.incomeChangePercent, incomeChangePercent) || other.incomeChangePercent == incomeChangePercent)&&const DeepCollectionEquality().equals(other.transactions, transactions)&&const DeepCollectionEquality().equals(other.categoryBreakdown, categoryBreakdown)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.canRetry, canRetry) || other.canRetry == canRetry)&&(identical(other.effect, effect) || other.effect == effect)&&(identical(other.effectVersion, effectVersion) || other.effectVersion == effectVersion));
}


@override
int get hashCode => Object.hash(runtimeType,totalIncome,monthLabel,incomeChangePercent,const DeepCollectionEquality().hash(transactions),const DeepCollectionEquality().hash(categoryBreakdown),status,errorMessage,canRetry,effect,effectVersion);

@override
String toString() {
  return 'IncomesState(totalIncome: $totalIncome, monthLabel: $monthLabel, incomeChangePercent: $incomeChangePercent, transactions: $transactions, categoryBreakdown: $categoryBreakdown, status: $status, errorMessage: $errorMessage, canRetry: $canRetry, effect: $effect, effectVersion: $effectVersion)';
}


}

/// @nodoc
abstract mixin class $IncomesStateCopyWith<$Res>  {
  factory $IncomesStateCopyWith(IncomesState value, $Res Function(IncomesState) _then) = _$IncomesStateCopyWithImpl;
@useResult
$Res call({
 double totalIncome, String monthLabel, double incomeChangePercent, List<TransactionData> transactions, List<CategoryBreakdownData> categoryBreakdown, IncomesViewStatus status, String? errorMessage, bool canRetry, IncomesEffect? effect, int effectVersion
});




}
/// @nodoc
class _$IncomesStateCopyWithImpl<$Res>
    implements $IncomesStateCopyWith<$Res> {
  _$IncomesStateCopyWithImpl(this._self, this._then);

  final IncomesState _self;
  final $Res Function(IncomesState) _then;

/// Create a copy of IncomesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalIncome = null,Object? monthLabel = null,Object? incomeChangePercent = null,Object? transactions = null,Object? categoryBreakdown = null,Object? status = null,Object? errorMessage = freezed,Object? canRetry = null,Object? effect = freezed,Object? effectVersion = null,}) {
  return _then(_self.copyWith(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,monthLabel: null == monthLabel ? _self.monthLabel : monthLabel // ignore: cast_nullable_to_non_nullable
as String,incomeChangePercent: null == incomeChangePercent ? _self.incomeChangePercent : incomeChangePercent // ignore: cast_nullable_to_non_nullable
as double,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<TransactionData>,categoryBreakdown: null == categoryBreakdown ? _self.categoryBreakdown : categoryBreakdown // ignore: cast_nullable_to_non_nullable
as List<CategoryBreakdownData>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as IncomesViewStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,canRetry: null == canRetry ? _self.canRetry : canRetry // ignore: cast_nullable_to_non_nullable
as bool,effect: freezed == effect ? _self.effect : effect // ignore: cast_nullable_to_non_nullable
as IncomesEffect?,effectVersion: null == effectVersion ? _self.effectVersion : effectVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [IncomesState].
extension IncomesStatePatterns on IncomesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IncomesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IncomesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IncomesState value)  $default,){
final _that = this;
switch (_that) {
case _IncomesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IncomesState value)?  $default,){
final _that = this;
switch (_that) {
case _IncomesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalIncome,  String monthLabel,  double incomeChangePercent,  List<TransactionData> transactions,  List<CategoryBreakdownData> categoryBreakdown,  IncomesViewStatus status,  String? errorMessage,  bool canRetry,  IncomesEffect? effect,  int effectVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IncomesState() when $default != null:
return $default(_that.totalIncome,_that.monthLabel,_that.incomeChangePercent,_that.transactions,_that.categoryBreakdown,_that.status,_that.errorMessage,_that.canRetry,_that.effect,_that.effectVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalIncome,  String monthLabel,  double incomeChangePercent,  List<TransactionData> transactions,  List<CategoryBreakdownData> categoryBreakdown,  IncomesViewStatus status,  String? errorMessage,  bool canRetry,  IncomesEffect? effect,  int effectVersion)  $default,) {final _that = this;
switch (_that) {
case _IncomesState():
return $default(_that.totalIncome,_that.monthLabel,_that.incomeChangePercent,_that.transactions,_that.categoryBreakdown,_that.status,_that.errorMessage,_that.canRetry,_that.effect,_that.effectVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalIncome,  String monthLabel,  double incomeChangePercent,  List<TransactionData> transactions,  List<CategoryBreakdownData> categoryBreakdown,  IncomesViewStatus status,  String? errorMessage,  bool canRetry,  IncomesEffect? effect,  int effectVersion)?  $default,) {final _that = this;
switch (_that) {
case _IncomesState() when $default != null:
return $default(_that.totalIncome,_that.monthLabel,_that.incomeChangePercent,_that.transactions,_that.categoryBreakdown,_that.status,_that.errorMessage,_that.canRetry,_that.effect,_that.effectVersion);case _:
  return null;

}
}

}

/// @nodoc


class _IncomesState implements IncomesState {
  const _IncomesState({required this.totalIncome, required this.monthLabel, required this.incomeChangePercent, required final  List<TransactionData> transactions, required final  List<CategoryBreakdownData> categoryBreakdown, required this.status, this.errorMessage, this.canRetry = false, this.effect, required this.effectVersion}): _transactions = transactions,_categoryBreakdown = categoryBreakdown;


@override final  double totalIncome;
@override final  String monthLabel;
@override final  double incomeChangePercent;
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

@override final  IncomesViewStatus status;
@override final  String? errorMessage;
@override@JsonKey() final  bool canRetry;
@override final  IncomesEffect? effect;
@override final  int effectVersion;

/// Create a copy of IncomesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IncomesStateCopyWith<_IncomesState> get copyWith => __$IncomesStateCopyWithImpl<_IncomesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IncomesState&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.monthLabel, monthLabel) || other.monthLabel == monthLabel)&&(identical(other.incomeChangePercent, incomeChangePercent) || other.incomeChangePercent == incomeChangePercent)&&const DeepCollectionEquality().equals(other._transactions, _transactions)&&const DeepCollectionEquality().equals(other._categoryBreakdown, _categoryBreakdown)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.canRetry, canRetry) || other.canRetry == canRetry)&&(identical(other.effect, effect) || other.effect == effect)&&(identical(other.effectVersion, effectVersion) || other.effectVersion == effectVersion));
}


@override
int get hashCode => Object.hash(runtimeType,totalIncome,monthLabel,incomeChangePercent,const DeepCollectionEquality().hash(_transactions),const DeepCollectionEquality().hash(_categoryBreakdown),status,errorMessage,canRetry,effect,effectVersion);

@override
String toString() {
  return 'IncomesState(totalIncome: $totalIncome, monthLabel: $monthLabel, incomeChangePercent: $incomeChangePercent, transactions: $transactions, categoryBreakdown: $categoryBreakdown, status: $status, errorMessage: $errorMessage, canRetry: $canRetry, effect: $effect, effectVersion: $effectVersion)';
}


}

/// @nodoc
abstract mixin class _$IncomesStateCopyWith<$Res> implements $IncomesStateCopyWith<$Res> {
  factory _$IncomesStateCopyWith(_IncomesState value, $Res Function(_IncomesState) _then) = __$IncomesStateCopyWithImpl;
@override @useResult
$Res call({
 double totalIncome, String monthLabel, double incomeChangePercent, List<TransactionData> transactions, List<CategoryBreakdownData> categoryBreakdown, IncomesViewStatus status, String? errorMessage, bool canRetry, IncomesEffect? effect, int effectVersion
});




}
/// @nodoc
class __$IncomesStateCopyWithImpl<$Res>
    implements _$IncomesStateCopyWith<$Res> {
  __$IncomesStateCopyWithImpl(this._self, this._then);

  final _IncomesState _self;
  final $Res Function(_IncomesState) _then;

/// Create a copy of IncomesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalIncome = null,Object? monthLabel = null,Object? incomeChangePercent = null,Object? transactions = null,Object? categoryBreakdown = null,Object? status = null,Object? errorMessage = freezed,Object? canRetry = null,Object? effect = freezed,Object? effectVersion = null,}) {
  return _then(_IncomesState(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,monthLabel: null == monthLabel ? _self.monthLabel : monthLabel // ignore: cast_nullable_to_non_nullable
as String,incomeChangePercent: null == incomeChangePercent ? _self.incomeChangePercent : incomeChangePercent // ignore: cast_nullable_to_non_nullable
as double,transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<TransactionData>,categoryBreakdown: null == categoryBreakdown ? _self._categoryBreakdown : categoryBreakdown // ignore: cast_nullable_to_non_nullable
as List<CategoryBreakdownData>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as IncomesViewStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,canRetry: null == canRetry ? _self.canRetry : canRetry // ignore: cast_nullable_to_non_nullable
as bool,effect: freezed == effect ? _self.effect : effect // ignore: cast_nullable_to_non_nullable
as IncomesEffect?,effectVersion: null == effectVersion ? _self.effectVersion : effectVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

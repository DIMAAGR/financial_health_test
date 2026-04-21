// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardState {

 String get userName; double get balance; double get income; double get expense; FinancialHealthScoreData get financialHealthScore; FlowAnalysisData get flowAnalysis; MonthlyGoalData get monthlyGoal; DashboardViewStatus get status; String? get errorMessage; bool get canRetry; DashboardEffect? get effect; int get effectVersion;
/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardStateCopyWith<DashboardState> get copyWith => _$DashboardStateCopyWithImpl<DashboardState>(this as DashboardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardState&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.financialHealthScore, financialHealthScore) || other.financialHealthScore == financialHealthScore)&&(identical(other.flowAnalysis, flowAnalysis) || other.flowAnalysis == flowAnalysis)&&(identical(other.monthlyGoal, monthlyGoal) || other.monthlyGoal == monthlyGoal)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.canRetry, canRetry) || other.canRetry == canRetry)&&(identical(other.effect, effect) || other.effect == effect)&&(identical(other.effectVersion, effectVersion) || other.effectVersion == effectVersion));
}


@override
int get hashCode => Object.hash(runtimeType,userName,balance,income,expense,financialHealthScore,flowAnalysis,monthlyGoal,status,errorMessage,canRetry,effect,effectVersion);

@override
String toString() {
  return 'DashboardState(userName: $userName, balance: $balance, income: $income, expense: $expense, financialHealthScore: $financialHealthScore, flowAnalysis: $flowAnalysis, monthlyGoal: $monthlyGoal, status: $status, errorMessage: $errorMessage, canRetry: $canRetry, effect: $effect, effectVersion: $effectVersion)';
}


}

/// @nodoc
abstract mixin class $DashboardStateCopyWith<$Res>  {
  factory $DashboardStateCopyWith(DashboardState value, $Res Function(DashboardState) _then) = _$DashboardStateCopyWithImpl;
@useResult
$Res call({
 String userName, double balance, double income, double expense, FinancialHealthScoreData financialHealthScore, FlowAnalysisData flowAnalysis, MonthlyGoalData monthlyGoal, DashboardViewStatus status, String? errorMessage, bool canRetry, DashboardEffect? effect, int effectVersion
});




}
/// @nodoc
class _$DashboardStateCopyWithImpl<$Res>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._self, this._then);

  final DashboardState _self;
  final $Res Function(DashboardState) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userName = null,Object? balance = null,Object? income = null,Object? expense = null,Object? financialHealthScore = null,Object? flowAnalysis = null,Object? monthlyGoal = null,Object? status = null,Object? errorMessage = freezed,Object? canRetry = null,Object? effect = freezed,Object? effectVersion = null,}) {
  return _then(_self.copyWith(
userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as double,financialHealthScore: null == financialHealthScore ? _self.financialHealthScore : financialHealthScore // ignore: cast_nullable_to_non_nullable
as FinancialHealthScoreData,flowAnalysis: null == flowAnalysis ? _self.flowAnalysis : flowAnalysis // ignore: cast_nullable_to_non_nullable
as FlowAnalysisData,monthlyGoal: null == monthlyGoal ? _self.monthlyGoal : monthlyGoal // ignore: cast_nullable_to_non_nullable
as MonthlyGoalData,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DashboardViewStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,canRetry: null == canRetry ? _self.canRetry : canRetry // ignore: cast_nullable_to_non_nullable
as bool,effect: freezed == effect ? _self.effect : effect // ignore: cast_nullable_to_non_nullable
as DashboardEffect?,effectVersion: null == effectVersion ? _self.effectVersion : effectVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardState].
extension DashboardStatePatterns on DashboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardState value)  $default,){
final _that = this;
switch (_that) {
case _DashboardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardState value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userName,  double balance,  double income,  double expense,  FinancialHealthScoreData financialHealthScore,  FlowAnalysisData flowAnalysis,  MonthlyGoalData monthlyGoal,  DashboardViewStatus status,  String? errorMessage,  bool canRetry,  DashboardEffect? effect,  int effectVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.userName,_that.balance,_that.income,_that.expense,_that.financialHealthScore,_that.flowAnalysis,_that.monthlyGoal,_that.status,_that.errorMessage,_that.canRetry,_that.effect,_that.effectVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userName,  double balance,  double income,  double expense,  FinancialHealthScoreData financialHealthScore,  FlowAnalysisData flowAnalysis,  MonthlyGoalData monthlyGoal,  DashboardViewStatus status,  String? errorMessage,  bool canRetry,  DashboardEffect? effect,  int effectVersion)  $default,) {final _that = this;
switch (_that) {
case _DashboardState():
return $default(_that.userName,_that.balance,_that.income,_that.expense,_that.financialHealthScore,_that.flowAnalysis,_that.monthlyGoal,_that.status,_that.errorMessage,_that.canRetry,_that.effect,_that.effectVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userName,  double balance,  double income,  double expense,  FinancialHealthScoreData financialHealthScore,  FlowAnalysisData flowAnalysis,  MonthlyGoalData monthlyGoal,  DashboardViewStatus status,  String? errorMessage,  bool canRetry,  DashboardEffect? effect,  int effectVersion)?  $default,) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.userName,_that.balance,_that.income,_that.expense,_that.financialHealthScore,_that.flowAnalysis,_that.monthlyGoal,_that.status,_that.errorMessage,_that.canRetry,_that.effect,_that.effectVersion);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardState implements DashboardState {
  const _DashboardState({required this.userName, required this.balance, required this.income, required this.expense, required this.financialHealthScore, required this.flowAnalysis, required this.monthlyGoal, required this.status, this.errorMessage, this.canRetry = false, this.effect, required this.effectVersion});


@override final  String userName;
@override final  double balance;
@override final  double income;
@override final  double expense;
@override final  FinancialHealthScoreData financialHealthScore;
@override final  FlowAnalysisData flowAnalysis;
@override final  MonthlyGoalData monthlyGoal;
@override final  DashboardViewStatus status;
@override final  String? errorMessage;
@override@JsonKey() final  bool canRetry;
@override final  DashboardEffect? effect;
@override final  int effectVersion;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardStateCopyWith<_DashboardState> get copyWith => __$DashboardStateCopyWithImpl<_DashboardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardState&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.financialHealthScore, financialHealthScore) || other.financialHealthScore == financialHealthScore)&&(identical(other.flowAnalysis, flowAnalysis) || other.flowAnalysis == flowAnalysis)&&(identical(other.monthlyGoal, monthlyGoal) || other.monthlyGoal == monthlyGoal)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.canRetry, canRetry) || other.canRetry == canRetry)&&(identical(other.effect, effect) || other.effect == effect)&&(identical(other.effectVersion, effectVersion) || other.effectVersion == effectVersion));
}


@override
int get hashCode => Object.hash(runtimeType,userName,balance,income,expense,financialHealthScore,flowAnalysis,monthlyGoal,status,errorMessage,canRetry,effect,effectVersion);

@override
String toString() {
  return 'DashboardState(userName: $userName, balance: $balance, income: $income, expense: $expense, financialHealthScore: $financialHealthScore, flowAnalysis: $flowAnalysis, monthlyGoal: $monthlyGoal, status: $status, errorMessage: $errorMessage, canRetry: $canRetry, effect: $effect, effectVersion: $effectVersion)';
}


}

/// @nodoc
abstract mixin class _$DashboardStateCopyWith<$Res> implements $DashboardStateCopyWith<$Res> {
  factory _$DashboardStateCopyWith(_DashboardState value, $Res Function(_DashboardState) _then) = __$DashboardStateCopyWithImpl;
@override @useResult
$Res call({
 String userName, double balance, double income, double expense, FinancialHealthScoreData financialHealthScore, FlowAnalysisData flowAnalysis, MonthlyGoalData monthlyGoal, DashboardViewStatus status, String? errorMessage, bool canRetry, DashboardEffect? effect, int effectVersion
});




}
/// @nodoc
class __$DashboardStateCopyWithImpl<$Res>
    implements _$DashboardStateCopyWith<$Res> {
  __$DashboardStateCopyWithImpl(this._self, this._then);

  final _DashboardState _self;
  final $Res Function(_DashboardState) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userName = null,Object? balance = null,Object? income = null,Object? expense = null,Object? financialHealthScore = null,Object? flowAnalysis = null,Object? monthlyGoal = null,Object? status = null,Object? errorMessage = freezed,Object? canRetry = null,Object? effect = freezed,Object? effectVersion = null,}) {
  return _then(_DashboardState(
userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as double,financialHealthScore: null == financialHealthScore ? _self.financialHealthScore : financialHealthScore // ignore: cast_nullable_to_non_nullable
as FinancialHealthScoreData,flowAnalysis: null == flowAnalysis ? _self.flowAnalysis : flowAnalysis // ignore: cast_nullable_to_non_nullable
as FlowAnalysisData,monthlyGoal: null == monthlyGoal ? _self.monthlyGoal : monthlyGoal // ignore: cast_nullable_to_non_nullable
as MonthlyGoalData,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DashboardViewStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,canRetry: null == canRetry ? _self.canRetry : canRetry // ignore: cast_nullable_to_non_nullable
as bool,effect: freezed == effect ? _self.effect : effect // ignore: cast_nullable_to_non_nullable
as DashboardEffect?,effectVersion: null == effectVersion ? _self.effectVersion : effectVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

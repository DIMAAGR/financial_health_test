// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_transaction_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddTransactionState {

 int get amountCents; String get description; TransactionCategory get category; bool get isSubmitting;
/// Create a copy of AddTransactionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddTransactionStateCopyWith<AddTransactionState> get copyWith => _$AddTransactionStateCopyWithImpl<AddTransactionState>(this as AddTransactionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddTransactionState&&(identical(other.amountCents, amountCents) || other.amountCents == amountCents)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting));
}


@override
int get hashCode => Object.hash(runtimeType,amountCents,description,category,isSubmitting);

@override
String toString() {
  return 'AddTransactionState(amountCents: $amountCents, description: $description, category: $category, isSubmitting: $isSubmitting)';
}


}

/// @nodoc
abstract mixin class $AddTransactionStateCopyWith<$Res>  {
  factory $AddTransactionStateCopyWith(AddTransactionState value, $Res Function(AddTransactionState) _then) = _$AddTransactionStateCopyWithImpl;
@useResult
$Res call({
 int amountCents, String description, TransactionCategory category, bool isSubmitting
});




}
/// @nodoc
class _$AddTransactionStateCopyWithImpl<$Res>
    implements $AddTransactionStateCopyWith<$Res> {
  _$AddTransactionStateCopyWithImpl(this._self, this._then);

  final AddTransactionState _self;
  final $Res Function(AddTransactionState) _then;

/// Create a copy of AddTransactionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amountCents = null,Object? description = null,Object? category = null,Object? isSubmitting = null,}) {
  return _then(_self.copyWith(
amountCents: null == amountCents ? _self.amountCents : amountCents // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TransactionCategory,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AddTransactionState].
extension AddTransactionStatePatterns on AddTransactionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddTransactionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddTransactionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddTransactionState value)  $default,){
final _that = this;
switch (_that) {
case _AddTransactionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddTransactionState value)?  $default,){
final _that = this;
switch (_that) {
case _AddTransactionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int amountCents,  String description,  TransactionCategory category,  bool isSubmitting)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddTransactionState() when $default != null:
return $default(_that.amountCents,_that.description,_that.category,_that.isSubmitting);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int amountCents,  String description,  TransactionCategory category,  bool isSubmitting)  $default,) {final _that = this;
switch (_that) {
case _AddTransactionState():
return $default(_that.amountCents,_that.description,_that.category,_that.isSubmitting);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int amountCents,  String description,  TransactionCategory category,  bool isSubmitting)?  $default,) {final _that = this;
switch (_that) {
case _AddTransactionState() when $default != null:
return $default(_that.amountCents,_that.description,_that.category,_that.isSubmitting);case _:
  return null;

}
}

}

/// @nodoc


class _AddTransactionState extends AddTransactionState {
  const _AddTransactionState({required this.amountCents, required this.description, required this.category, this.isSubmitting = false}): super._();


@override final  int amountCents;
@override final  String description;
@override final  TransactionCategory category;
@override@JsonKey() final  bool isSubmitting;

/// Create a copy of AddTransactionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddTransactionStateCopyWith<_AddTransactionState> get copyWith => __$AddTransactionStateCopyWithImpl<_AddTransactionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddTransactionState&&(identical(other.amountCents, amountCents) || other.amountCents == amountCents)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting));
}


@override
int get hashCode => Object.hash(runtimeType,amountCents,description,category,isSubmitting);

@override
String toString() {
  return 'AddTransactionState(amountCents: $amountCents, description: $description, category: $category, isSubmitting: $isSubmitting)';
}


}

/// @nodoc
abstract mixin class _$AddTransactionStateCopyWith<$Res> implements $AddTransactionStateCopyWith<$Res> {
  factory _$AddTransactionStateCopyWith(_AddTransactionState value, $Res Function(_AddTransactionState) _then) = __$AddTransactionStateCopyWithImpl;
@override @useResult
$Res call({
 int amountCents, String description, TransactionCategory category, bool isSubmitting
});




}
/// @nodoc
class __$AddTransactionStateCopyWithImpl<$Res>
    implements _$AddTransactionStateCopyWith<$Res> {
  __$AddTransactionStateCopyWithImpl(this._self, this._then);

  final _AddTransactionState _self;
  final $Res Function(_AddTransactionState) _then;

/// Create a copy of AddTransactionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amountCents = null,Object? description = null,Object? category = null,Object? isSubmitting = null,}) {
  return _then(_AddTransactionState(
amountCents: null == amountCents ? _self.amountCents : amountCents // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TransactionCategory,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

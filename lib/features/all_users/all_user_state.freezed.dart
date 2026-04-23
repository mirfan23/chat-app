// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'all_user_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AllUserState {

 bool get isLoading; List<AllUserModel> get users; Object? get error;
/// Create a copy of AllUserState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AllUserStateCopyWith<AllUserState> get copyWith => _$AllUserStateCopyWithImpl<AllUserState>(this as AllUserState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AllUserState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.users, users)&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(users),const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'AllUserState(isLoading: $isLoading, users: $users, error: $error)';
}


}

/// @nodoc
abstract mixin class $AllUserStateCopyWith<$Res>  {
  factory $AllUserStateCopyWith(AllUserState value, $Res Function(AllUserState) _then) = _$AllUserStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<AllUserModel> users, Object? error
});




}
/// @nodoc
class _$AllUserStateCopyWithImpl<$Res>
    implements $AllUserStateCopyWith<$Res> {
  _$AllUserStateCopyWithImpl(this._self, this._then);

  final AllUserState _self;
  final $Res Function(AllUserState) _then;

/// Create a copy of AllUserState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? users = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<AllUserModel>,error: freezed == error ? _self.error : error ,
  ));
}

}


/// Adds pattern-matching-related methods to [AllUserState].
extension AllUserStatePatterns on AllUserState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AllUserState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AllUserState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AllUserState value)  $default,){
final _that = this;
switch (_that) {
case _AllUserState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AllUserState value)?  $default,){
final _that = this;
switch (_that) {
case _AllUserState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<AllUserModel> users,  Object? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AllUserState() when $default != null:
return $default(_that.isLoading,_that.users,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<AllUserModel> users,  Object? error)  $default,) {final _that = this;
switch (_that) {
case _AllUserState():
return $default(_that.isLoading,_that.users,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<AllUserModel> users,  Object? error)?  $default,) {final _that = this;
switch (_that) {
case _AllUserState() when $default != null:
return $default(_that.isLoading,_that.users,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _AllUserState implements AllUserState {
  const _AllUserState({this.isLoading = false, final  List<AllUserModel> users = const [], this.error}): _users = users;
  

@override@JsonKey() final  bool isLoading;
 final  List<AllUserModel> _users;
@override@JsonKey() List<AllUserModel> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}

@override final  Object? error;

/// Create a copy of AllUserState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AllUserStateCopyWith<_AllUserState> get copyWith => __$AllUserStateCopyWithImpl<_AllUserState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AllUserState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._users, _users)&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_users),const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'AllUserState(isLoading: $isLoading, users: $users, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AllUserStateCopyWith<$Res> implements $AllUserStateCopyWith<$Res> {
  factory _$AllUserStateCopyWith(_AllUserState value, $Res Function(_AllUserState) _then) = __$AllUserStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<AllUserModel> users, Object? error
});




}
/// @nodoc
class __$AllUserStateCopyWithImpl<$Res>
    implements _$AllUserStateCopyWith<$Res> {
  __$AllUserStateCopyWithImpl(this._self, this._then);

  final _AllUserState _self;
  final $Res Function(_AllUserState) _then;

/// Create a copy of AllUserState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? users = null,Object? error = freezed,}) {
  return _then(_AllUserState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<AllUserModel>,error: freezed == error ? _self.error : error ,
  ));
}


}

// dart format on

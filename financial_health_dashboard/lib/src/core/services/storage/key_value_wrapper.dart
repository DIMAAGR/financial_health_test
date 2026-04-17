abstract class KeyValueWrapper {
  Future<bool> setString(String key, String value);
  String? getString(String key);
  Future<bool> remove(String key);
}

class InMemoryKeyValueWrapper implements KeyValueWrapper {
  InMemoryKeyValueWrapper({Map<String, String>? initialValues})
    : _cache = initialValues == null
          ? <String, String>{}
          : Map<String, String>.from(initialValues);

  final Map<String, String> _cache;

  @override
  Future<bool> setString(String key, String value) {
    _cache[key] = value;
    return Future<bool>.value(true);
  }

  @override
  String? getString(String key) {
    return _cache[key];
  }

  @override
  Future<bool> remove(String key) {
    final exists = _cache.containsKey(key);
    _cache.remove(key);
    return Future<bool>.value(exists);
  }
}

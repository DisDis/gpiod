
import 'dart:ffi';

import 'package:gpiod/src/bindings/pthread/signatures.dart';
import 'package:gpiod/src/bindings/pthread/types.dart';

class Pthread {
  final String libraryName = 'libpthread.so';
  DynamicLibrary _dynamicLibrary;

  ///int pthread_mutex_lock(pthread_mutex_t *mutex);
  int Function(Pointer<pthread_mutex_t> mutex) mutex_lock;

  ///int pthread_mutex_trylock(pthread_mutex_t *mutex);
  int Function(Pointer<pthread_mutex_t> mutex) mutex_trylock;

  ///int pthread_mutex_unlock(pthread_mutex_t *mutex);
  int Function(Pointer<pthread_mutex_t> mutex) mutex_unlock;
  static Pthread _instance;

  factory Pthread(){
    if (_instance == null) {
      _instance = new Pthread._internal();
    }
    return _instance;
  }

  Pthread._internal(){
    _dynamicLibrary = DynamicLibrary.open(libraryName);

    mutex_lock = _dynamicLibrary.lookup<NativeFunction<pthread_mutex_lock_native_t>>("pthread_mutex_lock").asFunction();
    mutex_trylock = _dynamicLibrary.lookup<NativeFunction<pthread_mutex_trylock_native_t>>("pthread_mutex_trylock").asFunction();
    mutex_unlock = _dynamicLibrary.lookup<NativeFunction<pthread_mutex_unlock_native_t>>("pthread_mutex_unlock").asFunction();
  }
}
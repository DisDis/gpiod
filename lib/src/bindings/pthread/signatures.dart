import 'dart:ffi';
import 'types.dart';

///int pthread_mutex_lock(pthread_mutex_t *mutex);
typedef pthread_mutex_lock_native_t = Int32 Function(Pointer<pthread_mutex_t> mutex);
///int pthread_mutex_trylock(pthread_mutex_t *mutex);
typedef pthread_mutex_trylock_native_t = Int32 Function(Pointer<pthread_mutex_t> mutex);
///int pthread_mutex_unlock(pthread_mutex_t *mutex);
typedef pthread_mutex_unlock_native_t = Int32 Function(Pointer<pthread_mutex_t> mutex);

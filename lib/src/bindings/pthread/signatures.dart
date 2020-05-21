import 'dart:ffi';
import 'types.dart';

///int pthread_mutex_lock(pthread_mutex_t *mutex);
typedef pthread_mutex_lock_native_t = Int32 Function(Pointer<pthread_mutex_t> mutex);
///int pthread_mutex_trylock(pthread_mutex_t *mutex);
typedef pthread_mutex_trylock_native_t = Int32 Function(Pointer<pthread_mutex_t> mutex);
///int pthread_mutex_unlock(pthread_mutex_t *mutex);
typedef pthread_mutex_unlock_native_t = Int32 Function(Pointer<pthread_mutex_t> mutex);
///int pthread_create(pthread_t *thread, const pthread_attr_t *attr, void *(*start_routine) (void *), void *arg);
typedef pthread_create_native_t = Int32 Function(Pointer<pthread_t> thread, Pointer<pthread_attr_t> attr, Pointer<NativeFunction> start_routine, Pointer<Void> arg);

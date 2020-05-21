import 'dart:ffi';
import 'types.dart';

///int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event)
typedef epoll_ctl_native_t = Int32 Function(Int32 epfd, Int32 op, int fd, Pointer<epoll_event> event);
///int epoll_create(int size);
typedef epoll_create_native_t = Int32 Function(Int32 size);
///int epoll_create1(int flags);
typedef epoll_create1_native_t = Int32 Function(Int32 flags);

///int epoll_wait(int epfd, struct epoll_event *events, int maxevents, int timeout);
typedef epoll_wait_native_t = Int32 Function(Int32 epfd, Pointer<epoll_event> events, Int32 maxevents, Int32 timeout);
///int epoll_pwait(int epfd, struct epoll_event *events,int maxevents, int timeout, const sigset_t *sigmask);
//typedef epoll_pwait_native_t = Int32 Function(Int32 epfd, Pointer<epoll_event> events, Int32 maxevents, Int32 timeout, Pointer<sigset_t> sigmask);

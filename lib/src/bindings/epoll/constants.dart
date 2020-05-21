class EpollEvents {
  final int value;

  const EpollEvents._internal(this.value);

//    EPOLLIN = 0x001,
static const EpollEvents EPOLLIN = const EpollEvents._internal(0x001);
//    EPOLLPRI = 0x002,
static const EpollEvents EPOLLPRI = const EpollEvents._internal(0x002);
/*#define EPOLLPRI EPOLLPRI
    EPOLLOUT = 0x004,
#define EPOLLOUT EPOLLOUT
    EPOLLRDNORM = 0x040,
#define EPOLLRDNORM EPOLLRDNORM
    EPOLLRDBAND = 0x080,
#define EPOLLRDBAND EPOLLRDBAND
    EPOLLWRNORM = 0x100,
#define EPOLLWRNORM EPOLLWRNORM
    EPOLLWRBAND = 0x200,
#define EPOLLWRBAND EPOLLWRBAND
    EPOLLMSG = 0x400,
#define EPOLLMSG EPOLLMSG
    EPOLLERR = 0x008,
#define EPOLLERR EPOLLERR
    EPOLLHUP = 0x010,
#define EPOLLHUP EPOLLHUP
    EPOLLRDHUP = 0x2000,
#define EPOLLRDHUP EPOLLRDHUP
    EPOLLONESHOT = (1 << 30),
#define EPOLLONESHOT EPOLLONESHOT
    EPOLLET = (1 << 31)
#define EPOLLET EPOLLET
  };
*/


}


class EPOLL_CTL {
  final int value;

  const EPOLL_CTL._internal(this.value);

  ///#define EPOLL_CTL_ADD 1        /* Add a file decriptor to the interface.  */
  static const EPOLL_CTL EPOLL_CTL_ADD = const EPOLL_CTL._internal(1);

  ///#define EPOLL_CTL_DEL 2        /* Remove a file decriptor from the interface.  */
  static const EPOLL_CTL EPOLL_CTL_DEL = const EPOLL_CTL._internal(2);

  ///#define EPOLL_CTL_MOD 3        /* Change file decriptor epoll_event structure.  */
  static const EPOLL_CTL EPOLL_CTL_MOD = const EPOLL_CTL._internal(3);
}

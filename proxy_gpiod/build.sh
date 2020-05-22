#!/bin/sh
gcc -fPIC -Wall -g -c libproxy_gpiod.c
gcc -g -shared -Wl,-soname,libproxy_gpiod.so.0 -o libproxy_gpiod.so.0.0 libproxy_gpiod.o -lc
mv ./libproxy_gpiod.so.0.0 ./libproxy_gpiod.so
//
//  main.m
//  UDPServer
//
//  Created by Matthew Lintlop on 12/5/17.
//  Copyright © 2017 Matthew Lintlop. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>

#define BUFLEN 512
#define NPACK 10
#define PORT 9930

void diep(char *s) {
    perror(s);
    exit(1);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        struct sockaddr_in6 si_me, si_other;
        int s, i, slen=sizeof(si_other);
        char buf[BUFLEN];

        if ((s=socket(AF_INET6, SOCK_DGRAM, IPPROTO_UDP))==-1)
            diep("socket");

        memset((char *) &si_me, 0, sizeof(si_me));
        si_me.sin6_family = AF_INET6;
        si_me.sin6_port = htons(PORT);
        si_me.sin6_addr = in6addr_any;
        if (bind(s, &si_me, sizeof(si_me))==-1)
            diep("bind");

        for (i=0; i<NPACK; i++) {
            if (recvfrom(s, buf, BUFLEN, 0, &si_other, &slen)==-1)
                diep("recvfrom()");
                printf("Received packet Data: %s\n\n",  buf);
        }
        close(s);
    }
    return 0;
}

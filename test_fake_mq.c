#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int main (void)
{
	int fd;
	char buf;

	if ((fd = open("/dev/fake_mq", O_RDONLY)) < 0) {
		perror("open()");
		return 1;
	}
	while (1) {
		if (read(fd, &buf, 1) <= 0) {
			perror("read()");
			break;
		}
		printf("%d\n", (int)buf);
		sleep(1);
	}

	close(fd);
	return 0;
}

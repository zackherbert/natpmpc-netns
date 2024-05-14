install:
	cp systemd/natpmpc@.service /etc/systemd/system/natpmpc@.service
	cp natpmpc-netns /usr/local/bin/natpmpc-netns
	cp natpmpc-netns-service /usr/local/bin/natpmpc-netns-service

uninstall:
	rm /etc/systemd/system/natpmpc@.service
	rm /usr/local/bin/natpmpc-netns
	rm /usr/local/bin/natpmpc-netns-service

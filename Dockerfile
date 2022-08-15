FROM alpine

CMD [ "sh", "-c", "echo 'Hello World' && while true; do sleep 1; done;" ]

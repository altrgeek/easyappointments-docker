############################################################
# Dockerfile to run Easy!Appointments
# Based on Alpine
############################################################

FROM altrgeek/nginx-php-alpine:latest

MAINTAINER Rumman Zaman (altrgeek)

ENV BASE_URL=http://localhost:8888
ENV LANGUAGE=english
ENV DEBUG=false
ENV DB_HOST=db
ENV DB_NAME=easyappointments
ENV DB_USERNAME=root
ENV DB_PASSWORD=hellodocker
ENV GOOGLE_SYNC_FEATURE=false
ENV GOOGLE_PRODUCT_NAME=""
ENV GOOGLE_CLIENT_ID=""
ENV GOOGLE_CLIENT_SECRET=""
ENV GOOGLE_API_KEY=""
ENV TZ="UTC"

EXPOSE 8888

WORKDIR /app/www/

RUN apk add --no-cache \
        php81-ctype \
        php81-curl \
        php81-session \
        tzdata

ADD https://github.com/alextselegidis/easyappointments/releases/download/1.4.3/easyappointments-1.4.3.zip /app/www/

RUN unzip -o /app/www/easyappointments-1.4.3.zip && \
    rm easyappointments-1.4.3.zip
COPY ./patch.sh /app/.tmp/patch.sh
COPY ./app/ /app/
RUN sh /app/.tmp/patch.sh && \
    rm -rf /app/.tmp/

ENTRYPOINT ["/sbin/tini", "--", "python", "/app/run.py"]

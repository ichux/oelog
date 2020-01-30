FROM buildev

ENV PYTHONUNBUFFERED 1

COPY serverConfigs/elog.conf /etc/nginx/sites-available/
COPY serverConfigs/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /var/www/
COPY . .

RUN mkdir -p /var/log/nginx/elog /var/log/uwsgi/elog /var/log/supervisor \
    && rm /etc/nginx/sites-enabled/default \
    && ln -s /etc/nginx/sites-available/elog.conf /etc/nginx/sites-enabled/elog.conf \
    && echo "daemon off;" >> /etc/nginx/nginx.conf \
    &&  pip3.7 install -U pip setuptools uwsgi && pip3.7 install -r /var/www/elog/requirements.txt \
    && chown -R www-data:www-data /var/www/elog && chown -R www-data:www-data /var/log \
    && chmod +x entrypoint.sh

EXPOSE 5000
ENTRYPOINT ["./entrypoint.sh"]
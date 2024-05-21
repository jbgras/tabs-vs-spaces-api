FROM mcr.microsoft.com/cbl-mariner/base/python:3.9
RUN /usr/bin/python3.9 -m pip install --upgrade pip
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
ENTRYPOINT gunicorn -b 0.0.0.0:80 app:app
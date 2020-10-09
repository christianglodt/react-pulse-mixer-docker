# Stage 0, "build-stage", based on Node.js, to build and compile the frontend
FROM tiangolo/node-frontend:10 as build-stage
WORKDIR /
# prevent caching of result of git clone by adding file from github including unique version information
ADD https://api.github.com/repos/christianglodt/react-pulse-mixer/git/refs/heads/main version.json
RUN git clone https://github.com/christianglodt/react-pulse-mixer.git
WORKDIR react-pulse-mixer
RUN npm install
RUN npm run build

# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx

FROM tiangolo/uwsgi-nginx-flask:python3.8
WORKDIR /
RUN apt-get update && apt-get install -y ca-certificates libpulse0
RUN rm -rf /app
ADD https://api.github.com/repos/christianglodt/rest-pulse-mixer/git/refs/heads/main version.json
RUN git clone https://github.com/christianglodt/rest-pulse-mixer.git /app
RUN pip install -r /app/requirements.txt
COPY --from=build-stage /react-pulse-mixer/build/ /app/static
COPY config.json /app/static/
COPY uwsgi.ini /app
COPY nginx.conf /app

FROM node:22-alpine3.21 AS dev

WORKDIR /code

COPY package.json /code
COPY yarn.lock /code
RUN yarn install --frozen-lockfile

COPY . /code
RUN yarn run res:build && yarn run build

FROM nginx:alpine AS prod

COPY --from=dev /code/dist/ /usr/share/nginx/html
COPY robot.txt /usr/share/nginx/html
COPY env.sh /docker-entrypoint.d/env.sh

RUN chmod +x /docker-entrypoint.d/env.sh

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

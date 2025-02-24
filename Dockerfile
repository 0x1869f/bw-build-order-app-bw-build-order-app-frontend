FROM node:22-alpine3.21 as dev

WORKDIR /code

COPY package.json /code
COPY yarn.lock /code
RUN yarn install --frozen-lockfile

COPY . /code
RUN yarn run res:build && yarn run build

FROM nginx:alpine as prod

COPY --from=dev /code/dist/ /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

FROM node:16-alpine AS react-app-builder

WORKDIR /usr/share/react-app

COPY package.json .

RUN npm install

COPY . .

RUN npm run build

RUN apk add --no-cache zip

FROM nginx

EXPOSE 80

COPY --from=react-app-builder /usr/share/react-app/build /usr/share/nginx/html



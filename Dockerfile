FROM golang:1.21.4-bullseye AS build

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -trimpath -ldflags "-w -s" -o app

FROM gcr.io/distroless/static-debian12:latest AS deploy
COPY --from=build /app/app .
CMD [ "./app" ]

FROM golang:1.21.4-alpine AS dev
WORKDIR /app
RUN go install github.com/cosmtrek/air@latest
CMD [ "air", "-c", ".air.toml" ]

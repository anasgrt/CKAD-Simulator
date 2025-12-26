#!/bin/bash
echo "[SETUP] Creating directories..."
sudo mkdir -p /opt/course/11/image
sudo chmod -R 777 /opt/course/11

echo "[SETUP] Creating Go application..."
cat > /opt/course/11/image/main.go << 'GOCODE'
package main

import (
    "log"
    "math/rand"
    "os"
    "time"
)

func main() {
    id := os.Getenv("SUN_CIPHER_ID")
    if id == "" {
        id = "unknown"
    }
    
    rand.Seed(time.Now().UnixNano())
    
    for i := 0; i < 12; i++ {
        log.Printf("random number for %s is %d", id, rand.Intn(10000))
    }
    
    for {
        time.Sleep(10 * time.Second)
        log.Printf("random number for %s is %d", id, rand.Intn(10000))
    }
}
GOCODE

cat > /opt/course/11/image/go.mod << 'GOMOD'
module sun-cipher

go 1.15
GOMOD

cat > /opt/course/11/image/Dockerfile << 'DOCKERFILE'
# build container stage 1
FROM docker.io/library/golang:1.15.15-alpine3.14
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o bin/app .

# app container stage 2
FROM docker.io/library/alpine:3.12.4
COPY --from=0 /src/bin/app app
ENV SUN_CIPHER_ID=changeme
CMD ["./app"]
DOCKERFILE

echo "[SETUP] Environment ready!"
echo "[WARN] This question requires Docker and/or Podman installed"
echo "[WARN] A container registry at localhost:5000 should be available"

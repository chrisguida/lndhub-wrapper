ASSETS := $(shell yq e '.assets.[].src' manifest.yaml)
ASSET_PATHS := $(addprefix assets/,$(ASSETS))
VERSION := $(shell yq e ".version" manifest.yaml)
# HELLO_WORLD_SRC := $(shell find ./lndhub/src) lndhub/Cargo.toml lndhub/Cargo.lock
S9PK_PATH=$(shell find . -name lndhub.s9pk -print)

.DELETE_ON_ERROR:

all: verify

verify: lndhub.s9pk $(S9PK_PATH)
	embassy-sdk verify s9pk $(S9PK_PATH)

clean:
	rm -f image.tar
	rm -f lndhub.s9pk

lndhub.s9pk: manifest.yaml assets/compat/config_spec.yaml assets/compat/config_rules.yaml image.tar instructions.md $(ASSET_PATHS)
	embassy-sdk pack

# image.tar: Dockerfile docker_entrypoint.sh check-web.sh lndhub/target/aarch64-unknown-linux-musl/release/lndhub
image.tar: Dockerfile docker_entrypoint.sh check-api.sh
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/lndhub/main:$(VERSION) --platform=linux/arm64 -o type=docker,dest=image.tar .

# lndhub/target/aarch64-unknown-linux-musl/release/lndhub: $(HELLO_WORLD_SRC)
# lndhub/target/aarch64-unknown-linux-musl/release/lndhub:
# 	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/lndhub:/home/rust/src start9/rust-musl-cross:aarch64-musl cargo build --release

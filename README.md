# Wrapper for LndHub

`LndHub` is a free and open source, multiple account plugin for Lightning built on top of the Lightning Network Deamon. It allows that a group of users run different accounts with only one node in a trust-minimized setup. Ideal for hosted shared services or groups, families and friends that want to share their own node. Required for connecting BlueWallet to a self-hosted LND node, such as the one available on EmbassyOS.

## Dependencies

- [docker](https://docs.docker.com/get-docker)
- [docker-buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [yq](https://mikefarah.gitbook.io/yq)
- [embassy-sdk](https://github.com/Start9Labs/embassy-os/blob/master/backend/install-sdk.sh)
- [make](https://www.gnu.org/software/make/)

## Cloning

```
git clone https://github.com/Start9Labs/lndhub-wrapper.git
git submodule update --init
cd lndhub-wrapper
```

## Building

```
make
```

## Sideload onto your Embassy

SSH into an Embassy device.
`scp` the `.s9pk` to any directory from your local machine.
Run the following command to determine successful install:

```
scp lndhub.s9pk root@embassy-<id>.local:/embassy-data/package-data/tmp # Copy the S9PK to the external disk
ssh root@embassy-<id>.local
embassy-cli auth login
embassy-cli package install lndhub.s9pk # Install the sideloaded package
```

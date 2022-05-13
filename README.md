# Zero-knowledge

### Install Circom Enviorment

Install rust

`curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh`

Clone circom repository

`git clone https://github.com/iden3/circom.git`

Change directery to circom
Cargo build to compile then
`cargo build --release`

Install circom binary in directory $HOME/.cargo/bin
`cargo install --path circom`

Install snarkjs with node.js or cpp
`npm install -g snarkjs`

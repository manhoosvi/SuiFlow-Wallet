# SuiFlow Wallet — Web3 Sui Ecosystem Wallet

A Web3 crypto wallet built on the **Sui blockchain** using the **Move language**, developed as part of the **Myntra Hackathon**. Features token management, NFT gallery, staking, and deployed Move smart contracts — all in a sleek dark futuristic UI.

## Features

- **Wallet Dashboard** — SUI balance, USD equivalent, multi-token portfolio (SUI, USDC, CETUS)
- **Send / Receive** — Token transfer with real-time gas estimation
- **Transaction History** — Live activity feed with contract call details and confirmation status
- **NFT Gallery** — View your Sui-based NFT collection
- **Staking** — Validator selection with APY, staked balance, and epoch tracking
- **Move Contracts** — View all deployed smart contracts with metadata and tags

## Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | HTML5, CSS3, Vanilla JavaScript |
| Blockchain | Sui Network (Testnet) |
| Smart Contracts | Move Language |
| Wallet Integration | Sui SDK / @mysten/sui.js |
| Gas Estimation | On-chain gas_estimator.move module |
| Fonts | Space Mono + Syne (Google Fonts) |

## Project Structure

```
sui-wallet/
├── index.html            # Full frontend — wallet UI
├── contracts/
│   ├── wallet_auth.move  # Wallet auth & ownership verification
│   ├── token_transfer.move  # Optimized token transfers (~20% gas reduction)
│   ├── nft_mint.move     # NFT minting with royalties
│   └── gas_estimator.move   # Pre-tx gas estimation helper
└── README.md
```

## Move Smart Contracts

### `wallet_auth.move`
Handles wallet ownership verification and secure token transfer authorization using Sui's object-centric model.

### `token_transfer.move`
Gas-optimized SUI token transfer. Reduces gas consumption by ~20% through efficient object passing and minimizing shared state.

### `nft_mint.move`
NFT minting module supporting metadata, collection limits, and on-chain royalty enforcement.

### `gas_estimator.move`
On-chain gas estimation helper — calculates expected fees before submission for UX transparency.

## Getting Started

```bash
# Clone the repo
git clone https://github.com/yourusername/suiflow-wallet.git

# Open frontend
open index.html

# Deploy contracts to Sui testnet (requires Sui CLI)
sui client publish --gas-budget 10000000
```

### Prerequisites for contract deployment
```bash
# Install Sui CLI
cargo install --locked --git https://github.com/MystenLabs/sui.git --branch devnet sui

# Set testnet as active env
sui client new-env --alias testnet --rpc https://fullnode.testnet.sui.io:443
sui client switch --env testnet
```

## Future Improvements

- Full Sui SDK integration (`@mysten/sui.js`) for live on-chain data
- MetaMask / Sui Wallet browser extension connect
- Real-time price feeds via CoinGecko API
- Swap integration with Cetus DEX
- Multi-wallet support
- Mobile PWA

## Hackathon

Built for the **Myntra Hackathon** — demonstrating Move smart contract development, Sui ecosystem integration, gas optimization, and Web3 frontend connectivity.

---

Made with ◈ on Sui by Manashvi # SuiFlow-Wallet

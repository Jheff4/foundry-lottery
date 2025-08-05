# 🧾 Decentralized Lottery Smart Contract

This project implements a decentralized lottery system using Solidity and Chainlink VRF for provably fair randomness. Participants enter the lottery by paying a fixed entrance fee, and after a set interval, a random winner is selected and awarded the prize pool.

## 🚀 Features

- Chainlink VRF for verifiable randomness
- Chainlink Keepers (Automation) for automatic winner selection
- Modular, gas-optimized smart contracts using Foundry
- Unit and integration tests included

## 📦 Tech Stack

- Solidity
- Foundry (Forge, Cast)
- Chainlink VRF v2
- Chainlink Automation (Keepers)

## 🧪 Test Coverage

- Full unit tests using Forge
- VRF Coordinator mock for local testing
- Automation-compatible testing flow

## 📂 Project Structure

contracts/ → Core Lottery contract and interfaces
script/ → Deployment scripts
test/ → Unit and integration tests
foundry.toml → Foundry config

## ⚙️ How It Works

1. Users enter the lottery by sending ETH equal to the `entranceFee`.
2. After a set interval (configurable), the Chainlink Keeper checks if it's time to pick a winner.
3. If yes, Chainlink VRF is requested for a random number.
4. A random winner is selected from the participants and the prize is transferred.
5. The lottery resets for the next round.

## 🔐 Security Considerations

- Only the contract can request randomness from Chainlink VRF
- Reentrancy protection using `ReentrancyGuard`
- State transitions are validated to prevent manipulation

## 📜 Deployment

```bash
# Install dependencies
forge install

# Set your environment variables
cp .env.example .env

# Deploy to testnet
forge script script/DeployLottery.s.sol --rpc-url <your_rpc> --private-key $PRIVATE_KEY --broadcast

✅ Run Tests
forge test

👨‍💻 Author
Etinosa Ogbevoen

📄 License
MIT

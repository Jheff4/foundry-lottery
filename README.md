🎰 Decentralized Lottery Smart Contract
A secure, verifiable, and decentralized lottery system built with Solidity and powered by Chainlink VRF for fair randomness.

✨ Features
🎲 Verifiable Randomness: Uses Chainlink VRF to select a truly random winner.

🕒 Timed Entry: Players can only enter the lottery during an active round.

💰 Automatic Payouts: The winner automatically receives the full contract balance.

🔁 Resettable Rounds: After a winner is picked, the lottery resets for the next round.

✅ Test Coverage: Built and tested with Foundry, including mocks for local development.

🧪 Gas-efficient Design: Optimized for minimal gas consumption.

⚙️ Tech Stack
Solidity

Chainlink VRF v2

Foundry (Forge & Anvil)

Hardhat (optional for deployments)

🚀 Quick Start
bash
Copy
Edit
forge test
📂 Project Structure
Lottery.sol: Core lottery contract

VRFCoordinatorV2Mock.sol: Mock for Chainlink VRF testing

test/: Unit tests using Foundry

script/: Deployment scripts

🛡️ Security
Winner selection is powered by Chainlink VRF to prevent manipulation.

Only the owner can trigger upkeep and winner selection.

All ETH is transferred securely using .call.

📜 License
MIT

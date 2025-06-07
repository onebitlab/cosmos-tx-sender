
# Cosmos Transaction Sender Script

This is a simple Bash script for sending multiple transactions on Cosmos SDK-based blockchains (e.g., Umee, Evmos, Gaia) using a specified binary. It supports logging, configurable delays, and customizable parameters via an external `.env` config file.

---

## ⚙️ Features

- Sends a specified number of transactions
- Supports Cosmos SDK binaries (`umeed`, `gaiad`, `evmosd`, etc.)
- Fully configurable via `config.env`
- Logs transaction hashes and statuses with timestamps
- Automatically detects binary path via `which`

---

## 📦 Requirements

- A valid Cosmos SDK binary installed and available in `$PATH` (e.g. `umeed`)
- `jq` installed (`sudo apt install jq`)
- Wallets and keys already set up via the binary
- Executable permission for `send.sh`

---

## 🔧 Setup

1. **Clone the repository**

```bash
git clone https://github.com/yourusername/cosmos-tx-sender.git
cd cosmos-tx-sender
```

2. **Create and edit the `config.env` file**

```ini
# config.env

BINARY=umeed                         # Name of the binary (must be in PATH)
LOG=txs.log                          # Log file name
PWD=your_wallet_password            # Wallet password
TX_COUNT=10                         # Number of transactions to send
FROM_WALLET_ADDRESS=umee1...        # Sender wallet address
TO_WALLET_ADDRESS=umee1...          # Recipient wallet address
TX_AMOUNT=10000uumee                # Amount per transaction
DELAY=2                             # Delay in seconds between transactions
NODE_CHAIN=umee-1                   # Chain ID
TX_FEES=300uumee                    # Transaction fee
```

> ⚠️ **Never commit your `config.env` file with sensitive data to a public repository.**

3. **Make the script executable**

```bash
chmod +x send.sh
```

---

## 🚀 Usage

```bash
./send.sh
```

The script will:

- Load configuration from `config.env`
- Validate all variables
- Locate the binary in your system
- Send each transaction with a delay
- Log each transaction result to the specified log file

---

## 🧪 Example Log Output

```
[2025-06-07 14:01:22] ✅ TX 1: Sent successfully. Hash: A1B2C3...
[2025-06-07 14:01:25] ❌ TX 2: Failed to send. Response: {...}
```

---

## 📁 Project Structure

```
cosmos-tx-sender/
├── send.sh         # Main script
├── config.env      # Configuration file (user-provided)
└── txs.log         # Output log file (auto-generated)
```

---

## 🛡️ Disclaimer

This script is provided as-is with no warranty. Use at your own risk. Always test on a testnet before using on mainnet.

---

## 📄 License

MIT License

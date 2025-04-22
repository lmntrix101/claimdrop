# Claimdrop Smart Contract

## Description

The **Claimdrop Smart Contract** is a Clarity-based contract for the Stacks blockchain that enables token distributions to eligible users through a secure, on-chain claiming process. It ensures each user can claim their allocated tokens exactly once, making it ideal for airdrops, community rewards, and token distribution campaigns.

## Features

- 🧾 **Whitelist-Based Distribution:** Only approved addresses can claim tokens.
- 🔐 **One-Time Claims:** Ensures each address can only claim once to prevent abuse.
- 🪙 **Token Allocation:** Admin can pre-assign token amounts to eligible users.
- 📊 **Claim Status Tracking:** On-chain tracking of which users have claimed.
- ⚙️ **Admin Functions:** Admin can add claim records, update allocations, and withdraw unclaimed tokens.

## Core Functions

- `register-claim`: Admin-only function to register users and their claimable amounts.
- `claim`: Allows eligible users to claim their allocated tokens.
- `has-claimed`: View function to check if a user has already claimed.
- `get-claimable-amount`: Returns the allocated amount for a user.
- `withdraw-unclaimed`: Admin can recover any unclaimed tokens after a deadline (optional).

## Setup & Testing

Built using [Clarinet](https://docs.stacks.co/docs/clarity/clarinet/overview/), the official toolchain for Clarity smart contracts.

### Run Tests

```bash
clarinet test

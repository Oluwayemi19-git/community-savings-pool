# Clarity Community Savings Pool (Part 1)

This README describes the first part of a Clarity smart contract that defines the core data structures and the `register-member` function for a community savings pool. The contract is designed to handle user registrations and track fundamental metrics like the total pool amount, interest rate, and the number of registered members.

---

## Overview

**What does this snippet do?**

- Defines essential data variables (pool amount, interest rate, distribution block, and member count).
- Sets up a map to store each member's balance.
- Declares constants for error handling.
- Implements a public function `register-member` to add new members to the pool.

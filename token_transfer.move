module suiflow::token_transfer {
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::event;

    /// Transfer receipt for tracking
    struct TransferReceipt has copy, drop {
        sender: address,
        recipient: address,
        amount: u64,
        gas_used: u64,
    }

    const EZeroAmount: u64 = 0;
    const EInsufficientFunds: u64 = 1;

    /// Gas-optimized single transfer
    /// Avoids shared object contention — uses owned objects only
    public entry fun transfer_sui(
        coin: &mut Coin<SUI>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext
    ) {
        assert!(amount > 0, EZeroAmount);
        assert!(coin::value(coin) >= amount, EInsufficientFunds);

        // Split exact amount — no intermediate objects created
        let payment = coin::split(coin, amount, ctx);
        transfer::public_transfer(payment, recipient);

        event::emit(TransferReceipt {
            sender: tx_context::sender(ctx),
            recipient,
            amount,
            gas_used: 0, // populated by runtime
        });
    }

    /// Batch transfer to multiple recipients in one transaction
    /// More gas efficient than N separate transfers
    public entry fun batch_transfer(
        coin: &mut Coin<SUI>,
        amounts: vector<u64>,
        recipients: vector<address>,
        ctx: &mut TxContext
    ) {
        let len = std::vector::length(&amounts);
        assert!(len == std::vector::length(&recipients), 0);

        let i = 0;
        while (i < len) {
            let amount = *std::vector::borrow(&amounts, i);
            let recipient = *std::vector::borrow(&recipients, i);
            assert!(coin::value(coin) >= amount, EInsufficientFunds);

            let payment = coin::split(coin, amount, ctx);
            transfer::public_transfer(payment, recipient);
            i = i + 1;
        };
    }

    /// Estimate gas for a transfer (approximate, in MIST)
    public fun estimate_gas(amount: u64): u64 {
        // Base gas: 200 MIST + 1 MIST per 1000 SUI (in MIST)
        let base = 200u64;
        let variable = amount / 1_000_000_000; // convert MIST to SUI scale
        base + variable
    }
}

module suiflow::wallet_auth {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use std::string::{Self, String};

    /// Wallet owner capability — only holder can authorize transfers
    struct WalletCap has key, store {
        id: UID,
        owner: address,
        label: String,
    }

    /// Emitted on each authorized transfer
    struct TransferEvent has copy, drop {
        from: address,
        to: address,
        amount: u64,
    }

    /// Error codes
    const ENotOwner: u64 = 0;
    const EInsufficientBalance: u64 = 1;

    /// Create a new wallet capability for the sender
    public entry fun create_wallet(label: vector<u8>, ctx: &mut TxContext) {
        let cap = WalletCap {
            id: object::new(ctx),
            owner: tx_context::sender(ctx),
            label: string::utf8(label),
        };
        transfer::transfer(cap, tx_context::sender(ctx));
    }

    /// Authorized token transfer — requires WalletCap ownership
    public entry fun authorized_transfer(
        cap: &WalletCap,
        coin: &mut Coin<SUI>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext
    ) {
        assert!(cap.owner == tx_context::sender(ctx), ENotOwner);
        assert!(coin::value(coin) >= amount, EInsufficientBalance);

        let payment = coin::split(coin, amount, ctx);
        transfer::public_transfer(payment, recipient);
    }

    /// Read wallet owner
    public fun owner(cap: &WalletCap): address {
        cap.owner
    }

    /// Read wallet label
    public fun label(cap: &WalletCap): &String {
        &cap.label
    }
}

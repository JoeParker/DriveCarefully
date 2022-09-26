import DriveCarefully.Config.*

// During a traffic collision, charge a price based on the impact velocity

@wrapMethod(VehicleObject)
protected cb func OnTrafficBumpEvent(evt: ref<VehicleTrafficBumpEvent>) -> Bool {
    let impact: Float = evt.impactVelocityChange;
    let price: Int32 = (RoundMath(impact * 10.0) + 10) * 2 * costModifier();
    let playerPuppet = GetPlayer(this.GetGame());
    let transactionSystem = GameInstance.GetTransactionSystem(this.GetGame());

    let playerMoney: Int32 = transactionSystem.GetItemQuantity(playerPuppet, MarketSystem.Money());
    let charge: Int32 = Min(price, playerMoney);

    if !GameObject.IsCooldownActive(this, n"bumpCooldown") {
        transactionSystem.RemoveItemByTDBID(playerPuppet, t"Items.money", charge);
        if enableMessages() {
            showPaymentMessage(this.GetGame(), charge, playerMoney == 0);
        };
    };
    return wrappedMethod(evt);
}

// Notification

final static func showPaymentMessage(gameInstance: GameInstance, price: Int32, insufficientFunds: Bool) -> Void {
    let onscreenMsg: SimpleScreenMessage;

    onscreenMsg.isShown = true;
    onscreenMsg.duration = 5.0;
    onscreenMsg.message = insufficientFunds ? "Traffic Collision Detected.\nInsufficient funds to cover damages.\nPlease drive carefully." : s"Traffic Collision Detected.\nYou have been charged \(IntToString(price))§\nHave a pleasant day.";

    GameInstance.GetBlackboardSystem(gameInstance).Get(GetAllBlackboardDefs().UI_Notifications).SetVariant(GetAllBlackboardDefs().UI_Notifications.OnscreenMessage, ToVariant(onscreenMsg), true);
}
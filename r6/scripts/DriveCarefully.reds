@wrapMethod(VehicleObject)
protected cb func OnTrafficBumpEvent(evt: ref<VehicleTrafficBumpEvent>) -> Bool {
    let impact: Float = evt.impactVelocityChange;
    let price: Int32 = RoundMath(impact * 10.0);
    //if this.m_bumpedRecently == 0 {
        let playerPuppet = GetPlayer(this.GetGame());
        GameInstance.GetTransactionSystem(this.GetGame()).RemoveItemByTDBID(playerPuppet, t"Items.money", price);

        showPaymentMessage(this.GetGame(), price);
    //};
    return wrappedMethod(evt);
}

 final static func showPaymentMessage(gameInstance: GameInstance, price: Int32) -> Void {
    let onscreenMsg: SimpleScreenMessage;
    onscreenMsg.isShown = true;
    onscreenMsg.duration = 5.0;
    onscreenMsg.message = s"Collision Detected.\nYou have been charged \(IntToString(price))§.\nHave a pleasant day.";
    GameInstance.GetBlackboardSystem(gameInstance).Get(GetAllBlackboardDefs().UI_Notifications).SetVariant(GetAllBlackboardDefs().UI_Notifications.OnscreenMessage, ToVariant(onscreenMsg), true);
}
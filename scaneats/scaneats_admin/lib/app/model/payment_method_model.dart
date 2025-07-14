class PaymentMethodModel {
  FlutterWave? flutterWave;
  PayStack? payStack;
  Strip? strip;
  Wallet? wallet;
  MercadoPago? mercadoPago;
  RazorpayModel? razorpay;
  Paytm? paytm;
  Payfast? payfast;
  Wallet? cash;
  Wallet? card;
  Paypal? paypal;

  PaymentMethodModel({this.flutterWave, this.payStack, this.strip, this.wallet, this.mercadoPago, this.razorpay, this.paytm, this.payfast, this.cash, this.paypal, this.card});

  PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    flutterWave = json['flutterWave'] != null ? FlutterWave.fromJson(json['flutterWave']) : null;
    payStack = json['payStack'] != null ? PayStack.fromJson(json['payStack']) : null;
    strip = json['strip'] != null ? Strip.fromJson(json['strip']) : null;
    wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
    mercadoPago = json['mercadoPago'] != null ? MercadoPago.fromJson(json['mercadoPago']) : null;
    razorpay = json['razorpay'] != null ? RazorpayModel.fromJson(json['razorpay']) : null;
    paytm = json['paytm'] != null ? Paytm.fromJson(json['paytm']) : null;
    payfast = json['payfast'] != null ? Payfast.fromJson(json['payfast']) : null;
    cash = json['cash'] != null ? Wallet.fromJson(json['cash']) : null;
    card = json['card'] != null ? Wallet.fromJson(json['card']) : null;
    paypal = json['paypal'] != null ? Paypal.fromJson(json['paypal']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (flutterWave != null) {
      data['flutterWave'] = flutterWave!.toJson();
    }
    if (payStack != null) {
      data['payStack'] = payStack!.toJson();
    }
    if (strip != null) {
      data['strip'] = strip!.toJson();
    }
    if (wallet != null) {
      data['wallet'] = wallet!.toJson();
    }
    if (mercadoPago != null) {
      data['mercadoPago'] = mercadoPago!.toJson();
    }
    if (razorpay != null) {
      data['razorpay'] = razorpay!.toJson();
    }
    if (paytm != null) {
      data['paytm'] = paytm!.toJson();
    }
    if (payfast != null) {
      data['payfast'] = payfast!.toJson();
    }
    if (cash != null) {
      data['cash'] = cash!.toJson();
    }
    if (card != null) {
      data['card'] = card!.toJson();
    }
    if (paypal != null) {
      data['paypal'] = paypal!.toJson();
    }
    return data;
  }
}

class FlutterWave {
  bool? enable;
  String? name;
  String? publicKey;
  bool? isSandbox;

  FlutterWave({this.enable, this.name, this.publicKey, this.isSandbox});

  FlutterWave.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    name = json['name'];
    publicKey = json['publicKey'];
    isSandbox = json['isSandbox'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable'] = enable;
    data['name'] = name;
    data['publicKey'] = publicKey;
    data['isSandbox'] = isSandbox;
    return data;
  }
}

class PayStack {
  String? secretKey;
  bool? enable;
  String? name;
  String? publicKey;

  PayStack({this.secretKey, this.enable, this.name, this.publicKey});

  PayStack.fromJson(Map<String, dynamic> json) {
    secretKey = json['secretKey'];
    enable = json['enable'];
    name = json['name'];
    publicKey = json['publicKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['secretKey'] = secretKey;
    data['enable'] = enable;
    data['name'] = name;
    data['publicKey'] = publicKey;
    return data;
  }
}

class Strip {
  String? stripeSecret;
  bool? enable;
  String? name;

  Strip({this.stripeSecret, this.enable, this.name});

  Strip.fromJson(Map<String, dynamic> json) {
    stripeSecret = json['stripeSecret'];
    enable = json['enable'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stripeSecret'] = stripeSecret;
    data['enable'] = enable;
    data['name'] = name;
    return data;
  }
}

class Wallet {
  bool? enable;
  String? name;

  Wallet({this.enable, this.name});

  Wallet.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable'] = enable;
    data['name'] = name;
    return data;
  }
}

class MercadoPago {
  bool? enable;
  String? name;
  String? publicKey;
  String? accessToken;
  bool? isSandbox;

  MercadoPago({this.enable, this.name, this.publicKey, this.accessToken, this.isSandbox});

  MercadoPago.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    name = json['name'];
    publicKey = json['publicKey'];
    accessToken = json['accessToken'];
    isSandbox = json['isSandbox'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable'] = enable;
    data['name'] = name;
    data['publicKey'] = publicKey;
    data['accessToken'] = accessToken;
    data['isSandbox'] = isSandbox;
    return data;
  }
}

class RazorpayModel {
  bool? enable;
  String? razorpayKey;
  String? name;

  RazorpayModel({this.name, this.enable, this.razorpayKey});

  RazorpayModel.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    razorpayKey = json['razorpayKey'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable'] = enable;
    data['razorpayKey'] = razorpayKey;
    data['name'] = name;
    return data;
  }
}

class Paytm {
  bool? enable;
  String? paytmMID;
  bool? isSandbox;
  String? merchantKey;
  String? name;

  Paytm({this.name, this.enable, this.paytmMID, this.isSandbox, this.merchantKey});

  Paytm.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    paytmMID = json['paytmMID'];
    isSandbox = json['isSandbox'];
    merchantKey = json['merchantKey'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable'] = enable;
    data['paytmMID'] = paytmMID;
    data['isSandbox'] = isSandbox;
    data['merchantKey'] = merchantKey;
    data['name'] = name;
    return data;
  }
}

class Payfast {
  String? merchantId;
  bool? enable;
  String? name;
  String? returnUrl;
  String? notifyUrl;
  bool? isSandbox;
  String? cancelUrl;
  String? merchantKey;

  Payfast({this.merchantId, this.enable, this.name, this.returnUrl, this.notifyUrl, this.isSandbox, this.cancelUrl, this.merchantKey});

  Payfast.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchantId'];
    enable = json['enable'];
    name = json['name'];
    returnUrl = json['return_url'];
    notifyUrl = json['notify_url'];
    isSandbox = json['isSandbox'];
    cancelUrl = json['cancel_url'];
    merchantKey = json['merchantKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['merchantId'] = merchantId;
    data['enable'] = enable;
    data['name'] = name;
    data['return_url'] = returnUrl;
    data['notify_url'] = notifyUrl;
    data['isSandbox'] = isSandbox;
    data['cancel_url'] = cancelUrl;
    data['merchantKey'] = merchantKey;
    return data;
  }
}

class Paypal {
  bool? enable;
  String? name;
  String? paypalSecret;
  String? paypalClient;
  bool? isSandbox;

  Paypal({this.name, this.enable, this.paypalSecret, this.isSandbox, this.paypalClient});

  Paypal.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    name = json['name'];
    paypalSecret = json['paypalSecret'];
    paypalClient = json['paypalClient'];
    isSandbox = json['isSandbox'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable'] = enable;
    data['name'] = name;
    data['paypalSecret'] = paypalSecret;
    data['isSandbox'] = isSandbox;
    data['paypalClient'] = paypalClient;
    return data;
  }
}

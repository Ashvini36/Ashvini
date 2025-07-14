class PaymentModel {
  FlutterWave? flutterWave;
  PayStack? payStack;
  Strip? strip;
  Wallet? wallet;
  MercadoPago? mercadoPago;
  RazorpayModel? razorpay;
  Payfast? payfast;
  Wallet? cash;
  Paypal? paypal;
  Xendit? xendit;
  OrangePay? orangePay;
  Midtrans? midtrans;

  PaymentModel(
      {this.flutterWave,
      this.payStack,
      this.strip,
      this.wallet,
      this.mercadoPago,
      this.razorpay,
      this.payfast,
      this.cash,
      this.paypal,
      this.xendit,
      this.midtrans,
      this.orangePay});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    flutterWave = json['flutterWave'] != null ? FlutterWave.fromJson(json['flutterWave']) : null;
    payStack = json['payStack'] != null ? PayStack.fromJson(json['payStack']) : null;
    strip = json['strip'] != null ? Strip.fromJson(json['strip']) : null;
    wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
    mercadoPago = json['mercadoPago'] != null ? MercadoPago.fromJson(json['mercadoPago']) : null;
    razorpay = json['razorpay'] != null ? RazorpayModel.fromJson(json['razorpay']) : null;
    payfast = json['payfast'] != null ? Payfast.fromJson(json['payfast']) : null;
    cash = json['cash'] != null ? Wallet.fromJson(json['cash']) : null;
    paypal = json['paypal'] != null ? Paypal.fromJson(json['paypal']) : null;
    xendit = json['xendit'] != null ? Xendit.fromJson(json['xendit']) : null;
    orangePay = json['orangePay'] != null ? OrangePay.fromJson(json['orangePay']) : null;
    midtrans = json['midtrans'] != null ? Midtrans.fromJson(json['midtrans']) : null;
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
    if (payfast != null) {
      data['payfast'] = payfast!.toJson();
    }
    if (cash != null) {
      data['cash'] = cash!.toJson();
    }
    if (paypal != null) {
      data['paypal'] = paypal!.toJson();
    }
    if (midtrans != null) {
      data['midtrans'] = midtrans!.toJson();
    }
    if (orangePay != null) {
      data['orangePay'] = orangePay!.toJson();
    }
    if (xendit != null) {
      data['xendit'] = xendit!.toJson();
    }
    return data;
  }
}

class FlutterWave {
  String? secretKey;
  bool? enable;
  String? name;
  String? publicKey;
  String? encryptionKey;
  bool? isSandbox;
  String? image;

  FlutterWave({this.secretKey, this.enable, this.name, this.publicKey, this.encryptionKey, this.isSandbox, this.image});

  FlutterWave.fromJson(Map<String, dynamic> json) {
    secretKey = json['secretKey'];
    enable = json['enable'];
    name = json['name'];
    publicKey = json['publicKey'];
    encryptionKey = json['encryptionKey'];
    isSandbox = json['isSandbox'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['secretKey'] = secretKey;
    data['enable'] = enable;
    data['name'] = name;
    data['publicKey'] = publicKey;
    data['encryptionKey'] = encryptionKey;
    data['isSandbox'] = isSandbox;
    data['image'] = image;
    return data;
  }
}

class PayStack {
  String? secretKey;
  bool? enable;
  String? name;
  String? callbackURL;
  String? publicKey;
  bool? isSandbox;
  String? webhookURL;
  String? image;

  PayStack({this.secretKey, this.enable, this.name, this.callbackURL, this.publicKey, this.isSandbox, this.webhookURL, this.image});

  PayStack.fromJson(Map<String, dynamic> json) {
    secretKey = json['secretKey'];
    enable = json['enable'];
    name = json['name'];
    callbackURL = json['callbackURL'];
    publicKey = json['publicKey'];
    isSandbox = json['isSandbox'];
    webhookURL = json['webhookURL'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['secretKey'] = secretKey;
    data['enable'] = enable;
    data['name'] = name;
    data['callbackURL'] = callbackURL;
    data['publicKey'] = publicKey;
    data['isSandbox'] = isSandbox;
    data['webhookURL'] = webhookURL;
    data['image'] = image;
    return data;
  }
}

class Strip {
  String? clientpublishableKey;
  String? stripeSecret;
  bool? enable;
  String? name;
  bool? isSandbox;
  String? image;

  Strip({this.clientpublishableKey, this.stripeSecret, this.enable, this.name, this.isSandbox, this.image});

  Strip.fromJson(Map<String, dynamic> json) {
    clientpublishableKey = json['clientpublishableKey'];
    stripeSecret = json['stripeSecret'];
    enable = json['enable'];
    name = json['name'];
    isSandbox = json['isSandbox'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientpublishableKey'] = clientpublishableKey;
    data['stripeSecret'] = stripeSecret;
    data['enable'] = enable;
    data['name'] = name;
    data['isSandbox'] = isSandbox;
    data['image'] = image;
    return data;
  }
}

class Wallet {
  bool? enable;
  String? name;
  String? image;

  Wallet({this.enable, this.name, this.image});

  Wallet.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable'] = enable;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class MercadoPago {
  bool? enable;
  String? name;
  String? publicKey;
  String? accessToken;
  bool? isSandbox;
  String? image;

  MercadoPago({this.enable, this.name, this.publicKey, this.accessToken, this.isSandbox, this.image});

  MercadoPago.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    name = json['name'];
    publicKey = json['publicKey'];
    accessToken = json['accessToken'];
    isSandbox = json['isSandbox'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable'] = enable;
    data['name'] = name;
    data['publicKey'] = publicKey;
    data['accessToken'] = accessToken;
    data['isSandbox'] = isSandbox;
    data['image'] = image;
    return data;
  }
}

class RazorpayModel {
  bool? enable;
  String? razorpayKey;
  bool? isSandbox;
  String? razorpaySecret;
  String? name;
  String? image;

  RazorpayModel({this.name, this.enable, this.razorpayKey, this.isSandbox, this.razorpaySecret, this.image});

  RazorpayModel.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    razorpayKey = json['razorpayKey'];
    isSandbox = json['isSandbox'];
    razorpaySecret = json['razorpaySecret'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable'] = enable;
    data['razorpayKey'] = razorpayKey;
    data['isSandbox'] = isSandbox;
    data['razorpaySecret'] = razorpaySecret;
    data['name'] = name;
    data['image'] = image;
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
  String? image;

  Payfast({this.merchantId, this.enable, this.name, this.returnUrl, this.notifyUrl, this.isSandbox, this.cancelUrl, this.merchantKey, this.image});

  Payfast.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchantId'];
    enable = json['enable'];
    name = json['name'];
    returnUrl = json['return_url'];
    notifyUrl = json['notify_url'];
    isSandbox = json['isSandbox'];
    cancelUrl = json['cancel_url'];
    merchantKey = json['merchantKey'];
    image = json['image'];
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
    data['image'] = image;
    return data;
  }
}

class Paypal {
  bool? enable;
  String? name;
  String? paypalSecret;
  String? paypalClient;
  String? image;
  bool? isSandbox;

  Paypal({this.name, this.enable, this.paypalSecret, this.isSandbox, this.paypalClient, this.image});

  Paypal.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    name = json['name'];
    paypalSecret = json['paypalSecret'];
    paypalClient = json['paypalClient'];
    isSandbox = json['isSandbox'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['enable'] = enable;
    data['name'] = name;
    data['paypalSecret'] = paypalSecret;
    data['isSandbox'] = isSandbox;
    data['paypalClient'] = paypalClient;
    data['image'] = image;
    return data;
  }
}

class Xendit {
  bool? enable;
  String? name;
  bool? isSandbox;
  String? apiKey;
  String? image;

  Xendit({
    this.name,
    this.enable,
    this.apiKey,
    this.isSandbox,
    this.image,
  });

  Xendit.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    name = json['name'];
    isSandbox = json['isSandbox'];
    apiKey = json['apiKey'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['enable'] = enable;
    data['name'] = name;
    data['isSandbox'] = isSandbox;
    data['apiKey'] = apiKey;
    data['image'] = image;
    return data;
  }
}

class Midtrans {
  bool? enable;
  String? name;
  bool? isSandbox;
  String? serverKey;
  String? image;

  Midtrans({
    this.name,
    this.enable,
    this.serverKey,
    this.isSandbox,
    this.image,
  });

  Midtrans.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    name = json['name'];
    isSandbox = json['isSandbox'];
    serverKey = json['serverKey'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['enable'] = enable;
    data['name'] = name;
    data['isSandbox'] = isSandbox;
    data['serverKey'] = serverKey;
    data['image'] = image;
    return data;
  }
}

class OrangePay {
  String? clientId;
  String? clientSecret;
  String? merchantKey;
  String? auth;
  String? returnUrl;
  String? cancelUrl;
  String? notifyUrl;
  String? name;
  bool? enable;
  bool? isSandbox;
  String? image;

  OrangePay(
      {this.clientId = '',
      this.clientSecret = '',
      this.merchantKey,
      this.auth,
      this.returnUrl = '',
      this.cancelUrl = '',
      this.notifyUrl = '',
      this.name,
      this.isSandbox = false,
      this.image,
      this.enable = false});

  OrangePay.fromJson(Map<String, dynamic> parsedJson) {
    clientId = parsedJson['clientId'];
    clientSecret = parsedJson['clientSecret'];
    merchantKey = parsedJson['merchantKey'];
    auth = parsedJson['auth'];
    enable = parsedJson['enable'];
    returnUrl = parsedJson['returnUrl'];
    cancelUrl = parsedJson['cancelUrl'];
    notifyUrl = parsedJson['notifyUrl'];
    isSandbox = parsedJson['isSandbox'];
    name = parsedJson['name'];
    image = parsedJson['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientId'] = clientId;
    data['clientSecret'] = clientSecret;
    data['merchantKey'] = merchantKey;
    data['auth'] = auth;
    data['enable'] = enable;
    data['return_url'] = returnUrl;
    data['cancel_url'] = cancelUrl;
    data['notif_url'] = notifyUrl;
    data['isSandbox'] = isSandbox;
    data['name'] = name;
    data['image'] = image;

    return data;
  }
}

export class ExportShareStatus {

  constructor(shareChannel) {
    this.shareChannel = shareChannel
    this.setupForm()
    this.setupNotifications()
    this.setupShareContent()
  }

  setupForm() {
    this.shareOnRouteToCustom = document.querySelector("#shareOnRouteToCustom")
    this.roadToCustomStatus = document.querySelector("#roadToCustomStatus")
  }

  setupShareContent() {
    this.share_modal = $('[data-remodal-id=share-content]').remodal();
    this.shareTitle = document.querySelector("#shareTitle")
    this.shareContent = "shareValue"
    var self = this;

    $('#shareMerchStored').on('click', function(event) {
      shareTitle.innerHTML = "MERCANCÍA RECOLECTADA"
      self.shareContent = "roadToCustom"
      self.share_modal.open();
    });

    $('#shareReportLock').on('click', function(event) {
      shareTitle.innerHTML = "REPORTE DE CANDADO";
      self.shareContent = "reportLock";
      self.share_modal.open();
    });

    $('#shareOnCustomRoute').on('click', function(event) {
      shareTitle.innerHTML = "EN RUTA HACIA ADUANA";
      self.shareContent = "reportOnCustomRoute";
      self.share_modal.open();
    });

    $('#shareOnCustomArrival').on('click', function(event) {
      shareTitle.innerHTML = "LLEGADA A ADUANA";
      self.shareContent = "reportOnCustomArrival";
      self.share_modal.open();
    });

    // $('#shareReportLigth').on('click', function(event) {
    //   shareTitle.innerHTML = "REPORTE DE SEMÁFORO";
    //   self.shareContent = "reportLight";
    //   self.share_modal.open();
    // });


    // $('#shareMerchStored').on('click', function(event) {
    //   shareTitle.innerHTML = "MERCANCÍA ALMACENADA";
    //   self.shareContent = "reportMerchStored";
    //   self.share_modal.open();
    // });

    // $('#shareBeginRoute').on('click', function(event) {
    //   shareTitle.innerHTML = "INICIO DE RUTA";
    //   self.shareContent = "reportBeginRoute";
    //   self.share_modal.open();
    // });

    // $('#shareArriving').on('click', function(event) {
    //   shareTitle.innerHTML = "LLEGADA A DESTINO";
    //   self.shareContent = "reportArriving";
    //   self.share_modal.open();
    // });

    // $('#shareDeliver').on('click', function(event) {
    //   shareTitle.innerHTML = "LLEGADA A DESTINO";
    //   self.shareContent = "reportDeliver";
    //   self.share_modal.open();
    // });

  }

  setupNotifications() {
    var self = this;
    this.shareOnRouteToCustom.onclick = function(){
      let emails = $('.input-emails__shared').val();
      let ucargoOrderId = document.querySelector("#ucargoOrderId");
      let shareMyMail = document.querySelector("#checkboxOnRouteToCustom");
      self.sendMails(emails, shareMyMail.checked, ucargoOrderId);
      self.share_modal.close();
    };
  }

  sendMails(emails, sendToMe, orderId) {
    let payload = {emails: emails,
                 sendToMe: sendToMe,
                  orderId: orderId.value,
                   userId: window.userId,
                    stage: this.shareContent}
    this.shareChannel.push("shareOnRouteToCustom", {body: payload}, 50000)
          .receive("ok", (msg) => "sent")
          .receive("error", (reasons) => console.log("create failed", reasons) )
          .receive("timeout", () => console.log("Networking issue...") )
  }
}
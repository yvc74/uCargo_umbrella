export class ImportShareStatus {

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
    $('#shareRoadToCustom').on('click', function(event) {
      shareTitle.innerHTML = "CAMINO A ADUANA"
      self.shareContent = "roadToCustom"
      self.share_modal.open();
    });

    $('#shareReportLigth').on('click', function(event) {
      shareTitle.innerHTML = "REPORTE DE SEMÁFORO"
      self.shareContent = "reportLight"
      self.share_modal.open();
    });
  }

  setupNotifications() {
    var self = this;
    this.shareOnRouteToCustom.onclick = function(){
      let emails = $('.input-emails__shared').val();
      let ucargoOrderId = document.querySelector("#ucargoOrderId")
      let shareMyMail = document.querySelector("#checkboxOnRouteToCustom");
      self.sendMails(emails, shareMyMail.checked, ucargoOrderId)
      self.share_modal.close();
    };
  }

  sendMails(emails, sendToMe, orderId) {
    let payload = {emails: emails,
                 sendToMe: sendToMe,
                  orderId: orderId.value,
                   userId: window.userId}
    this.shareChannel.push("shareOnRouteToCustom", {body: payload}, 50000)
          .receive("ok", (msg) => "sent")
          .receive("error", (reasons) => console.log("create failed", reasons) )
          .receive("timeout", () => console.log("Networking issue...") )
  }
}
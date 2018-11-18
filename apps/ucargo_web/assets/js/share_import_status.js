export class ImportShareStatus {

  constructor(shareChannel) {
    this.shareChannel = shareChannel
    this.setupForm()
    this.setupNotifications()
  }

  setupForm() {
    this.shareOnRouteToCustom = document.querySelector("#shareOnRouteToCustom")
    this.roadToCustomStatus = document.querySelector("#roadToCustomStatus")
  }

  setupNotifications() {
    this.shareOnRouteToCustom.onclick = function(){
      let modal = $('[data-remodal-id=shared]').remodal();
      let emails = $('.input-emails__shared').val();
      let ucargoOrderId = document.querySelector("#ucargoOrderId")
      let shareMyMail = document.querySelector("#checkboxOnRouteToCustom");
      sendMails(emails, shareMyMail.checked, ucargoOrderId)
      modal.close();
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
export class Payment {

  constructor(channel, shareChannel) {
    this.shareChannel = shareChannel
    this.paymentChannel = channel
    this.setupForm()
    this.setupPayment()
  }

  setupForm() {
    this.name = document.querySelector("#holder_name")
    this.amount = document.querySelector("#amount")
    this.email = document.querySelector("#holder_email")
    this.ucargoOrderId = document.querySelector("#ucargoOrderId")
    this.planningId = document.querySelector("#planningId")
    this.bidId = document.querySelector("#bidId")
    this.emailShareImage = document.querySelector("#emailShareImage")
    this.confirmModal = $('[data-remodal-id=payment]').remodal();
    this.process_modal = $('[data-remodal-id=process-payment]').remodal();
    this.errorModal = $('[data-remodal-id=errorReporter]').remodal();
    this.shareRemodal = $('[data-remodal-id=emailShare]').remodal();
    this.sharePayment = document.querySelector("#sharePayment")
  }

  setupPayment() {
    OpenPay.setId('ml5gfxvc4swuurvsdqdk');
    OpenPay.setApiKey('pk_74604106c70f480da9691314538ca151');
    OpenPay.setSandboxMode(true);
    var deviceSessionId = OpenPay.deviceData.setup("payment-form", "deviceIdHiddenFieldName");
    var self = this;
    var sharingPayment = false

    emailShareImage.onclick = function(){
      sharingPayment = true
      self.confirmModal.close();
    };

    sharePayment.onclick = function(){
      let emails = $('.input-emails__shared').val();
      let ucargoOrderId = document.querySelector("#ucargoOrderId")
      let shareMyMail = document.querySelector("#checkboxShareInvoice");
      sendMails(emails, shareMyMail.checked, ucargoOrderId)
      self.shareRemodal.close();
    };

    function sendMails(emails, sendToMe, orderId) {
      let payload = {emails: emails,
                   sendToMe: sendToMe,
                    orderId: orderId.value,
                     userId: window.userId}
      self.shareChannel.push("shareInvoice", {body: payload}, 50000)
            .receive("ok", (msg) => "sent")
            .receive("error", (reasons) => console.log("create failed", reasons) )
            .receive("timeout", () => console.log("Networking issue...") )
    }

    $('#pay-button').on('click', function(event) {
        event.preventDefault();
        self.process_modal.open();
        $("#pay-button").prop( "disabled", true);
    });

    var sucess_callbak = function(response) {
      var token_id = response.data.id;
      console.log("Get Token Succesfully")
      console.log(self.name)
      console.log(self.amount)
      let payload = {token: token_id,
            deviceSessionId: deviceSessionId,
                      name: self.name.value,
                planningId: self.planningId.value,
                     bidId: self.bidId.value,
            ucargoOrderId : self.ucargoOrderId.value,
                    amount: self.amount.value,
                     email: self.email.value}
      self.paymentChannel.push("apply_charge", {body: payload}, 50000)
        .receive("ok", (msg) => showResults(msg))
        .receive("error", (reasons) => console.log("create failed", reasons) )
        .receive("timeout", () => console.log("Networking issue...") )
    };

    $(document).on('closing', '.remodal', function (e) {
      if (e.target.id === 'process-payment') {
        console.log('Process modal is closing' + (e.reason ? ', reason: ' + e.reason : ''));
      } else if (e.target.id === 'payment' && sharingPayment)  {
        console.log('Payment modal is closing' + (e.reason ? ', reason: ' + e.reason : ''));
        self.shareRemodal.open();
      } else if (e.target.id === 'paymentEmailShare' && sharingPayment)  {
        console.log('Share email modal is closing' + (e.reason ? ', reason: ' + e.reason : ''));
        self.confirmModal.open();
      } else if (e.target.id === 'payment')  {
        console.log('Payment modal is closing' + (e.reason ? ', reason: ' + e.reason : ''));
        window.location.href = '/assignments/plannings'
      }
    });

    function showResults(msg) {
      self.confirmModal.open();
      $("#pay-button").prop("disabled", false);
    }

    $(document).on('opened', '.remodal', function (e) {
      console.log('Modal is opened');
      if (e.target.id === 'process-payment') {
        OpenPay.token.extractFormAndCreate('payment-form', sucess_callbak, error_callbak);
      }
    });

    var error_callbak = function(response) {
      console.log("Error on payment");
      console.log(self.process_modal);
      self.process_modal.close();
      var desc = response.data.description != undefined ? response.data.description : response.message;
      self.errorModal.open();
      let errorLabel = document.querySelector("#errorLabel")
      errorLabel.innerHTML = desc
      //alert("ERROR [" + response.status + "] " + desc);
      $("#pay-button").prop("disabled", false);
    };
  }
}
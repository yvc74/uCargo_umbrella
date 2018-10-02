// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect()

let assigmentchannel = socket.channel(`assigment:${window.userId}`, {})
assigmentchannel.join()
  .receive("ok", resp => { console.log("Joined successfully to assigments", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("select:updates", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

let paymentChannel = socket.channel("payment:charge", {})
paymentChannel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

class Payment {

  setupPayment(){
    let path = window.location.pathname
    if (path.includes("payment_detail")) {
      let name = document.querySelector("#holder_name")
      let amount = document.querySelector("#amount")
      let email = document.querySelector("#holder_email")
      let ucargoOrderId = document.querySelector("#ucargoOrderId")
      let planningId = document.querySelector("#planningId")
      let bidId = document.querySelector("#bidId")
      var inst = $('[data-remodal-id=payment]').remodal();
      console.log(inst)
      OpenPay.setId('ml5gfxvc4swuurvsdqdk');
      OpenPay.setApiKey('pk_74604106c70f480da9691314538ca151');
      OpenPay.setSandboxMode(true);
      //Se genera el id de dispositivo
      var deviceSessionId = OpenPay.deviceData.setup("payment-form", "deviceIdHiddenFieldName");

      $('#pay-button').on('click', function(event) {
          event.preventDefault();
          $("#pay-button").prop( "disabled", true);
          OpenPay.token.extractFormAndCreate('payment-form', sucess_callbak, error_callbak);
      });

      var sucess_callbak = function(response) {
        var token_id = response.data.id;
        console.log("Get Token Succesfully")
        console.log(name)
        console.log(amount)
        let payload = {token: token_id,
             deviceSessionId: deviceSessionId,
                        name: name.value,
                  planningId: planningId.value,
                       bidId: bidId.value,
              ucargoOrderId : ucargoOrderId.value,
                      amount: amount.value,
                       email: email.value}
        paymentChannel.push("apply_charge", {body: payload}, 10000)
          .receive("ok", (msg) => showResults(msg))
          .receive("error", (reasons) => console.log("create failed", reasons) )
          .receive("timeout", () => console.log("Networking issue...") )
      };

      $(document).on('closing', '.remodal', function (e) {
        console.log('Modal is closing' + (e.reason ? ', reason: ' + e.reason : ''));
        window.location.href = '/assignments/plannings'
      });

      function showResults(msg) {
        inst.open();
        $("#pay-button").prop("disabled", false);
      }

      var error_callbak = function(response) {
          var desc = response.data.description != undefined ? response.data.description : response.message;
          alert("ERROR [" + response.status + "] " + desc);
          $("#pay-button").prop("disabled", false);
      };
    }
  }
}



$('#planning_order_delivery_state').on('select2:select', function (e) {
    console.log(e.params.data.id);
    channel.push("update_state_combo", {body: e.params.data.id}, 10000)
         .receive("ok", (msg) => update_delivery_city_combo(msg))
         .receive("error", (reasons) => console.log("create failed", reasons) )
         .receive("timeout", () => console.log("Networking issue...") )
  });

$('#planning_order_custom_state').on('select2:select', function (e) {
    console.log(e.params.data.id);
    channel.push("update_state_combo", {body: e.params.data.id}, 10000)
         .receive("ok", (msg) => update_custom_city_combo(msg))
         .receive("error", (reasons) => console.log("create failed", reasons) )
         .receive("timeout", () => console.log("Networking issue...") )
  });

$('#planning_order_pickup_state').on('select2:select', function (e) {
  console.log(e.params.data.id);
  channel.push("update_state_combo", {body: e.params.data.id}, 10000)
       .receive("ok", (msg) => update_pickup_city_combo(msg))
       .receive("error", (reasons) => console.log("create failed", reasons) )
       .receive("timeout", () => console.log("Networking issue...") )
});

$('#planning_order_delivery_city').on('select2:select', function (e) {
  console.log(e.params.data.id);
  channel.push("update_city_combo", {body: e.params.data.id}, 10000)
       .receive("ok", (msg) => update_delivery_neighborhood_combo(msg))
       .receive("error", (reasons) => console.log("create failed", reasons) )
       .receive("timeout", () => console.log("Networking issue...") )
});

$('#planning_order_pickup_city').on('select2:select', function (e) {
  console.log(e.params.data.id);
  channel.push("update_city_combo", {body: e.params.data.id}, 10000)
       .receive("ok", (msg) => update_pickup_neighborhood_combo(msg))
       .receive("error", (reasons) => console.log("create failed", reasons) )
       .receive("timeout", () => console.log("Networking issue...") )
});

$('#planning_order_custom_city').on('select2:select', function (e) {
  console.log(e.params.data.id);
  channel.push("update_city_combo", {body: e.params.data.id}, 10000)
       .receive("ok", (msg) => update_custom_neighborhood_combo(msg))
       .receive("error", (reasons) => console.log("create failed", reasons) )
       .receive("timeout", () => console.log("Networking issue...") )
});

function update_delivery_city_combo(msg) {
  var $combo = $('#planning_order_delivery_city').select2();
  $combo.empty();
  $combo.select2({
    minimumResultsForSearch: -1,
    data: msg.data
  })
}

function update_custom_city_combo(msg) {
  var $combo = $('#planning_order_custom_city').select2();
  $combo.empty();
  $combo.select2({
    minimumResultsForSearch: -1,
    data: msg.data
  })
}

function update_pickup_city_combo(msg) {
  var $combo = $('#planning_order_pickup_city').select2();
  $combo.empty();
  $combo.select2({
    minimumResultsForSearch: -1,
    data: msg.data
  })
}

function update_delivery_neighborhood_combo(msg) {
  var $combo = $('#planning_order_delivery_delegation').select2();
  $combo.empty();
  $combo.select2({
    minimumResultsForSearch: -1,
    data: msg.data
  })
}

function update_pickup_neighborhood_combo(msg) {
  var $combo = $('#planning_order_pickup_delegation').select2();
  $combo.empty();
  $combo.select2({
    minimumResultsForSearch: -1,
    data: msg.data
  })
}

function update_custom_neighborhood_combo(msg) {
  var $combo = $('#planning_order_custom_delegation').select2();
  $combo.empty();
  $combo.select2({
    minimumResultsForSearch: -1,
    data: msg.data
  })
}

let map = document.querySelector("#map")
if (map != null) {
  let roadToCustomStatus = document.querySelector("#roadToCustomStatus")

  map = new GMaps({
    div: '.ship-map',
    lat: 19.3204969,
    lng: -99.2840411,
    zoom: 6
  });

  map.addMarker({
    lat: customLatitude,
    lng: customLongitude,
    title: 'Aduanda Veracruz',
    click: function(e) {
      alert('Dirección de Destino');
    }
  });
  var image = {
    url: 'https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png',
    // This marker is 20 pixels wide by 32 pixels high.
    size: new google.maps.Size(20, 32),
    // The origin for this image is (0, 0).
    origin: new google.maps.Point(0, 0),
    // The anchor for this image is the base of the flagpole at (0, 32).
    anchor: new google.maps.Point(0, 32)
  };

  map.addMarker({
    lat: deliveryLatitude,
    lng: deliveryLongitude,
    title: 'Destino',
    click: function(e) {
      alert('Dirección de Entrega');
    }
  });

  var truck = map.addMarker({
    lat: 19.3775314,
    lng: -99.047558,
    icon: image,
    title: 'Truck',
  });

  assigmentchannel.on("updateOrderStatus", payload => {
    console.log(payload)
    console.log(roadToCustomStatus)
    roadToCustomStatus.className = "order-road__semaphore active"
    truck.setPosition( new google.maps.LatLng( 18.8575121, -99.1599174));
    map.panTo( new google.maps.LatLng(18.8575121, -99.1599174));
  })

  map.drawRoute({
    origin: [customLatitude, customLongitude],
    destination: [deliveryLatitude, deliveryLongitude],
    travelMode: 'driving',
    strokeColor: '#131540',
    strokeOpacity: 0.6,
    strokeWeight: 6
  });
}

let payment = new Payment
payment.setupPayment()
export default socket

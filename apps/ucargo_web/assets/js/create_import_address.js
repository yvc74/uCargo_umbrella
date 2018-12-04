export class CreateImportAddress {
  constructor(addressChannel) {
    this.addressChannel = addressChannel
    this.streetTextField = document.querySelector("#planning_order_delivery_street")
    this.extNumberTextField = document.querySelector("#planning_order_delivery_ext")
    this.setupEditTextContent()
    this.setupMap()
  }

  setupEditTextContent() {
    var self = this;
    $('#planning_order_delivery_responsible').on('click', function(event) {
      console.log(self.streetTextField.value)
      self.sendAddressToGeocoding(self.streetTextField.value + " " + "#" + self.extNumberTextField.value)
    });
  }

  sendAddressToGeocoding(address) {
    this.addressChannel.push("geocode_address", {body: address}, 10000)
       .receive("ok", (msg) => this.updateMap(msg))
       .receive("error", (reasons) => console.log("create failed", reasons) )
       .receive("timeout", () => console.log("Networking issue...") )
  }

  updateMap(msg) {
    let location = msg.data
    this.addDestinationMarker(location)
    this.drawRoute({lat: 19.1611614, long: -96.2052841}, location)
  }

  setupMap() {
    this.map = new GMaps({
      div: '.ship-map',
      lat: 19.3204969,
      lng: -99.2840411,
      zoom: 6
    });

    this.map.addMarker({
      lat: 19.1611614,
      lng: -96.2052841,
      title: 'Aduanda Veracruz',
      click: function(e) {
        alert('Dirección de Origen');
      }
    });
  }

  addDestinationMarker(location) {
    this.map.addMarker({
      lat: location.lat,
      lng: location.long,
      title: 'Destino',
      click: function(e) {
        alert('Dirección de Entrega');
      }
    });
  }

  drawRoute(origin, destination) {
    this.map.drawRoute({
      origin: [origin.lat, origin.long],
      destination: [destination.lat, destination.long],
      travelMode: 'driving',
      strokeColor: '#131540',
      strokeOpacity: 0.6,
      strokeWeight: 6
    });
  }
}
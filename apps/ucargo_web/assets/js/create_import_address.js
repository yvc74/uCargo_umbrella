export class CreateImportAddress {
  constructor(addressChannel) {
    this.addressChannel = addressChannel
    this.streetTextField = document.querySelector("#planning_order_delivery_street")
    this.extNumberTextField = document.querySelector("#planning_order_delivery_ext")
    this.planning_order_delivery_latitude = document.querySelector("#planning_order_delivery_latitude")
    this.planning_order_delivery_longitude = document.querySelector("#planning_order_delivery_longitude")
    this.setupEditTextContent()
    this.setupMap()
  }

  setupEditTextContent() {
    var self = this;
    $('#planning_order_delivery_responsible').on('click', function(event) {
      var state_combo = $('#planning_order_delivery_state').select2();
      var state = state_combo.find(':selected').text();
      var city_combo = $('#planning_order_delivery_city').select2();
      var city = city_combo.find(':selected').text();
      var delegation_combo = $('#planning_order_delivery_delegation').select2();
      var delegation = delegation_combo.find(':selected').text();
      self.sendAddressToGeocoding(self.streetTextField.value + " " + "#" +
                                  self.extNumberTextField.value + " " +
                                  state + " " +
                                  city + " " +
                                  delegation)
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
    this.planning_order_delivery_latitude.value =  `${location.lat}`
    this.planning_order_delivery_longitude.value = `${location.long}`
    this.removeMarkers()
    this.addOriginMarker("origin")
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

    this.addOriginMarker("origin")
  }

  removeMarkers() {
    this.origin_marker.setMap(null);
    if (this.destination_marker != null) {
      this.destination_marker.setMap(null);
    }
    this.map.cleanRoute();
  }

  addOriginMarker(_location) {
    this.origin_marker = this.map.addMarker({
      lat: 19.1611614,
      lng: -96.2052841,
      title: 'Aduanda Veracruz',
      click: function(e) {
        alert('Dirección de Origen');
      }
    });
  }

  addDestinationMarker(location) {
    this.destination_marker = this.map.addMarker({
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
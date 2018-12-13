export class CreateExportAddress {
  constructor(addressChannel) {
    this.addressChannel = addressChannel
    this.streetPickUpTextField = document.querySelector("#planning_order_pickup_street")
    this.planning_order_custom_street = document.querySelector("#planning_order_custom_street")
    this.extNumberPickUpTextField = document.querySelector("#planning_order_pickup_ext")
    this.extNumberTextField = document.querySelector("#planning_order_delivery_ext")
    this.planning_order_custom_ext = document.querySelector("#planning_order_custom_ext")

    this.planning_order_custom_latitude = document.querySelector("#planning_order_custom_latitude")
    this.planning_order_custom_longitude = document.querySelector("#planning_order_custom_longitude")

    this.planning_order_pickup_latitude = document.querySelector("#planning_order_pickup_latitude")
    this.planning_order_pickup_longitude = document.querySelector("#planning_order_pickup_longitude")
    this.intermediate_location = {lat: 19.1611614, long: -96.2052841}
    this.setupEditTextContent()
    this.setupPickUpEditTextContent()
    this.setupMap()
  }

  setupPickUpEditTextContent() {
    var self = this;
    $('#planning_order_pickup_responsible').on('click', function(event) {
      console.log(self.streetPickUpTextField.value)
      var state_combo = $('#planning_order_pickup_state').select2();
      var state = state_combo.find(':selected').text();
      var city_combo = $('#planning_order_pickup_city').select2();
      var city = city_combo.find(':selected').text();
      var delegation_combo = $('#planning_order_pickup_delegation').select2();
      var delegation = delegation_combo.find(':selected').text();
      self.sendPickUpAddressToGeocoding(self.streetPickUpTextField.value + " " + "#" +
                                        self.extNumberPickUpTextField.value + " " +
                                        state + " " +
                                        city + " " +
                                        delegation)
    });
  }

  setupEditTextContent() {
    var self = this;
    $('#planning_order_custom_responsible').on('click', function(event) {
      var state_combo = $('#planning_order_custom_state').select2();
      var state = state_combo.find(':selected').text();
      var city_combo = $('#planning_order_custom_city').select2();
      var city = city_combo.find(':selected').text();
      var delegation_combo = $('#planning_order_custom_delegation').select2();
      var delegation = delegation_combo.find(':selected').text();
      self.sendAddressToGeocoding(self.planning_order_custom_street.value + " " + "#" +
                                  self.planning_order_custom_ext.value + " " +
                                  state + " " +
                                  city + " " +
                                  delegation)
    });
  }

  sendPickUpAddressToGeocoding(address) {
    this.addressChannel.push("geocode_address", {body: address}, 10000)
       .receive("ok", (msg) => this.updatePickUpMap(msg))
       .receive("error", (reasons) => console.log("create failed", reasons) )
       .receive("timeout", () => console.log("Networking issue...") )
  }

  sendAddressToGeocoding(address) {
    this.addressChannel.push("geocode_address", {body: address}, 10000)
       .receive("ok", (msg) => this.updateMap(msg))
       .receive("error", (reasons) => console.log("create failed", reasons) )
       .receive("timeout", () => console.log("Networking issue...") )
  }

  updatePickUpMap(msg) {
    let location = msg.data
    this.planning_order_pickup_latitude.value =  `${location.lat}`
    this.planning_order_pickup_longitude.value = `${location.long}`
    this.addDestinationMarker(location)
    this.intermediate_location = location
    this.drawRoute({lat: 19.1611614, long: -96.2052841}, location)
  }

  updateMap(msg) {
    let location = msg.data
    this.planning_order_custom_latitude.value =  `${location.lat}`
    this.planning_order_custom_longitude.value = `${location.long}`
    this.addDestinationMarker(location)
    this.drawRoute(this.intermediate_location, location)
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
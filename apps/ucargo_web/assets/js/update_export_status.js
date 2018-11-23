export class ExportUpdateStatus {

  constructor(assigmentchannel) {
    this.assigmentchannel = assigmentchannel
    this.storeMerchandiseStatus = document.querySelector("#storeMerchandiseStatus")
    this.shareMerchStoredActions = document.querySelector("#shareMerchStoredActions")
    this.lockPictureStatus = document.querySelector("#lockPictureStatus")
    this.lockPictureStatusActions = document.querySelector("#lockPictureStatusActions")
    this.onRouteStatus = document.querySelector("#onRouteStatus")
    this.onRouteActions = document.querySelector("#onRouteActions")
    this.onCustomArrivalStatus = document.querySelector("#onCustomArrivalStatus")
    this.onCustomArrivalActions = document.querySelector("#onCustomArrivalActions")


    // this.semaphoreLightStatus = document.querySelector("#semaphoreLightStatus")
    // this.semaphoreLightActions = document.querySelector("#semaphoreLightActions")
    // this.lockPictureStatus = document.querySelector("#lockPictureStatus")
    // this.pictureLockActions = document.querySelector("#pictureLockActions")
    // this.storeMerchandiseStatus = document.querySelector("#storeMerchandiseStatus")
    // this.storeMerchandiseActions = document.querySelector("#storeMerchandiseActions")
    
    // this.arrivalStatus = document.querySelector("#arrivalStatus")
    // this.arrivalActions = document.querySelector("#arrivalActions")
    // this.deliveredToClient = document.querySelector("#deliveredToClient")
    // this.deliveredActions = document.querySelector("#deliveredActions")
    this.setupMap()
    this.setupUpdates()
  }

  setupUpdates() {
    this.assigmentchannel.on("updateOrderStatus", payload => {
      let event = payload.body
      switch(event.name) {
        case "Collect":
          this.storeMerchandiseStatus.className = "order-road__semaphore active";
          this.shareMerchStoredActions.style.visibility = "visible";
          break;
        case "ReportLock":
          this.lockPictureStatus.className = "order-road__semaphore active";
          this.lockPictureStatusActions.style.visibility = "visible";
          break;
        case "BeginCustom":
          this.onRouteStatus.className = "order-road__semaphore active";
          this.onRouteActions.style.visibility = "visible";
          break;
        case "ReportGreen":
          this.onCustomArrivalStatus.className = "order-road__semaphore active"
          this.onCustomArrivalActions.style.visibility = "visible";
          break;
        case "BeginRoute":
          this.onRouteStatus.className = "order-road__semaphore active"
          this.onRouteActions.style.visibility = "visible";
          break;
        case "ReportLocation":
          this.onRouteStatus.className = "order-road__semaphore active"
          let lat = event.latitude
          let long = event.longitude
          this.truck.setPosition( new google.maps.LatLng( lat, long));
          this.map.panTo( new google.maps.LatLng(lat, long));
          this.map.setZoom(17);
          break;
        case "ReportSign":
          this.arrivalStatus.className = "order-road__semaphore active";
          this.arrivalActions.style.visibility = "visible";
          this.deliveredToClient.className = "order-road__semaphore active"
          this.deliveredActions.style.visibility = "visible";
          break;
        default:
          console.log(event)
      }
    })
  }

  setupMap() {
    this.map = new GMaps({
      div: '.ship-map',
      lat: 19.3204969,
      lng: -99.2840411,
      zoom: 6
    });

    this.map.addMarker({
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

    this.map.addMarker({
      lat: deliveryLatitude,
      lng: deliveryLongitude,
      title: 'Destino',
      click: function(e) {
        alert('Dirección de Entrega');
      }
    });

    this.truck = this.map.addMarker({
      lat: 19.3775314,
      lng: -99.047558,
      icon: image,
      title: 'Truck',
    });

    this.map.drawRoute({
      origin: [customLatitude, customLongitude],
      destination: [deliveryLatitude, deliveryLongitude],
      travelMode: 'driving',
      strokeColor: '#131540',
      strokeOpacity: 0.6,
      strokeWeight: 6
    });
  }
}
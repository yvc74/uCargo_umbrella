import {SetupCalendar} from "./setupcalendar.js"
import {SetupDeliveryCalendar} from "./setupdeliverycalendar.js"

class Launch {
  constructor() {
    this.setupcalendar = new SetupCalendar
    this.setupcalendar.configure()
    this.setuppickupcalendar = new SetupDeliveryCalendar
    this.setuppickupcalendar.configure()
    
  }
}

let launch = new Launch



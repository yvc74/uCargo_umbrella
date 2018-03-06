import {SetupCalendar} from "./setupcalendar.js"

class Launch {
  constructor() {
    this.setupcalendar = new SetupCalendar
    this.setupcalendar.configure()
  }
}

let launch = new Launch



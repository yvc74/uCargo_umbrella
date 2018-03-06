import {jsCalendar} from "./jsCalendar"

export class SetupCalendar {
  
  configure() {
    var elements = {
    // Input element
    input : document.getElementById("planning_order_pickup_schedule"),
    // Calendar element
    calendar : document.getElementById("date-picker-calendar"),
    // Close btn
    close : document.createElement('close')
    }
  
    // Hide calendar element
    elements.calendar.style.display = "none";
    elements.calendar.style.position = "absolute";

    // Create the calendar
    var calendar = jsCalendar.new(elements.calendar)


    // Add close button
    elements.close.textContent = "×";
    elements.close.style.position = "absolute";
    elements.close.style.top = "-2px";
    elements.close.style.right = "-2px";
    elements.close.style.height = "24px";
    elements.close.style.width = "24px";
    elements.close.style.textAlign = "center";
    elements.close.style.lineHeight = "24px";
    elements.close.style.backgroundColor = "#F44336";
    elements.close.style.borderRadius = "12px";
    elements.close.style.boxShadow = "0px 0px 2px #000000";
    elements.close.style.cursor = "pointer";
    elements.calendar.appendChild(elements.close);

    // Add events
    calendar.onDateClick(function(event, date){
      // Set input date
      elements.input.value = jsCalendar.tools.dateToString(date, "DD/MM/YYYY", "en");
      // Update calendar date
      calendar.set(date);
      // Hide calendar
      elements.calendar.style.display = "none";
    });

    // Open calendar
    elements.input.addEventListener("focus", function(){
      elements.calendar.style.top = elements.input.offsetTop + elements.input.offsetHeight + "px";
      elements.calendar.style.left = elements.input.offsetLeft + "px";
      elements.calendar.style.display = "block";
    }, true);
    // Close calendar
    elements.input.addEventListener("change", function(){
      elements.calendar.style.display = "none";
    }, true);
    elements.close.addEventListener("click", function(){
      elements.calendar.style.display = "none";
    }, true);
  }
  
}
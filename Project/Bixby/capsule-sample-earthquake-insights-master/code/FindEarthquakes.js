var config = require("config")
var console = require("console")
var http = require("http")
var dates = require("dates")

module.exports.function = function FindEarthquakes (dateTimeExpression, searchRegion, minMagnitude, maxMagnitude, approxMagnitude) {

  var starttime;
  var endtime;

  if (dateTimeExpression) {
    var whenStart;
    var whenEnd;
    if (dateTimeExpression.date) {
      // Add time endpoints using the beginning and end of the day
      whenStart = dates.ZonedDateTime.fromDate(dateTimeExpression.date);
      whenEnd = whenStart.withHour(23).withMinute(59).withSecond(59);
    }
    else if (dateTimeExpression.dateInterval) {
      // Add time endpoints using start time of first day and end time of last day.
      whenStart = dates.ZonedDateTime.of(
        dateTimeExpression.dateInterval.start.year,
        dateTimeExpression.dateInterval.start.month,
        dateTimeExpression.dateInterval.start.day);
      whenEnd = dates.ZonedDateTime.of(
        dateTimeExpression.dateInterval.end.year,
        dateTimeExpression.dateInterval.end.month,
        dateTimeExpression.dateInterval.end.day,
        23, 59, 59);
    }
    else if (dateTimeExpression.dateTime) {
      // Add time endpoints where start time and end time represent a 30-min window around the specific datetime
      whenStart = dates.ZonedDateTime.of(
        dateTimeExpression.dateTime.date.year,
        dateTimeExpression.dateTime.date.month,
        dateTimeExpression.dateTime.date.day,
        dateTimeExpression.dateTime.time.timezone.toString(),
        dateTimeExpression.dateTime.time.hour,
        dateTimeExpression.dateTime.time.minute,
        dateTimeExpression.dateTime.time.second);
      whenEnd = dates.ZonedDateTime.of(
        dateTimeExpression.dateTime.date.year,
        dateTimeExpression.dateTime.date.month,
        dateTimeExpression.dateTime.date.day,
        dateTimeExpression.dateTime.time.timezone.toString(),
        dateTimeExpression.dateTime.time.hour,
        dateTimeExpression.dateTime.time.minute,
        dateTimeExpression.dateTime.time.second);

      whenStart = whenStart.minusMinutes(15)
      whenEnd = whenEnd.plusMinutes(15)
    }
    else if (dateTimeExpression.dateTimeInterval) {
      // Use the specified datetime interval
      whenStart = dates.ZonedDateTime.of(
        dateTimeExpression.dateTimeInterval.start.time.timezone.toString(),
        dateTimeExpression.dateTimeInterval.start.date.year,
        dateTimeExpression.dateTimeInterval.start.date.month,
        dateTimeExpression.dateTimeInterval.start.date.day,
        dateTimeExpression.dateTimeInterval.start.time.hour,
        dateTimeExpression.dateTimeInterval.start.time.minute,
        dateTimeExpression.dateTimeInterval.start.time.second);
      whenEnd = dates.ZonedDateTime.of(
        dateTimeExpression.dateTimeInterval.end.time.timezone.toString(), 
        dateTimeExpression.dateTimeInterval.end.date.year,
        dateTimeExpression.dateTimeInterval.end.date.month,
        dateTimeExpression.dateTimeInterval.end.date.day,
        dateTimeExpression.dateTimeInterval.end.time.hour,
        dateTimeExpression.dateTimeInterval.end.time.minute,
        dateTimeExpression.dateTimeInterval.end.time.second);
    }
    starttime = whenStart.toIsoString();
    endtime = whenEnd.toIsoString();
  }

  var url = "https://earthquake.usgs.gov/fdsnws/event/1/query"

  var args = {
    format: "geojson",
    limit: 100,
    orderby: "magnitude"
  };


  if (dateTimeExpression) {
    args.starttime = starttime;
    args.endtime = endtime

  }

  if (searchRegion) {
    if (searchRegion.bbox.length != 0) {
      var minlong = searchRegion.bbox[0]
      var minlat = searchRegion.bbox[1]
      var maxlong = searchRegion.bbox[2]
      var maxlat = searchRegion.bbox[3]

      args.minlongitude = minlong;
      args.minlatitude = minlat;
      args.maxlongitude = maxlong;
      args.maxlatitude = maxlat;
    }
    else if (searchRegion.pointRadius) {
      var lat = searchRegion.pointRadius.centroid.latitude
      var long = searchRegion.pointRadius.centroid.longitude
      var rad = searchRegion.pointRadius.radius.magnitude * 1.609

      args.latitude = lat;
      args.longitude = long;
      args.maxradiuskm = rad;
    }
  }
  if (minMagnitude) {
    args.minmagnitude = minMagnitude
  }
  if (maxMagnitude) {
    args.maxmagnitude = maxMagnitude
  }
  if (approxMagnitude) {
    args.minmagnitude = approxMagnitude - 0.25
    args.maxmagnitude = approxMagnitude + 0.25
  }

  var ret = []
  try {
    var str = http.getUrl(url, { query: args} ) 
    var res = JSON.parse(str)

    for(var i=0; i<res.features.length; i++) {
      var title = res.features[i].properties.title;
      var mg = res.features[i].properties.mag;
      var geo = { latitude: res.features[i].geometry.coordinates[1], longitude:res.features[i].geometry.coordinates[0] }
      var zonedDT = new dates.ZonedDateTime(geo, res.features[i].properties.time)

      var dt = { 
        date: {
          year: zonedDT.getYear(),
          month: zonedDT.getMonth(),
          day: zonedDT.getDay()
        }, 
        time: {
          hour: zonedDT.getHour(),
          minute: zonedDT.getMinute(),
          second: zonedDT.getSecond(),
          timezone: zonedDT.getTimeZoneId()
        }
      } 

      ret.push({title: title, dateTime: dt, location: geo, magnitude: mg })
    }
  }
  catch(err) {
    console.log("ERR: " + JSON.stringify(err));
  }

  return ret
}

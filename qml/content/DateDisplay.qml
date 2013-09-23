/*!
 * \datedisplay.qml
 * \brief file datedisplay.qml
 *
 * Copyright of Nomovok Ltd. All rights reserved.
 *
 * Contact: info@nomovok.com
 *
 * \author Santtu Mansikkamaa <santtu.mansikkamaa@nomovok.com> 2013.
 *
 * any other legal text to be defined later
 *
 * WallClock implementation copied from Clock.qml
 */

import QtQuick 2.0
import org.nemomobile.time 1.0
import "clockHelper.js" as CH

Item {
    id: dateDisplay
    width: 600
    height: 180

    property int minutes
    property int hours
    property int day
    property int month
    property int year
    property var dateTime

    //property bool night: false

    function update() {
        var time = wallClock.time;
        minutes = time.getMinutes();
        hours = time.getHours();
        day = time.getDate();
        month = time.getMonth() + 1;
        year = time.getFullYear();
        dateTime = new Date(year, month-1, day, hours, minutes, "00");
    }

    Component.onCompleted: update()

    WallClock {
        id: wallClock
        enabled: true
        updateFrequency: WallClock.Second //TODO: minute when in background
        onTimeChanged:  dateDisplay.update()
    }

    Text {
        id: timeField
        text: CH.twoDigits(hours)+":"+CH.twoDigits(minutes);
        color: "#FF292929"
        font.pixelSize: 140
        font.family: "Helvetica"
        anchors.left: parent.left
        anchors.top: parent.top
    }

    Text {
        id: dateField
        text: Qt.formatDateTime(dateTime, "ddd d. MMMM yyyy");
        color: timeField.color
        font.family: "Helvetica"
        font.pixelSize: 30
        anchors.left: timeField.left
        anchors.leftMargin: 20
        anchors.bottom: parent.bottom
    }
}

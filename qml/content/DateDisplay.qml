/***************************************************************************
**
** Copyright (c) 2013, Santtu Mansikkamaa <santtu.mansikkamaa@nomovok.com>
** Contact: info@nomovok.com
** All rights reserved.
**
** $QT_BEGIN_LICENSE:BSD$
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are met:
**
** 1. Redistributions of source code must retain the above copyright notice, this
**    list of conditions and the following disclaimer.
** 2. Redistributions in binary form must reproduce the above copyright notice,
**    this list of conditions and the following disclaimer in the documentation
**    and/or other materials provided with the distribution.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
** ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
** WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
** DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
** ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
** LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
** ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
** SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
** The views and conclusions contained in the software and documentation are those
** of the authors and should not be interpreted as representing official policies,
** either expressed or implied, of the FreeBSD Project.
** $QT_END_LICENSE$
**
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

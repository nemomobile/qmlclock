/****************************************************************************
**
** Copyright (C) 2013 Robin Burchell <robin+mer@viroteck.net>
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 1.0
import org.nemomobile.time 1.0

Item {
    id: clock
    width: background.width
    height: background.height

    property int hours
    property int minutes
    property int seconds 
    property bool night: false

    WallClock {
        id: wallClock
        enabled: true
        updateFrequency: WallClock.Second /* TODO: change to minute when backgrounded */

        onTimeChanged: {
            hours = time.getHours()
            night = (hours < 7 || hours > 19)
            minutes = time.getMinutes()
            seconds = time.getUTCSeconds();
        }
    }

    Image { id: background; source: "clock.png"; visible: clock.night == false }
    Image { source: "clock-night.png"; visible: clock.night == true }

    Image {
        id: hourhand
        source: "hour.png"
        smooth: true
        x: (background.width/2) - (width/2)
        y: ((background.height/2) - height + 16)
        transform: Rotation {
            id: hourRotation
            origin.x: hourhand.width/2
            origin.y: (hourhand.height - 16)
            angle: (clock.hours * 30) + (clock.minutes * 0.5)
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }

    Image {
        id: minutehand
        x: (background.width/2) - (width/2)
        y: ((background.height/2) - height + 14)
        source: "minute.png"
        smooth: true
        transform: Rotation {
            id: minuteRotation
            origin.x: minutehand.width/2
            origin.y: (minutehand.height - 14)
            angle: clock.minutes * 6
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }

    Image {
        id: secondhand
        x: (background.width/2) - (width/2)
        y: ((background.height/2) - height + 14)
        source: "second.png"
        smooth: true
        transform: Rotation {
            id: secondRotation
            origin.x: secondhand.width/2
            origin.y: (secondhand.height - 14)
            angle: clock.seconds * 6
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }

    Image {
        anchors.centerIn: background; source: "center.png"
    }
}

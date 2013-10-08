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
**/

/*
 * This dialog is for testing and demonstration purposes only.
 * This file should not be used. This should be tied with notification framework instead.
 */

import QtQuick 2.0
import com.nokia.meego 2.0

Rectangle {
    id: alarmDialogRoot
    z: 10
    color: "#AA000000"

    property alias alarmName : alarmNameField.text
    property alias alarmTime : alarmTimeField.text
    property var alarmObject

    signal alarmDisableClicked
    signal alarmSnoozeClicked

    MouseArea {
        anchors.fill: parent
        z: 15
    }

    Rectangle {
        width: 500
        height: 250
        anchors.centerIn: parent
        z: 20

        color: "black"

        Text {
            id: alarmNameField
            color: "orange"
            font.family: "Helvetica"
            font.pixelSize: 40
            anchors {
                left: parent.left
                top: parent.top
            }
        }

        Text {
            id: alarmTimeField
            color: "orange"
            font.family: "Helvetica"
            font.pixelSize: 40
            anchors {
                left: parent.left
                top: alarmNameField.bottom
                topMargin: 10
            }
        }

        Button {
            id: alarmDisable
            width: 150
            height: 51
            text: "OK"
            font.family: "Helvetica"
            anchors {
                left: parent.left
                top: alarmTimeField.bottom
                topMargin: 10
            }
            onClicked: {
                alarmDisableClicked();
                alarmDialogRoot.visible = false;
            }
        }

        Button {
            id: alarmSnooze
            width: 150
            height: 51
            text: "Snooze"
            font.family: "Helvetica"
            anchors {
                left: parent.left
                top: alarmDisable.bottom
                topMargin: 10
            }
            onClicked: {
                alarmSnoozeClicked();
                alarmDialogRoot.visible = false;
            }
        }
    }
}

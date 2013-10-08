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

import QtQuick 2.0
import com.nokia.meego 2.0
import "clockHelper.js" as CH

Repeater {
    id: repeaterRoot
    property bool deletionEnabled: false
    signal editClicked (var alarmObject, var index)
    property bool dummyProperty: false

    delegate: Rectangle {

        height: 200
        width: 400
        color: "#FFD6D6D6"

        Text {
            id: timeField
            text: alarmTime
            anchors {
                bottom: parent.verticalCenter
                left: parent.left
                leftMargin: 60
                margins: 0
            }
            font.family: "Helvetica"
            font.pixelSize: 40
            z: 20
        }

        Text {
            id: nameField
            text: CH.parseAlarmTitle(alarmName);
            anchors {
                top: parent.verticalCenter
                margins: 0
                left: timeField.left
            }
            font.family: "Helvetica"
            font.pixelSize: 40
            z: 20
        }

        Switch {
            id: enableSwitch
            z: 30
            anchors {
                right: parent.right
                rightMargin: 30
                verticalCenter: parent.verticalCenter
            }
            checked: repeaterRoot.deletionEnabled ? model.alarmEnabled : model.alarmEnabled
            onCheckedChanged: {
                alarmObject.enabled = checked;
                alarmObject.save();
            }
        }

        CheckBox {
            id: markDeletion
            z: 30
            visible: deletionEnabled
            checked: (repeaterRoot.dummyProperty ? model.markedForDeletion : model.markedForDeletion)
            onClicked: {
                alarmModel.get(index).markedForDeletion = !alarmModel.get(index).markedForDeletion
                console.log("Mark changed to: "+markedForDeletion);
                repeaterRoot.dummyProperty = !repeaterRoot.dummyProperty;
            }
            anchors {
                left: parent.left
                leftMargin: 20
                verticalCenter: parent.verticalCenter
            }
        }

        MouseArea {
            id: editByClick
            z: 20
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
                right: enableSwitch.left
            }
            onClicked: if (!markDeletion.visible) {
                editClicked(alarmObject, index);
            }
        }

        /*
         *  UI graphics:
         */
        Rectangle {
            id: topLine
            visible: index == 0 ? true : false;
            width: parent.width
            height: 2
            color: "#FF292929"
            anchors.left: parent.left
            anchors.top: parent.top
            z: 20
        }

        Rectangle {
            id: bottomLine
            width: parent.width
            height: 2
            color: "#FF292929"
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            z: 20
        }
    }
}

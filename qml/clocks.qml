/****************************************************************************
**
** Copyright (C) 2013 Robin Burchell <robin+mer@viroteck.net>
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Copyright (C) 2013 Santtu Mansikkamaa <santtu.mansikkamaa@nomovok.com>
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

import QtQuick 2.0
import com.nokia.meego 2.0
import org.nemomobile.alarms 1.0
import "content"
import "content/clockHelper.js" as CH


/* TODO:
 * - Read alarms from the platform.
 * -> Synch alarms with UI and platform and populate list of alarms from timed.
 * - Better tying with theme.
 */

PageStackWindow {
    id: root
    showStatusBar: false

    initialPage: Page {
        id: pageContainer
        property bool populated: false
        z: 1

        DateDisplay {
            id: dateDisplay
            z: 100
            anchors {
                top: parent.top
                topMargin: 50
                left: parent.left
                leftMargin:  40
            }
        }

        Item {
            id: buttonContainer
            z: dateDisplay.z + 100
            width: root.width
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 30
            }

            Button {
                id: buttonNewAlarm
                text: alarmList.deletionEnabled ? "Cancel" : "New";
                width: 150
                height: 51
                onClicked: {
                    if (alarmList.deletionEnabled) {
                        alarmList.deletionEnabled = false
                        CH.clearDeletionMarkers(alarmModel);
                    }
                    else {
                        CH.launchDialog(true, 0, -1, tDialog);
                    }
                }
                anchors {
                    left: parent.horizontalCenter
                    leftMargin: 5
                    bottom: parent.bottom
                }
            }

            Button {
                id: buttonDeleteAlarm
                text: alarmList.deletionEnabled ? "Confirm" : "Delete";
                width: 150
                height: 51
                onClicked: {
                    if(!alarmList.deletionEnabled)
                        alarmList.deletionEnabled = true;
                    else {
                        CH.deleteSelectedItems(alarmModel);
                        alarmList.deletionEnabled = false;
                    }
                }
                anchors {
                    right: buttonNewAlarm.left
                    rightMargin: 10
                    bottom: parent.bottom
                }
            }
        }

        Flickable {
            id: listViewFlickable
            clip: true
            contentHeight: alarmModel.count *  82 + 2
            contentWidth: 400
            boundsBehavior: Flickable.DragOverBounds
            flickableDirection: Flickable.VerticalFlick
            anchors {
                left: parent.left
                leftMargin:  10
                right: parent.right
                rightMargin:  10
                top: dateDisplay.bottom
                bottom: bottomStrip.top
                bottomMargin: 5
            }
            Column {
                AlarmViewRepeater {
                    id: alarmList
                    z: dateDisplay.z - 2
                    onEditClicked: CH.launchDialog(false, alarmObject, index, tDialog);
                    model: AlarmModel {
                        id: alarmModel
                    }
                }
            }
        }

        AlarmTimePickerDialog {
            id: tDialog
            titleText: "Alarm time:"
            acceptButtonText: "Set"
            rejectButtonText: "Cancel"
            anchors.top: parent.top
            visible: false
            z: dateDisplay.z
            onAccepted: {
                if(editingAlarm){
                    alarmModel.remove(editIndexRelay);
                }
                CH.callbackFunction(tDialog, alarmModel, systemAlarmModel);
            }
        }

        AlarmsModel {
            id: systemAlarmModel
            onPopulatedChanged: pageContainer.populated = true
        }

        AlarmHandler {
            id: systemAlarmHandler
            onError: console.log(" +++Error in AlarmHandler: " + message);
            onAlarmReady: {
                console.log(" +++Alarm ready: " + alarm.hour + ":" + alarm.minute + " at " + alarm.title);
                if(pageContainer.populated) {
                    alarmDialog.alarmName = CH.parseAlarmTitle(alarm.title);
                    alarmDialog.alarmTime = CH.twoDigits(alarm.hour) + ":" + CH.twoDigits(alarm.minute);
                    alarmDialog.alarmObject = alarm;
                    alarmDialog.visible = true;
                }
            }
        }

        AlarmDialog {
            id: alarmDialog

            onAlarmSnoozeClicked: alarmObject.snooze();
            visible: false
            anchors.top: parent.top
            anchors.left: parent.left
            width: root.width
            height: root.height
            z: dateDisplay.z + 40
            onAlarmDisableClicked: {
                CH.updateAlarmEnabledStatus(alarmObject, alarmModel);
                alarmObject.dismiss();
            }
        }

        /*
         *   UI elements, purely aesthetic
         */
       Rectangle {
           id: bottomStrip
           color: "#FF292929"
           width: parent.width
           height: 100
           anchors.left: parent.left
           anchors.bottom: parent.bottom
           z: buttonContainer.z - 10
        }

       Rectangle {
           id: topStrip
           color: bottomStrip.color
           width: parent.width
           height: 50
           anchors.top: parent.top
           anchors.left: parent.left
           z: dateDisplay.z
       }

       Text {
           text: "Alarm"
           color: backgroundColor.color
           font.pixelSize: 40
           anchors.top: parent.top
           anchors.topMargin: 10
           anchors.horizontalCenter: topStrip.horizontalCenter
           font.family: "Helvetica"
           z: topStrip.z + 10
       }

       Rectangle {
           id: backgroundColor
           color: "#FFD6D6D6"
           width: parent.width
           height: parent.height
           anchors.top: parent.top
           anchors.left: parent.left
           z: alarmList.z - 100
       }
    }
}

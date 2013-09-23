/*!
 * \AlarmViewRepeater.qml
 * \brief file AlarmViewRepeater.qml
 *
 * Copyright of Nomovok Ltd. All rights reserved.
 *
 * Contact: info@nomovok.com
 *
 * \author Santtu Mansikkamaa <santtu.mansikkamaa@nomovok.com> 2013.
 *
 * any other legal text to be defined later
 */

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

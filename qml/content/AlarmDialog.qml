/*
 * This dialog is for testing and demonstration purposes only.
 * This file should not be used. This should be tied with homescreen and notifications instead.
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

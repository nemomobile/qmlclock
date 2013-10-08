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
 * Edits the given digit to include two digts.
 * Example: 5 -> 05
 */
function twoDigits(x) {
    if(x<10) {
        return "0"+x;
    }
    else {
        return x;
    }
}

/*
 * Parses the title to a bit more nicer format.
 */
function parseAlarmTitle(title) {
    var returnString = "";
    if (title === ""){
        returnString = " ";
    }
    else if (title === "mtwTf") {
        returnString = "Weekdays";
    }
    else if (title === "sS") {
        returnString = "Weekends";
    }
    else if (title === "mtwTfsS") {
        returnString = "Every day";
    }
    else {
        if (title.indexOf("m") >= 0) {
            returnString = "Mon, ";
        }
        if (title.indexOf("t") >= 0) {
            returnString = returnString + "Tue, ";
        }
        if (title.indexOf("w") >= 0) {
            returnString = returnString + "Wed, ";
        }
        if (title.indexOf("T") >= 0) {
            returnString = returnString + "Thu, ";
        }
        if (title.indexOf("f") >= 0) {
            returnString = returnString + "Fri, ";
        }
        if (title.indexOf("s") >= 0 ) {
            returnString = returnString + "Sat, ";
        }
        if (title.indexOf("S") >= 0) {
            returnString = returnString + "Sun";
        }
        if ((returnString.indexOf(", ") >= 0) && (returnString.indexOf("Sun") === -1)) {
            returnString = returnString.slice(0, returnString.length-2);
        }
    }
    return returnString;
}

/*
 * Opens the alarm editing and creation view with the set values
 */
function launchDialog(isNewAlarm, newAlarmObject, editingIndex, tDialog) {
    if (isNewAlarm) {
        tDialog.hour = dateDisplay.hours;
        tDialog.minute = dateDisplay.minutes;
        tDialog.enableMonday    = false;
        tDialog.enableTuesday   = false;
        tDialog.enableWednesday = false;
        tDialog.enableThursday  = false;
        tDialog.enableFriday    = false;
        tDialog.enableSaturday  = false;
        tDialog.enableSunday    = false;
        tDialog.editingAlarm    = false;
    }
    else {
        tDialog.hour = newAlarmObject.hour;
        tDialog.minute = newAlarmObject.minute;
        tDialog.enableMonday    = ( newAlarmObject.daysOfWeek.indexOf("m") >= 0 ? true : false );
        tDialog.enableTuesday   = ( newAlarmObject.daysOfWeek.indexOf("t") >= 0 ? true : false );
        tDialog.enableWednesday = ( newAlarmObject.daysOfWeek.indexOf("w") >= 0 ? true : false );
        tDialog.enableThursday  = ( newAlarmObject.daysOfWeek.indexOf("T") >= 0 ? true : false );
        tDialog.enableFriday    = ( newAlarmObject.daysOfWeek.indexOf("f") >= 0 ? true : false );
        tDialog.enableSaturday  = ( newAlarmObject.daysOfWeek.indexOf("s") >= 0 ? true : false );
        tDialog.enableSunday    = ( newAlarmObject.daysOfWeek.indexOf("S") >= 0 ? true : false );
        tDialog.editingAlarm    = true;
    }
    tDialog.showSeconds = false;
    tDialog.hourMode = DateTime.TwentyFourHours;  //this also could be system setting related
    tDialog.fields = DateTime.Hours | DateTime.Minutes;
    tDialog.visible = true;
    tDialog.editIndexRelay = editingIndex;
    tDialog.open();
}

/*
 * This function parses and saves the given alarm
 */
function callbackFunction(tDialog, alarmModel, systemAlarmModel) {
    var daysString = "";
    if (tDialog.enableMonday) {
        daysString = "m"
    }
    if (tDialog.enableTuesday) {
        daysString = daysString + "t"
    }
    if (tDialog.enableWednesday) {
        daysString = daysString + "w"
    }
    if (tDialog.enableThursday) {
        daysString = daysString + "T"
    }
    if (tDialog.enableFriday) {
        daysString = daysString + "f"
    }
    if (tDialog.enableSaturday) {
        daysString = daysString + "s"
    }
    if (tDialog.enableSunday) {
        daysString = daysString + "S"
    }

    var alarm = systemAlarmModel.createAlarm();
    alarm.hour = tDialog.hour;
    alarm.minute = tDialog.minute;
    alarm.title = daysString;
    alarm.daysOfWeek = daysString;
    alarm.enabled = true;
    alarm.save();
    tDialog.visible = false;

    //Includes this new alarm to visible list
    alarmModel.append(    {"alarmTime": twoDigits(tDialog.hour)+":"+twoDigits(tDialog.minute),
                           "alarmName": daysString,
                           "alarmEnabled": true,
                           "alarmObject": alarm,
                           "markedForDeletion": false});
}



// This function lists all alarms that have gone off, and 'should' have been notified about.
// Can be cleaned
function listAllAlarms(systemAlarmHandler) {
    console.log("-----------Activated-alarms-in-system["+systemAlarmHandler.activeDialogs.length+"]-------------")
    for(var i=0 ; i < systemAlarmHandler.activeDialogs.length ; i++) {
        var pickedAlarm = systemAlarmHandler.activeDialogs[i];
        console.log(i+": "+pickedAlarm.hour+":"+pickedAlarm.minute
                    +" with name '"+pickedAlarm.title+"' and has enabled status of "+pickedAlarm.enabled);
    }
    console.log("--------------------------------------------")
}


/*
 * Deletes all items from alarmModel that have been checked for deletion.
 * AlarmModel is the actual AlarmModel.qml.
 * Alarm is one of the instances AlarmModel contains e.g. AlarmViewRepeater item.
 * AlarmObject is the alarmObject that timed provides.
 */
function deleteSelectedItems(alarmModel) {
    for ( var i = alarmModel.count - 1 ; i >= 0 ; i--) {
        var alarm = alarmModel.get(i);
        if (alarm.markedForDeletion) {
            alarm.alarmObject.deleteAlarm();  //removes from backend (timed)
            alarmModel.remove(i);             //removes form UI
        }
    }
}


/*
 *  Removes markers from deletion selection.
 */
function clearDeletionMarkers(alarmModel) {
    //THIS FEATURES IS NOT WORKING
    console.log("This feature is disabled and doesn't remove checked statuses.")
    return;
    for ( var i = alarmModel.count -1 ; i >= 0 ; i--) {
        alarmModel.get(i).markedForDeletion = false;
    }
}



/*
 * Updates anabled status of the alarm that has been popped.
 * NOTE: If there are two exactly same alarms, there might be a misshap.
 */
function updateAlarmEnabledStatus(alarm, alarmModel) {

    //check is the alarm one shot
    if(alarm.title.length > 0) {
        return;
    }

    //find alarm index
    for(var i = 0; alarmModel.count > i; i++) {
        if (alarmModel.get(i).alarmTime === (+twoDigits(alarm.hour)+":"+twoDigits(alarm.minute))) {
            if (alarmModel.get(i).alarmName === alarm.title) {
                alarmModel.get(i).alarmEnabled = false;
            }
        }
    }
}

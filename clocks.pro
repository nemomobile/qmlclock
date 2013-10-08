TEMPLATE = app
TARGET = qmlclock
QT += qml quick
SOURCES += main.cpp

RESOURCES += \
    res.qrc

target.path = /usr/bin
INSTALLS += target

desktop.path = /usr/share/applications
desktop.files = qmlclock.desktop
INSTALLS += desktop

CONFIG += link_pkgconfig
packagesExist(qdeclarative5-boostable) {
    message("Building with qdeclarative5-boostable support")
    DEFINES += HAS_BOOSTER
    PKGCONFIG += qdeclarative5-boostable
} else {
    warning("qdeclarative5-boostable not available; startup times will be slower")
}

OTHER_FILES += \
    qml/clocks.qml \
    qml/content/DateDisplay.qml \
    qml/content/AlarmTimePickerDialog.qml \
    qml/content/AlarmModel.qml \
    qml/content/AlarmDialog.qml \
    qml/content/TumblerIndexHelper.js \
    qml/content/clockHelper.js \
    qml/content/AlarmViewRepeater.qml

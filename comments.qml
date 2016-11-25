import QtQuick 2.1
import QtQuick.Controls 1.0
import MuseScore 1.0

MuseScore {
    menuPath: "Plugins.Comments"
    version: "2.0"
    description: qsTr("This plugin adds comments to your score")
    //requiresScore: true // needs MuseScore > 2.0.3
    pluginType: "dialog"

    id:window
    width:  400; height: 300;
    onRun: {
        if (!curScore)
            Qt.quit();
        }

    Label {
        id: textLabel
        wrapMode: Text.WordWrap
        text: qsTr("Add your comments")
        font.pointSize:12
        anchors.left: window.left
        anchors.top: window.top
        anchors.leftMargin: 10
        anchors.topMargin: 10
        }

    TextArea {
        id:abcText
        anchors.top: textLabel.bottom
        anchors.left: window.left
        anchors.right: window.right
        anchors.bottom: window.bottom
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        width:parent.width
        height:400
        focus: true
        wrapMode: TextEdit.WrapAnywhere
        textFormat: TextEdit.PlainText
        Keys.onPressed: {
            if (!curScore || event.key == Qt.Key_Escape)
                Qt.quit()
            curScore.setMetaTag("comments", text)
            }
        Component.onCompleted: {
            if (curScore)
                text = curScore.metaTag("comments")
            }
        }
    }

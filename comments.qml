import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Window 2.2
import MuseScore 1.0
import Qt.labs.settings 1.0

MuseScore {
    menuPath : "Plugins.Comments"
    version : "2.0"
    description : qsTr("This plugin adds comments to your score")
    //pluginType : "Dialog"
    //requiresScore: true // needs MuseScore > 2.0.3


    onRun : {
        if (!curScore) {
            Qt.quit();
        } else {
            window.visible = true;
        }
    }

    Window {
        id : window
        width : 400;
        height : 300;
        visible : false
        property var score : curScore
		title : {"MuseScore : " + curScore.name;}

        Settings {
            id : settings
            category : "pluginSettings"
            property string metrics : ""
        }

        Label {
            id : textLabel
            wrapMode : Text.WordWrap
            text : qsTr("Add your comments")
            font.pointSize : 12
            anchors.left : window.left
            anchors.top : window.top
            anchors.leftMargin : 10
            anchors.topMargin : 10
        }

        TextArea {
            id : abcText

            anchors.top : textLabel.bottom
            anchors.left : window.left
            anchors.right : window.right
            anchors.bottom : window.bottom
            anchors.topMargin : 10
            anchors.bottomMargin : 10
            anchors.leftMargin : 10
            anchors.rightMargin : 10
            width : parent.width
            height : 400
            focus : true
            wrapMode : TextEdit.WrapAnywhere
            textFormat : TextEdit.PlainText
            Keys.onReleased : {
                if (event.key == Qt.Key_Escape) {
                    window.close();
                } else {
                    curScore.setMetaTag("comments", abcText.text)
                }
            }
            Component.onCompleted : {
                if (curScore)
                    text = curScore.metaTag("comments")
            }
        }
        Component.onCompleted : {
            if (curScore) {
                var metrics = settings.metrics;
                if (metrics) {
                    metrics = JSON.parse(metrics);
                    window.x = metrics.x;
                    window.y = metrics.y;
                    window.width = metrics.width;
                    window.height = metrics.height;
                }
            }
        }
        onClosing : {
            if (curScore) {
                var metrics = {
                    x : window.x,
                    y : window.y,
                    width : window.width,
                    height : window.height
                }
                curScore.setMetaTag("comments", abcText.text)
                settings.metrics = JSON.stringify(metrics);
            }
            Qt.quit()
        }
        onActiveChanged : {
            if (active) {
                if (score != curScore) {
					window.title = "MuseScore : " + curScore.name;
                    abcText.text = curScore.metaTag("comments");
                    score = curScore;
                }
            }
        }
    }
}

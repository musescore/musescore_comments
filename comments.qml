import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Window 2.2
import MuseScore 1.0
import Qt.labs.settings 1.0

MuseScore {
    menuPath : "Plugins.Comments"
    version : "2.0"
    description : qsTr("This plugin adds comments to your score")
    //SL Removed plugin type as it's not really a dialog anymore and is causing two windows to be present on MAC
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
	//SL Added variable to hold the score current to this plugin
        property var score : curScore
	//SL Added title so it is obvious which score the text will be added to
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
	    //SL Changed from onPressed as in some circumstances the last key pressed was lost.
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
	//Added onActiveChanged so we can test if the score has been changed.
        onActiveChanged : {
            if (active) {
                if (score != curScore) {
		    //Add new scorename to title
                    window.title = "MuseScore : " + curScore.name;
		    //Update the new score text
                    abcText.text = curScore.metaTag("comments");
		    //Now working on the new score
                    score = curScore;
                }
            }
        }
    }
}

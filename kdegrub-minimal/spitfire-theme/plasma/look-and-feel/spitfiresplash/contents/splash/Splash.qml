import QtQuick 2.5

Rectangle {
    id: root
    anchors.fill: parent
    color: "black" // Fallback color if image fails to load

    property int stage

    // Background image stretched to full screen
    Image {
        id: background
        anchors.fill: parent
        source: "images/background.png"
        fillMode: Image.Stretch // Forces image to stretch to fill screen
        opacity: 1.0
        asynchronous: true
        cache: true
    }

    // Very subtle dark overlay for better content visibility
    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.1
    }

    onStageChanged: {
        if (stage == 1) {
            introAnimation.running = true;
        } else if (stage == 5) {
            introAnimation.target = busyIndicator;
            introAnimation.from = 1;
            introAnimation.to = 0;
            introAnimation.running = true;
        }
    }

    Item {
        id: content
        anchors.fill: parent
        opacity: 0
        TextMetrics {
            id: units
            text: "M"
            property int gridUnit: boundingRect.height
            property int largeSpacing: units.gridUnit
            property int smallSpacing: Math.max(2, gridUnit/4)
        }

        Image {
            id: logo
            property real size: units.gridUnit * 8
            anchors.centerIn: parent
            source: "images/archlogo.svg"
            sourceSize.width: size
            sourceSize.height: size
            smooth: true
            antialiasing: true
        }

        Image {
            id: busyIndicator
            y: parent.height - (parent.height - logo.y) / 2 - height/2
            anchors.horizontalCenter: parent.horizontalCenter
            source: "images/busy01.svg"
            sourceSize.height: units.gridUnit * 3
            sourceSize.width: units.gridUnit * 3
            smooth: true
            antialiasing: true

            RotationAnimator on rotation {
                id: rotationAnimator
                from: 0
                to: 360
                duration: 800
                loops: Animation.Infinite
            }
        }
    }

    OpacityAnimator {
        id: introAnimation
        running: false
        target: content
        from: 0
        to: 1
        duration: 1000
        easing.type: Easing.InOutQuad
    }
}

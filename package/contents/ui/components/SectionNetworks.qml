import QtQuick 2.5
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.15

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.networkmanagement 0.2 as PlasmaNM
import "../lib" as Lib

Lib.Card {
    id: sectionNetworks
    anchors.fill: parent
    z: 999
    visible: false      
    
    // NETWORK
    property real rxBytesR
    property real txBytesR
    Network {
        id: network
    }
    
    function toggleNetworkSection() {
        if(!sectionNetworks.visible) {
            wrapper.visible = false
            sectionNetworks.visible = true
        } else {
            wrapper.visible = true
            sectionNetworks.visible = false
        }
    }
    
    Item {
        anchors.fill: parent
        anchors.margins: root.smallSpacing
        clip: true

        ColumnLayout {
            id: sectionNetworksHeader
            width: parent.width
            spacing: root.smallSpacing
            RowLayout{
                height: implicitHeight + root.smallSpacing
                PlasmaComponents.ToolButton {
                    Layout.preferredHeight: root.largeFontSize*2.5
                    iconSource: "arrow-left"

                    onClicked: {
                        sectionNetworks.toggleNetworkSection()
                    }
                }
                PlasmaComponents.Label {
                    text: i18n("Network Connections")
                    font.pixelSize: root.largeFontSize * 1.2
                    Layout.fillWidth: true
                }
            }
            PlasmaCore.SvgItem {
                id: separatorLine
                elementId: "horizontal-line"
                Layout.fillWidth: true
                Layout.preferredHeight: root.scale
                svg: PlasmaCore.Svg {
                    imagePath: "widgets/line"
                }
            }
            Item {
                Layout.fillHeight: true
            }
        }
        ListView {
            anchors {
                left: parent.left
                right: parent.right
                top: sectionNetworksHeader.bottom
                bottom: trafficMonitorGraph.top
            }
            ScrollBar.vertical: ScrollBar {}
            model: network.appletProxyModel
            clip: true
            
            delegate: ConnectionItem {
                width: parent.width
                height: root.buttonHeight
                property bool sectionActive: isDefault && sectionNetworks.visible
                onSectionActiveChanged: {
                    if (sectionActive) {
                        if (!PlasmaNM.Configuration.airplaneModeEnabled) {
                            network.handler.requestScan()
                        }
                        network.networkModel.setDeviceStatisticsRefreshRateMs(DevicePath, 2000)
                    } else {
                        network.networkModel.setDeviceStatisticsRefreshRateMs(DevicePath, 0)
                    }
                }
                Timer {
                    id: scanTimer
                    interval: 10200
                    repeat: true
                    running: sectionActive && !PlasmaNM.Configuration.airplaneModeEnabled
                    onTriggered: network.handler.requestScan()
                }
                Timer {
                    repeat: true
                    interval: 2000
                    running: sectionActive
                    triggeredOnStart: true
                    property real prevRxBytes
                    property real prevTxBytes
                    Component.onCompleted: {
                        prevRxBytes = 0
                        prevTxBytes = 0
                    }
                    onTriggered: {
                        sectionNetworks.rxBytesR = prevRxBytes == 0 ? 0 : (RxBytes - prevRxBytes) * 1000 / interval
                        sectionNetworks.txBytesR = prevTxBytes == 0 ? 0 : (TxBytes - prevTxBytes) * 1000 / interval
                        prevRxBytes = RxBytes
                        prevTxBytes = TxBytes
                    }
                }
            }
        }
        TrafficMonitor {
            id: trafficMonitorGraph
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            height: parent.height*0.25
            downloadSpeed: sectionNetworks.rxBytesR
            uploadSpeed: sectionNetworks.txBytesR
        }
    }
}

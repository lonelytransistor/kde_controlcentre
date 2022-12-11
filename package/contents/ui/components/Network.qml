import QtQml 2.0
import QtQuick 2.0
import org.kde.plasma.networkmanagement 0.2 as PlasmaNM

Item {
    property var appletProxyModel: appletProxyModel
    property var networkModel: networkModel
    property var networkStatus: networkStatus.networkStatus
    property var activeConnectionIcon: activeConnectionIcon.connectionIcon
    property var handler: handler
    
    PlasmaNM.ConnectionIcon {
        id: activeConnectionIcon
    }
    PlasmaNM.Handler {
        id: handler
    }
    PlasmaNM.NetworkStatus {
        id: networkStatus
    }
    PlasmaNM.NetworkModel {
        id: networkModel
    }
    PlasmaNM.AppletProxyModel {
        id: appletProxyModel
        sourceModel: networkModel
    }
}

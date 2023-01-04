import QtQuick 2.15
import QtQuick.Controls 2.15

import TouchArea 1.0

TouchArea {
    id: touchRoot
    property int activeTouches: 0
    property var activeArea: null
    property var areas: []
    property var append: function(area) {
        for (var ix = areas.length-1; ix < area.z; ix++) {
            areas.push([]);
        }
        areas[area.z].push(area);
    }
    property var remove: function(area) {
        for (var ix = 0; ix < areas.length; ix++) {
            const ix2 = areas.indexOf(area)
            if (ix2 > -1) {
                areas[ix].splice(ix2, 1)
            }
        }
    }

    function convertEventToLocal(ev) {
        let end = mapToItem(activeArea, ev.endX, ev.endY)
        let start = mapToItem(activeArea, ev.startX, ev.startY)
        let pos = mapToItem(activeArea, ev.x, ev.y)
        return {"x": pos.x,
            "y": pos.y,
            "startX": start.x,
            "startY": start.y,
            "endX": end.x,
            "endY": end.y,
            "button": ev.button,
            "id": ev.id,
            "state": ev.state,
            "accepted": ev.accepted
        }
    }
    function findActiveArea(ev) {
        if (activeArea == null) {
            for (var z = areas.length-1; z >= 0; z--) {
                for (const area of areas[z]) {
                    let point = mapToItem(area, ev.x, ev.y)
                    if (point.x > 0 && point.y > 0 && point.x < area.width && point.y < area.height && area.enabled) {
                        activeArea = area
                        return activeArea
                    }
                }
            }
        } else {
            return activeArea
        }
    }
    onTouchPress: {
        if (findActiveArea(ev) != null) {
            let ev2 = convertEventToLocal(ev);
            activeArea.touchPress(ev2);
            if (!ev2.accepted) {
                ev.accepted = false;
                activeArea = null;
            } else {
                ev.accepted = true;
                activeTouches += 1;
            }
        } else {
            ev.accepted = false;
        }
    }
    onTouchRelease: {
        if (activeArea != null) {
            activeArea.touchRelease(convertEventToLocal(ev));
            ev.accepted = true;
            activeTouches -= 1;
            if (activeTouches <= 0) {
                activeArea = null;
            }
        } else {
            activeTouches = 0;
            ev.accepted = false;
        }
    }
    onTouchMove: {
        if (activeArea != null) {
            activeArea.touchMove(convertEventToLocal(ev));
            ev.accepted = true;
        } else {
            ev.accepted = false;
        }
    }

    onMousePress: {
        if (findActiveArea(ev) != null) {
            let ev2 = convertEventToLocal(ev);
            activeArea.mousePress(ev2);
            if (!ev2.accepted) {
                ev.accepted = false;
                activeArea = null;
            } else {
                ev.accepted = true;
            }
        } else {
            ev.accepted = false;
        }
    }
    onMouseRelease: {
        if (activeArea != null) {
            activeArea.mouseRelease(convertEventToLocal(ev));
            ev.accepted = true;
            activeArea = null;
        } else {
            ev.accepted = false;
        }
    }
    onMouseMove: {
        if (activeArea != null) {
            activeArea.mouseMove(convertEventToLocal(ev));
            ev.accepted = true;
        } else {
            ev.accepted = false;
        }
    }
}

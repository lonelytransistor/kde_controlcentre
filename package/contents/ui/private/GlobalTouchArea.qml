import QtQuick 2.15
import QtQuick.Controls 2.15

import TouchArea 1.0

TouchArea {
    id: touchRoot
    anchors.fill: parent

    property int activeTouches: 0
    property var activeArea: null
    property var areas: []
    z: 1
    property var append: function(area) {
        areas.push(area);
    }
    property var remove: function(area) {
        const ix = areas.indexOf(area)
        if (ix > -1) {
            areas.splice(ix, 1)
            return;
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
    function findActiveAreas(ev) {
        var _areas = [];
        for (const area of areas) {
            let point = mapToItem(area, ev.x, ev.y)
            if (point.x > 0 && point.y > 0 && point.x < area.width && point.y < area.height && area.enabled) {
                for (var ix = _areas.length-1; ix < area.z; ix++) {
                    _areas.push([]);
                }
                _areas[area.z].push(area);
            }
        }
        return _areas;
    }
    function findActiveArea(ev) {
        if (activeArea == null) {
            var _areas = findActiveAreas(ev);
            for (var ix = _areas.length-1; ix >= 0; ix--) {
                if (_areas[ix].length > 0) {
                    activeArea = _areas[ix][0];
                    return _areas[ix][0];
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
            ev.accepted = true;
            let ev2 = convertEventToLocal(ev);
            activeArea.touchMove(ev2);
            if (!ev2.accepted) {
                touchRelease(ev);
                ev.reemulate = true;
                ev.accepted = false;
                activeArea = null;
                activeTouches = 0;
            }
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

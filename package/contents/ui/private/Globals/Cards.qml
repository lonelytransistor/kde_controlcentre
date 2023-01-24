import QtQuick 2.0

Item {
    Item {
        id: cardsStore
        property var expandedCards: []
        property double fraction: 0.0
    }
    readonly property double fraction: cardsStore.fraction
    readonly property var update: function(fraction) {
        cardsStore.fraction = fraction;
    }
    readonly property var expand: function(card, subcard) {
        collapseAll();
        cardsStore.expandedCards.push({"card": card, "subcard": subcard});

        subcard.state = "expanded";
        card.expanded();
    }
    readonly property var collapse: function(card, subcard) {
        subcard.state = "collapsed";
        card.collapsed();

        for (var ix = 0; ix < cardsStore.expandedCards.length; ix++) {
            var _card = cardsStore.expandedCards;
            if (_card.card == card) {
                cardsStore.expandedCards.splice(ix, 1);
            }
        }
    }
    readonly property var collapseAll: function() {
        while (cardsStore.expandedCards.length) {
            var _card = cardsStore.expandedCards.pop();
            collapse(_card.card, _card.subcard);
        }
    }
}

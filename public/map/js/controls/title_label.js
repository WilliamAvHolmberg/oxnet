'use strict';

export var TitleLabel = L.Control.extend({
    options: {
        position: 'topleft'
    },

    onAdd: function (map) {
        var container = L.DomUtil.create('div');
        container.id = 'titleLabel';
        container.href = 'http://osbot.org/forum/user/192661-explv/';
        container.innerHTML = "Suicide Squad";

        L.DomEvent.disableClickPropagation(container);
        return container;
    }
});
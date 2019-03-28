'use strict';

import Locations from '../model/Locations.js';
import {Position} from '../model/Position.js';

export var PlayerLookupControl = L.Control.extend({

    options: {
        position: 'topleft',
    },
    data: {

    },

    onAdd: function (map) {

        var self = this;
        this.map = map;

        this._autorefresh = true;

        var addressPoints = [];
        addressPoints = addressPoints.map(function (p) { return [p[0], p[1]]; });
        this.heat = L.heatLayer(addressPoints, {minOpacity: 0.8});
        this.markers = L.markerClusterGroup({
            showCoverageOnHover: true
        });
        this.markerCache = {};
        map.addLayer(this.heat);
        map.addLayer(this.markers);
        this._updatePlayerData(this, map);
        setInterval(function() { if(this._autorefresh) this._updatePlayerData(this, map); }.bind(this), 7000);

        var container = L.DomUtil.create('div', 'leaflet-bar leaflet-control');
        container.style.background = 'none';
        container.style.width = '200px';
        container.style.height = 'auto';

        var nameInput = L.DomUtil.create('input', 'leaflet-bar leaflet-control leaflet-control-custom', container);
        nameInput.id = 'player-lookup';
        nameInput.type = 'text';
        nameInput.placeholder = String.fromCharCode(0xF007) + " Find a player";
        $(nameInput).css('font-family', "Arial, FontAwesome");

        $(nameInput).autocomplete({
            minLength: 2,
            source: function (request, response) {
                response($.ui.autocomplete.filter(self.searchData, request.term));
            },
            focus: function (event, ui) {
                $("#player-lookup").val(ui.item.label);
                return false;
            },
            select: function (event, ui) {
                var marker = ui.item.marker;
                $("#player-lookup").val(ui.item.label);
                var latLngs = [ marker.getLatLng() ];
                var markerBounds = L.latLngBounds(latLngs);

                map.fitBounds(markerBounds);

                setTimeout(function() {
                    self._openMarker(marker);
                }, 250);

                return false;
            }
        });

        this.refreshButton = L.DomUtil.create('a', 'leaflet-bar leaflet-control leaflet-control-custom', container);
        this.refreshButton.id = 'toggle-map-labels';
        this.refreshButton.innerHTML = 'Auto Refresh Players';

        L.DomEvent.on(this.refreshButton, 'click', this._toggleAutoRefresh, this);

        L.DomEvent.disableClickPropagation(container);

        return container;
    },

    _openMarker: function(marker){
        var self = this;
        var parent = self.markers.getVisibleParent(marker);
        if(parent != null && typeof parent.spiderfy !== "undefined")
            parent.spiderfy();
         setTimeout(function() {
            marker.openPopup();
        }, 250);
    },

    _toggleAutoRefresh: function(){
        if (this._autorefresh) {
            this._autorefresh = false;
        } else {
            this._autorefresh = true;
            this._updatePlayerData(this, this.map);
        }
        $(this.refreshButton).css('background-color', this._autorefresh ? "inherit" : "red");
        $(this.refreshButton).html(this._autorefresh ? "Auto Refresh Players" : "- Refresh Disabled -");
    },

    _updatePlayerData: function(self, map){
        if(document.visibilityState != "visible")
            return;
        $.getJSON("../accounts/get_player_positions", function(data){
            var newSearchData = [];
            var posData = [];
            var unusedmarkers = {...self.markerCache}
            data.forEach(function(pos) {
                var latlng = new Position(pos[0], pos[1], 0).toCentreLatLng(map)
                // console.log(latlng);
                posData.push([latlng.lat, latlng.lng, 0.1]);

                var player_id = pos[2];
                var player_name = pos[3];
                var marker = self.markerCache[player_id];
                if (marker == undefined) {
                    var task_name = pos[4];
                    var world = pos[5];
                    var created_ago = pos[6];
                    var computer = pos[7];
                    marker = L.marker(new L.LatLng(latlng.lat, latlng.lng), {title: player_id});
                    var popup = `<a target="_blank" href="/accounts/${player_id}">
                            <h4 style="cursor:pointer; margin-bottom:1px;">${player_name}</h4>
                            <i class="fas fa-globe"></i> <b>${world}</b>
                            <i class="fas fa-id-badge"></i> <b>${player_id}</b>
                            <i class="fas fa-clock-o"></i> <b>${created_ago}</b>
                            <i class="fas fa-server"></i> <b>${computer}</b>
                            <br/>${task_name}</a><br/>
                            <a class="btn btn-danger" onclick="$.getJSON('../accounts/${player_id}/disconnect', function(data) {if(!data['success']) alert(data);});">Disconnect</a>`;
                    marker.bindPopup(popup);
                    marker.on('mouseenter', function (e) {
                        marker.clicked = false;
                    });
                    marker.on('mouseover', function (e) {
                        marker.open = true;
                        this.openPopup();
                    });
                    marker.on('click', function (e) {
                        marker.clicked = true;
                        marker.open = true;
                        this.openPopup();
                    });
                    marker.on('mouseout', function (e) {
                        if(!marker.clicked) {
                            this.closePopup();
                            marker.open = false;
                        }
                    });
                    self.markerCache[player_id] = marker;
                    self.markers.addLayer(marker);
                } else {
                    var wasOpen = marker.getPopup()._isOpen;
                    marker.setLatLng(new L.LatLng(latlng.lat, latlng.lng));
                    var thisMarker = marker;
                    if (wasOpen) setTimeout(function(){ self._openMarker(thisMarker) }, 2000);
                }
                newSearchData.push({ label: player_name, value: marker.getLatLng(), marker: marker });
                delete unusedmarkers[player_id];
            });
            for (var key in unusedmarkers){
                self.markers.removeLayer(self.markerCache[key]);
                delete self.markerCache[key];
            }
            self.markers.refreshClusters();
            map.removeLayer(self.heat);
            self.heat = L.heatLayer(posData, {minOpacity: 0.8, defaultGradient:{.8:"blue",.86:"cyan",.9:"lime",.93:"yellow",1:"red"}});
            map.addLayer(self.heat);

            self.searchData = newSearchData;
        });
    }

});
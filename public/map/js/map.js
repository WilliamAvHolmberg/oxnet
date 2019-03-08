'use strict';

import {Position} from './model/Position.js';

// Import controls
import {CollectionControl} from './controls/collection_control.js';
import {CoordinatesControl} from './controls/coordinates_control.js';
import {LocalCoordinatesControl} from './controls/local_coordinates_control.js';
import {RegionBaseCoordinatesControl} from './controls/region_base_coordinates_control.js';
import {GridControl} from './controls/grid_control.js';
import {LocationLookupControl} from './controls/location_lookup_control.js';
import {MapLabelControl} from './controls/map_label_control.js';
import {PlaneControl} from './controls/plane_control.js';
import {RegionLabelsControl} from './controls/region_labels_control.js';
import {RegionLookupControl} from './controls/region_lookup_control.js';
import {TitleLabel} from './controls/title_label.js';

$(document).ready(function () {

    var map = L.map('map', {
        //maxBounds: L.latLngBounds(L.latLng(-40, -180), L.latLng(85, 153))
        zoomControl: false,
        renderer: L.canvas()
    }).setView([-79, -137], 7);

    map.plane = 0;

    map.updateMapPath = function() {
        if (map.tile_layer !== undefined) {
            map.removeLayer(map.tile_layer);
        }
        map.tile_layer = L.tileLayer('https://raw.githubusercontent.com/Explv/osrs_map_full_2019_02_09/master/' + map.plane + '/{z}/{x}/{y}.png', {
            minZoom: 4,
            maxZoom: 11,
            attribution: 'Map data',
            noWrap: true,
            tms: true
        });
        map.tile_layer.addTo(map);
        map.invalidateSize();
    }

    map.updateMapPath();
    map.getContainer().focus();

    map.addControl(new TitleLabel());
    map.addControl(new CoordinatesControl());
    map.addControl(new RegionBaseCoordinatesControl());
    map.addControl(new LocalCoordinatesControl());
    map.addControl(L.control.zoom());
    map.addControl(new PlaneControl());
    map.addControl(new LocationLookupControl());
    map.addControl(new MapLabelControl());
    map.addControl(new CollectionControl({ position: 'topright' }));
    map.addControl(new RegionLookupControl());
    map.addControl(new GridControl());
    map.addControl(new RegionLabelsControl());
    
    var prevMouseRect, prevMousePos;
    map.on('mousemove', function(e) {
        var mousePos = Position.fromLatLng(map, e.latlng, map.plane);

        if (prevMousePos !== mousePos) {

            prevMousePos = mousePos;

            if (prevMouseRect !== undefined) {
                map.removeLayer(prevMouseRect);
            }

            prevMouseRect = mousePos.toLeaflet(map);
            prevMouseRect.addTo(map);
        }
    });

    var addressPoints = [];
    addressPoints = addressPoints.map(function (p) { return [p[0], p[1]]; });
    var heat = L.heatLayer(addressPoints, {minOpacity: 0.8});
    var markers = L.markerClusterGroup();
    map.addLayer(heat);
    map.addLayer(markers);
    var markerCache = {};
    function update_player_data(){
        if(document.visibilityState != "visible")
            return;
        $.getJSON("../accounts/get_player_positions", function(data){
            var posData = [];
            var unusedmarkers = {...markerCache}
            data.forEach(function(pos) {
                var latlng = new Position(pos[0], pos[1], 0).toCentreLatLng(map)
                console.log(latlng);
                posData.push([latlng.lat, latlng.lng, 0.1]);

                var player_id = pos[2];
                var marker = markerCache[player_id];
                if (marker == undefined) {
                    var player_name = pos[3];
                    var task_name = pos[4];
                    var world = pos[5];
                    marker = L.marker(new L.LatLng(latlng.lat, latlng.lng), {title: player_id});
                    var popup = `<a target="_blank" href="/accounts/${player_id}">
                                <h4 style="cursor:pointer; margin-bottom:1px;">${player_name}</h4>
                                <i class="fa fa-globe"></i> <b>${world}</b>
                                <i class="fa fa-id-badge"></i> <b>${player_id}</b><br/>${task_name}</a>`;
                    marker.bindPopup(popup);
                    markerCache[player_id] = marker;
                    markers.addLayer(marker);
                }else{
                    marker.setLatLng(new L.LatLng(latlng.lat, latlng.lng));
                }
                delete unusedmarkers[player_id];
            });
            for (var key in unusedmarkers){
                markers.removeLayer(markerCache[key]);
                delete markerCache[key];
            }
            markers.refreshClusters();
            map.removeLayer(heat);
            heat = L.heatLayer(posData, {minOpacity: 0.8});
            map.addLayer(heat);
        });
    }
    update_player_data();
    setInterval(update_player_data, 7000);
    // var draw = true;
    // map.on({
    //     movestart: function () { draw = false; },
    //     moveend:   function () { draw = true; },
    //     mousemove: function (e) {
    //         if (draw) {
    //
    //             heat.addLatLng(e.latlng);
    //         }
    //     }
    // })
});

//**** MOBILE SCALING ****//
var viewport = document.querySelector("meta[name=viewport]");
if (viewport) {
    var content = viewport.getAttribute("content");
    var parts = content.split(",");
    for (var i = 0; i < parts.length; ++i) {
        var part = parts[i].trim();
        var pair = part.split("=");
        if (pair[0] === "min-width") {
            var minWidth = parseInt(pair[1]);
            if (screen.width < minWidth) {
                document.head.removeChild(viewport);

                var newViewport = document.createElement("meta");
                newViewport.setAttribute("name", "viewport");
                newViewport.setAttribute("content", "width=" + minWidth);
                document.head.appendChild(newViewport);
                break;
            }
        }
    }
}
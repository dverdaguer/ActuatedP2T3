import { useEffect } from "react";
import L from "leaflet";
import "leaflet/dist/leaflet.css";
import "leaflet/dist/images/marker-icon.png";
import "leaflet/dist/images/marker-shadow.png";

const vehicleIcons = {
  bike: L.icon({
    iconUrl: "https://cdn-icons-png.flaticon.com/512/2015/2015415.png",
    iconSize: [32, 32],
  }),
  car: L.icon({
    iconUrl: "https://cdn-icons-png.flaticon.com/512/741/741407.png",
    iconSize: [32, 32],
  }),
  bus: L.icon({
    iconUrl: "https://cdn-icons-png.flaticon.com/512/2418/2418779.png",
    iconSize: [32, 32],
  }),
  train: L.icon({
    iconUrl: "https://cdn-icons-png.flaticon.com/512/1920/1920478.png",
    iconSize: [32, 32],
  }),
};

export default function ToioMapping() {
  useEffect(() => {
    if (typeof window !== "undefined") {
      const map = L.map("map", {
        center: [41.7943, -87.5907],
        zoom: 14,
      });

      L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
        attribution: "&copy; OpenStreetMap contributors",
      }).addTo(map);

      const movingObjects = [
        { id: 1, type: "bike", lat: 41.7923, lng: -87.5957 },
        { id: 2, type: "car", lat: 41.7963, lng: -87.5897 },
        { id: 3, type: "bus", lat: 41.7983, lng: -87.5857 },
        { id: 4, type: "train", lat: 41.8003, lng: -87.5827 },
      ];

      const markers = movingObjects.map((obj) =>
        L.marker([obj.lat, obj.lng], { icon: vehicleIcons[obj.type] }).addTo(map)
      );

      return () => {
        map.remove();
      };
    }
  }, []);

  return <div id="map" style={{ width: "100vw", height: "100vh" }}></div>;
}

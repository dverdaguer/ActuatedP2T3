import { useEffect } from "react";
import L from "leaflet";
import "leaflet/dist/leaflet.css";

const vehicleIcons = {
  bike: L.icon({
    iconUrl: "/bike.png",
    iconSize: [32, 32],
    iconAnchor: [16, 32],
    popupAnchor: [0, -32],
    className: "marker-outline",
  }),
  car: L.icon({
    iconUrl: "/car.png",
    iconSize: [32, 32],
    iconAnchor: [16, 32],
    popupAnchor: [0, -32],
    className: "marker-outline",
  }),
  bus: L.icon({
    iconUrl: "/bus.png",
    iconSize: [32, 32],
    iconAnchor: [16, 32],
    popupAnchor: [0, -32],
    className: "marker-outline",
  }),
  train: L.icon({
    iconUrl: "/train.png",
    iconSize: [32, 32],
    iconAnchor: [16, 32],
    popupAnchor: [0, -32],
    className: "marker-outline",
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
        { id: 1, type: "bike", lat: 41.7923, lng: -87.5957, name: "Bike" },
        { id: 2, type: "car", lat: 41.7963, lng: -87.5897, name: "Car" },
        { id: 3, type: "bus", lat: 41.7983, lng: -87.5857, name: "Bus" },
        { id: 4, type: "train", lat: 41.8003, lng: -87.5827, name: "Train" },
      ];

      movingObjects.forEach((obj) => {
        L.marker([obj.lat, obj.lng], { icon: vehicleIcons[obj.type] })
          .addTo(map)
          .bindTooltip(obj.name, { permanent: false, direction: "top", offset: [0, -16] });
      });

      return () => {
        map.remove();
      };
    }
  }, []);

  return (
    <>
      <style>{`
        .marker-outline img {
          filter: drop-shadow(0px 0px 3px black);
        }
      `}</style>
      <div id="map" style={{ width: "100vw", height: "100vh" }}></div>
    </>
  );
}
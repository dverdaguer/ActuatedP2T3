import { useEffect, useState } from "react";
import L from "leaflet";
import "leaflet/dist/leaflet.css";
import data from "./data.json";

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

const transportTypes = ['bikes', 'cars', 'buses', 'trains'];

export default function ToioMapping() {
  const [transportType, changeType] = useState(0);

  useEffect(() => {
    if (typeof window !== "undefined") {
      const map = L.map("map", {
        center: [41.7943, -87.5907],
        zoom: 14,
      });

      L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
        attribution: "&copy; OpenStreetMap contributors",
      }).addTo(map);

      const movingObjects = data[transportTypes[transportType]];

      movingObjects.forEach((obj) => {
        L.marker([obj.lat, obj.lng], { icon: vehicleIcons[obj.type] })
          .addTo(map)
          .bindTooltip(obj.name, { permanent: false, direction: "top", offset: [0, -16] });
      });

      return () => {
        map.remove();
      };
    }
  }, [transportType]);

  return (
    <>
      <style>{`
        .marker-outline img {
          filter: drop-shadow(0px 0px 3px black);
        }
      `}</style>
      <button onClick={() => {changeType((transportType + 1) % 4)}}>CHANGE TYPE</button>
      <div className="toiomat"></div>
      <div id="map" style={{ width: "100vw", height: "100vh" }}></div>
    </>
  );
}
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

const transportTypes = ["bikes", "cars", "buses", "trains"];

export default function ToioMapping() {
  const [transportType, changeType] = useState(0);
  const [iconPositions, setIconPositions] = useState([]);

  useEffect(() => {
    if (typeof window !== "undefined") {
      // Load saved center from localStorage or use default center
      const savedCenter = JSON.parse(localStorage.getItem("mapCenter")) || { lat: 41.7943, lng: -87.5907 };

      const map = L.map("map", {
        center: [savedCenter.lat, savedCenter.lng],
        zoom: 16,
      });

      L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
        attribution: "&copy; OpenStreetMap contributors",
      }).addTo(map);

      // Function to update localStorage with new center
      const updateCenter = () => {
        const center = map.getCenter();
        localStorage.setItem("mapCenter", JSON.stringify({ lat: center.lat, lng: center.lng }));
      };

      // Update center in localStorage whenever the map moves
      map.on("moveend", updateCenter);

      // Function to update positions inside rectangle
      const updatePositions = () => {
        const rectElement = document.getElementById("fixed-rectangle");
        const rectBounds = rectElement.getBoundingClientRect();
        const movingObjects = data[transportTypes[transportType]];
        let newIconPositions = [];

        movingObjects.forEach((obj) => {
          const point = map.latLngToContainerPoint([obj.lat, obj.lng]);
            L.marker([obj.lat, obj.lng], { icon: vehicleIcons[obj.type] })
              .addTo(map)
              .bindTooltip(obj.name, { permanent: false, direction: "top", offset: [0, -16] });
          // Check if the marker is inside the fixed rectangle
          if (
            point.x >= rectBounds.left &&
            point.x <= rectBounds.right &&
            point.y >= rectBounds.top &&
            point.y <= rectBounds.bottom
          ) {
            // Normalize to 0-100 range inside the rectangle
            const relativeX = ((point.x - rectBounds.left) / rectBounds.width) * 100;
            const relativeY = ((point.y - rectBounds.top) / rectBounds.height) * 100;

            newIconPositions.push({
              name: obj.name,
              type: obj.type,
              relativeX: Math.max(0, Math.min(100, relativeX)),
              relativeY: Math.max(0, Math.min(100, relativeY)),
            });
          }
        });

        setIconPositions(newIconPositions);
      };

      // Update positions when the map moves or zooms
      map.on("moveend", updatePositions);
      map.on("zoomend", updatePositions);

      // Initial calculation
      updatePositions();

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
        #fixed-rectangle {
          position: fixed;
          left: 50%;
          top: 50%;
          width: 600px;
          height: 600px;
          transform: translate(-50%, -50%);
          border: 2px solid red;
          background: rgba(255, 0, 0, 0.1);
          z-index: 1000;
          pointer-events: none;
        }
        #position-display {
          position: fixed;
          left: 10px;
          top: 10px;
          background: white;
          padding: 10px;
          font-size: 14px;
          border-radius: 5px;
          z-index: 1000;
        }
      `}</style>
      <button onClick={() => changeType((transportType + 1) % 4)}>CHANGE TYPE</button>
      <div id="map" style={{ width: "100vw", height: "100vh", position: "relative", zIndex: 0 }}></div>

      {/* Fixed Rectangle Stays on Top */}
      <div id="fixed-rectangle"></div>

      {/* Display Relative Positions */}
      <div id="position-display">
        <strong>Relative Positions (0,0 → 100,100):</strong>
        <ul>
          {iconPositions.map((obj, index) => (
            <li key={index}>
              {obj.name} ({obj.type}): X: {obj.relativeX.toFixed(2)}, Y: {obj.relativeY.toFixed(2)}
            </li>
          ))}
        </ul>
      </div>
    </>
  );
}

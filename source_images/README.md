# Source Handwritten Images Directory Guide

This directory contains high-resolution image extractions of the original handwritten coursework submission (`dbms da-2.pdf`) submitted by Aakshaj Srivastava (25BAI1484) for Database Systems DA-II.

---

## Page Catalog

| Image Filename | Title / Section | Contents |
| :--- | :--- | :--- |
| [`page_1.png`](page_1.png) | **Table Definitions 1–7** | • Title: `DA - 2 (DBMS)`<br>• 1. Region (`Region-ID`, `Region-Name`, `Region-Type`, `Location`)<br>• 2. Fleet (`Fleet-ID`, `Fleet-Name`, `Region-ID`, `Fleet-type`, `Fleet-status`)<br>• 3. Drone (`Drone-ID`, `Drone-Model`, `Fleet-ID`, `Payload-capacity`, `Battery-capacity`, `Drone-Type`, `Manufacture-Date`)<br>• 4. Operator (`Operator-ID`, `Licence-no`, `Certification-Date`, `Certification-Expiry`, `Pilot-Rating`)<br>• 5. Human Pilot (`Operator-ID`, `Licence-No`, `Certification-Expiry`, `Pilot-Rating`)<br>• 6. AI Pilot (`Operator-ID`, `AI-Version`, `Certification-status`, `Autonomy-level`)<br>• 7. Drone-Operator-Assignment (`Assignment-ID`, `Drone-ID`, `Operator-ID`, `Assignment-Date`, `Assignment-Status`, `Missiontype`) |
| [`page_2.png`](page_2.png) | **Table Definitions 8–15** | • 8. GPS-Route (`Route-ID`, `Route-Name`, `Start-Location`, `End-Location`, `Route-distance`, `Route-status`)<br>• 9. Mission (`Mission-ID`, `Drone-ID`, `Operator-ID`, `Route-ID`, `Mission-objective`, `Mission-date`, `Weather`, `Payload-Information`, `Battery-Usage`, `Mission-status`)<br>• 10. Battery (`Battery-ID`, `Drone-ID`, `Battery-Type`, `Battery-capacity`, `Current-level`, `Battery-status`, `Lastupdate`)<br>• 11. Maintenance (`Maintenance-ID`, `Drone-ID`, `Maintenance-type`, `Maintenance-description`)<br>• 12. Charging Station (`Station-ID`, `Station name`, `Region-ID`, `Charging-capacity`, `Station-status`)<br>• 13. Charging Schedule (`Station-ID`, `Drone-ID`, `Charging-status`, Composite PK)<br>• 14. Emergency Event (`Emergency-ID`, `Drone-ID`, `Mission-ID`, `Emergency-desc`, `Status`)<br>• 15. Flight-Permission (`Permission-ID`, `Drone-ID`, `Mission-ID`, `Expiry-date`, `Permission-status`, `Issuing Authority`) |
| [`page_3.png`](page_3.png) | **Sample Inserts 1–5** | • Region: 1 (Chennai), 2 (Bengaluru), 3 (Hyderabad), 4 (Coimbatore)<br>• Fleet: 101 (Fleet-A), 102 (Fleet-B), 103 (Fleet-C), 104 (Fleet-D)<br>• Drone: 201 (DJI), 202 (DJI), 203 (SYE/Skydio), 204 (Agras T40), 205 (Parrot Anafi)<br>• Operator: 301 (Rahul), 302 (Priya), 303 (Arun), 304 (Drone-AI)<br>• Human Pilot: 301 (LIC101), 302 (LIC102), 303 (LIC103) |
| [`page_4.png`](page_4.png) | **Sample Inserts 10–13** | • Battery: 701–705 (Lithium battery telemetry)<br>• Maintenance: 801–805 (Sensors, checks, motor repair, updates)<br>• Charging Station: 901–904 (Chennai, Bengaluru, Hyderabad, Coimbatore)<br>• Charging Schedule: 5 scheduled slots (Station 901–904, Drones 201–205) |
| [`page_5.png`](page_5.png) | **Sample Inserts 14–15** | • Emergency Event: 1001 (Comms failure), 1002 (Emergency landing), 1003 (Battery failure)<br>• Flight Permissions: 1101–1105 (DGCA approvals)<br>• Bottom heading: *Displaying table structure and contents of all tables* (referencing Question 2 screenshots in `screenshots/`) |

---

## Related Documentation
- Complete typed transcriptions: [`docs/source_transcription.md`](../docs/source_transcription.md)
- Inconsistency analysis: [`docs/discrepancies.md`](../docs/discrepancies.md)
